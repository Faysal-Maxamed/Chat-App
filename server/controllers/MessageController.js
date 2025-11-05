import MessageModel from "../models/MessgeSchema.js";


import { io } from "../socket.js";  

export const sendMessage = async (req, res) => {
  try {
    const { receiverId, content } = req.body;

    if (!receiverId || !content) {
      return res.status(400).json({ message: "Receiver and content are required" });
    }

   
    const message = await MessageModel.create({
      senderId: req.user._id,
      receiverId,
      text: content,
    });

   
    const receiverSocketId = getReceiverSocketId(receiverId);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit("newMessage", message);
    }

    res.status(201).json({ message: "Message sent successfully", data: message });
  } catch (error) {
    console.error("Send message error:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// ✅ 2. Get Messages between two users
export const getMessages = async (req, res) => {
  try {
    const { userId } = req.params;

    const messages = await MessageModel.find({
      $or: [
        { senderId: req.user._id, receiverId: userId },
        { senderId: userId, receiverId: req.user._id },
      ],
    }).sort({ createdAt: 1 });

    res.status(200).json({ messages });
  } catch (error) {
    console.error("Get messages error:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// ✅ 3. Get Chat List
export const getChatList = async (req, res) => {
  try {
    const messages = await MessageModel.find({
      $or: [{ senderId: req.user._id }, { receiverId: req.user._id }],
    })
      .populate("senderId", "phoneNumber email")
      .populate("receiverId", "phoneNumber email")
      .sort({ createdAt: -1 });

    const chatUsers = [];
    const uniqueUsers = new Set();

    messages.forEach((msg) => {
      const otherUser =
        msg.senderId._id.toString() === req.user._id.toString()
          ? msg.receiverId
          : msg.senderId;

      if (!uniqueUsers.has(otherUser._id.toString())) {
        uniqueUsers.add(otherUser._id.toString());
        chatUsers.push({
          user: otherUser,
          lastMessage: msg.text,
          time: msg.createdAt,
        });
      }
    });

    res.status(200).json(chatUsers);
  } catch (error) {
    console.error("Error fetching chat list:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ✅ Helper function (same as in socket.js)
import { userSocketMap } from "../socket.js";
function getReceiverSocketId(userId) {
  return userSocketMap[userId];
}



