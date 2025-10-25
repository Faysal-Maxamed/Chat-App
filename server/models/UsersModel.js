import mongoose from "mongoose";

const UsersSchema = new mongoose.Schema({
    username: {
        type: String,
        require: true,
    },
    password: {
        type: String,
        require: true,
    },
    phoneNumber: {
        type: String,
        require: true,
        unique: true,
    },  
    isOnilne:{
        type: Boolean,
        default: false,

    }
}, {
    timeStamps: true
},);

const UserModel =mongoose.model("users",UsersSchema);
export default UserModel;