import mongoose from "mongoose";

const callSchema = new mongoose.Schema({
    callerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "users",
        require: true
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "users",
        require: true
    },
    callType: {
        type: String,
        enum: ['audio', 'video'],
        required: true
    },
    startedAt: {
        type: Date,
        default: Date.now
    },
    endedAt: {
        type: Date
    },
    status: {
        type: String,
        enum: ['ongoing', 'ended', 'missed'],
        default: 'ongoing'
    }
}, {
    timestamps: true
},)

const CallModel=mongoose.model("CallModel",callSchema);

export default CallModel;