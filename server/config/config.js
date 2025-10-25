import mongoose from "mongoose";

const ConnectDB = async () => {

    try {
        await mongoose.connect(process.env.MONGO_URL,).then(()=>{
            console.log("Database connected successfully");
        }).catch(()=>{
            console.log("Database connection failed");
        })
    } catch (error) {
        
    }
}

export default ConnectDB;