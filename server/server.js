import mongoose, { connect } from "mongoose";
import express from "express";
import ConnectDB from "./config/config.js";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/UserRoutes.js";
import messageRoutes from "./routes/MessageRoutes.js";



const app= express();
const port=4000;
const host = "172.30.48.248";

app.use(express.json());
app.use(cors());
dotenv.config();

ConnectDB()

app.get("/",(req,res)=>{res.send("Hellow world")});

app.use("/api/users/",userRoutes)
app.use("/api/messages/",messageRoutes)

app.listen(port,host,()=>console.log(`server is running port on ${host}`));