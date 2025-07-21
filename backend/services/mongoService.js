import mongoose from "mongoose";
// import dotenv from "dotenv";

// dotenv.config(); // Load environment variables

// const mongoURI = process.env.MONGO_URI;

const connectDB = async () => {
  try {
    // mongodb+srv://fdessalew:Vx!pU.Wd_Ygq7nD@cluster0.gxca3bt.mongodb.net/
    await mongoose.connect('mongodb+srv://fdessalew:Vx!pU.Wd_Ygq7nD@cluster0.gxca3bt.mongodb.net/'); // No need for deprecated options
    console.log("✅ Connected to MongoDB");
  } catch (error) {
    console.error("❌ MongoDB connection error:", error);
    process.exit(1);
  }
};

// 🔹 Define Player Schema
const PlayerSchema = new mongoose.Schema({
  name: { type: String, required: true },
  deviceId: { type: String, required: true, unique: true },
  balance: { type: Number, default: 50 },
  createdAt: { type: Date, default: Date.now },
  phone: { type: String, required: true },
});

// 🔹 Create Model
const Player = mongoose.model("Player", PlayerSchema);

// 🔹 Register Player
const registerPlayer = async ({ name, deviceId, phone }) => {
  try {
    const newPlayer = new Player({ name, deviceId, phone });
    return await newPlayer.save();
  } catch (error) {
    console.error("❌ Error registering player:", error);
    return null;
  }
};

// 🔹 Fetch Player by Device ID
const getPlayerByDeviceId = async (deviceId) => {
  try {
    return await Player.findOne({ deviceId });
  } catch (error) {
    console.error("❌ Error fetching player:", error);
    return null;
  }
};

// 🔹 Update Player Balance
const updatePlayerBalance = async (deviceId, newBalance) => {
  try {
    return await Player.findOneAndUpdate(
      { deviceId },
      { balance: newBalance },
      { new: true }
    );
  } catch (error) {
    console.error("❌ Error updating balance:", error);
    return null;
  }
};

// 🔹 Withdraw from Balance
const withdrawBalance = async (deviceId, amount) => {
  try {
    const player = await Player.findOne({ deviceId });
    if (!player) return null;
    if (player.balance < amount) return { error: "Insufficient balance" };

    player.balance -= amount;
    return await player.save();
  } catch (error) {
    console.error("❌ Error withdrawing balance:", error);
    return null;
  }
};

// 🔹 Export
export {
  connectDB,
  registerPlayer,
  getPlayerByDeviceId,
  updatePlayerBalance,
  withdrawBalance,
};
