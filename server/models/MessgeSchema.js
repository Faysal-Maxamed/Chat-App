import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "users",
        require: true
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "users",
        require: true
    },
    text: {
        type: String,
        trim: true
    },
    messageType: {
        type: String,
        require: true,
        enum: ['text', 'image', 'audio', 'video'],
        default: "text"
    },
    mediaUrl: {
        type: String
    },

}, {
    timestamps: true
},)

const MessageModel=mongoose.model("MessageModel",messageSchema);
export default MessageModel;