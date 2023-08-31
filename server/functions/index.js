const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require('axios');

const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.pairUsers = functions.firestore
  .document("waitingRoom/{userId}")
  .onCreate(async (snap, context) => {
    const db = admin.firestore();
    const waitingRoomRef = db.collection("waitingRoom");

    // Step 1: Check if there are at least two users in the waiting room
    const waitingRoomSnapshot = await waitingRoomRef.limit(2).get();
    if (waitingRoomSnapshot.size < 2) {
      return null; // Not enough users to start a chat
    }

    // Step 2: Create a new chat room and add these users to it
    const chatRoomRef = db.collection("chatRooms").doc();
    const users = [];
     const userIds = [];
    waitingRoomSnapshot.forEach((doc) => {
      userIds.push(doc.id);
    });
    waitingRoomSnapshot.forEach((doc) => {
      let user = {id: doc.data().id, name: doc.data().name, email: doc.data().email, country: doc.data().country}
      users.push(user);
    });

try {
    const url = 'https://studentsconnect-f319888a67a0.herokuapp.com/rtc/' + chatRoomRef.id + '/publisher/uid/0/?expiry=100000';
    const response = await axios.get(url);

    // Assuming the token is returned in the 'token' field of the response
    if (response.data && response.data.rtcToken) {
      console.log("Fetched token:", response.data.rtcToken);
      
  await chatRoomRef.set({
      users: users,
      userIds: userIds,
      token: response.data.rtcToken,
      created: admin.firestore.FieldValue.serverTimestamp(),
    });

    } else {
      console.log("Token not found in response:", response.data);
    }
  } catch (error) {
    console.error("Error fetching token:", error);
  }

  

    const chatRoomId = chatRoomRef.id;

    // Step 3: Remove these users from the waiting room
    const batch = db.batch();
    waitingRoomSnapshot.forEach((doc) => {
      const docRef = waitingRoomRef.doc(doc.id);
      batch.delete(docRef);
    });
    await batch.commit();

    // Step 4: Update a field in each user's document to specify their new chat room ID
    userIds.forEach(async (id) => {
      await db.collection("connectUsers").doc(id).update({
        currentChatRoom: chatRoomId,
      });
    });

    return null;
  });
