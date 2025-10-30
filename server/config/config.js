import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const ConnectDB = async () => {

    try {
        await mongoose.connect("mongodb+srv://pheymoha17:pheymoha17@chat-app.tdcszww.mongodb.net/chat_app").then(()=>{
            console.log("Database connected successfully");
        }).catch(()=>{
            console.log("Database connection failed");
        })
    } catch (error) {
        console.log("Database connection error:", error);
    }
}

export default ConnectDB;