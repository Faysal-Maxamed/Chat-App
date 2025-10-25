import mongoose, { connect } from "mongoose";
import express from "express";
import ConnectDB from "./config/config.js";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/UserRoutes.js";
import messageRoutes from "./routes/MessageRoutes.js";



const app= express();

app.use(express.json());
app.use(cors());
dotenv.config();

ConnectDB()

app.get("/",(req,res)=>{res.send("Hellow world")});

app.use("/api/users/",userRoutes)
app.use("/api/messages/",messageRoutes)

app.listen(5000,(req,res)=>{
    // res.send("Hellow world");
    console.log("Server is running on port 5000");
})