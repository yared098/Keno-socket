// import admin from "firebase-admin";
// import serviceAccount from "../config/googlejson.json" assert { type: "json" }; // 👈 note the assert

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
// });

// const db = admin.firestore();
// const playersCollection = db.collection("players");

// // 🔹 Register Player
// const registerPlayer = async ({ name, deviceId, phone }) => {
//   try {
//     const existing = await playersCollection.where("deviceId", "==", deviceId).get();
//     if (!existing.empty) {
//       return { error: "Player with this deviceId already exists" };
//     }

//     const newPlayer = {
//       name,
//       deviceId,
//       phone,
//       balance: 50,
//       createdAt: admin.firestore.FieldValue.serverTimestamp(),
//     };

//     const docRef = await playersCollection.add(newPlayer);
//     return { id: docRef.id, ...newPlayer };
//   } catch (error) {
//     console.error("❌ Error registering player:", error);
//     return null;
//   }
// };

// // 🔹 Fetch Player by Device ID
// const getPlayerByDeviceId = async (deviceId) => {
//   try {
//     const snapshot = await playersCollection.where("deviceId", "==", deviceId).limit(1).get();
//     if (snapshot.empty) return null;

//     const doc = snapshot.docs[0];
//     return { id: doc.id, ...doc.data() };
//   } catch (error) {
//     console.error("❌ Error fetching player:", error);
//     return null;
//   }
// };

// // 🔹 Update Player Balance
// const updatePlayerBalance = async (deviceId, newBalance) => {
//   try {
//     const snapshot = await playersCollection.where("deviceId", "==", deviceId).limit(1).get();
//     if (snapshot.empty) return null;

//     const doc = snapshot.docs[0];
//     await playersCollection.doc(doc.id).update({ balance: newBalance });
//     return { id: doc.id, ...doc.data(), balance: newBalance };
//   } catch (error) {
//     console.error("❌ Error updating balance:", error);
//     return null;
//   }
// };

// // 🔹 Withdraw from Balance
// const withdrawBalance = async (deviceId, amount) => {
//   try {
//     const snapshot = await playersCollection.where("deviceId", "==", deviceId).limit(1).get();
//     if (snapshot.empty) return null;

//     const doc = snapshot.docs[0];
//     const player = doc.data();

//     if (player.balance < amount) {
//       return { error: "Insufficient balance" };
//     }

//     const newBalance = player.balance - amount;
//     await playersCollection.doc(doc.id).update({ balance: newBalance });

//     return { id: doc.id, ...player, balance: newBalance };
//   } catch (error) {
//     console.error("❌ Error withdrawing balance:", error);
//     return null;
//   }
// };

// export {
//   registerPlayer,
//   getPlayerByDeviceId,
//   updatePlayerBalance,
//   withdrawBalance,
// };
