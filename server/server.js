import mongoose, { connect } from "mongoose";
import express from "express";
import ConnectDB from "./config/config.js";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/UserRoutes.js";



const app= express();

ConnectDB()

app.use(express.json());
app.use(cors());
dotenv.config();

app.get("/",(req,res)=>{res.send("Hellow world")});

app.use("/api/users/",userRoutes)

app.listen(5000,(req,res)=>{
    // res.send("Hellow world");
    console.log("Server is running on port 5000");
})