import express from "express";
import UserModel from "../models/UsersModel.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";


const generateToken =(id)=>{
    return jwt.sign({id},process.env.JWTSCT,{expiresIn:"30d"})
}
export const RegisterUser = async (req, res) => {
    try {
        const { phoneNumber, email, password } = req.body;
        if (!phoneNumber || !email || !password)
            return res.status(400).json({ message: "Please fill all fields" });
        const userExists=await UserModel.findOne({email});
        if(userExists)
            return res.status(400).json({ message: 'User already exists' })
        const registerNewUser= await UserModel.create({phoneNumber,email,password});

        res.status(201).json({
            _id:registerNewUser._id,
            phoneNumber:registerNewUser.phoneNumber,
            email:registerNewUser.email,
            token:generateToken(registerNewUser._id)
        })
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
}

export const LoginUser = async (req, res) => {
    try {
        const {phoneNumber,password}=req.body;
        if(!phoneNumber || !password)
            return res.status(400).json({message:"Please fill all fields"});
        const user= await UserModel.findOne({phoneNumber});
        if(!user)
            return res.status(400).json({message:"User not found"});
        if(user.password !== password)
            return res.status(400).json({message:"Invalid password"});
        res.status(200).json({
            _id:user._id,
            phoneNumber:user.phoneNumber,
            email:user.email,
            token:generateToken(user._id)
        })
    } catch (error) {
        console.log(error);console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
}

export const getProfile = async (req,res)=>{
    try {
        const userId=req.params.id;
        const user= await UserModel.findById(userId).select("-password");
        if(!user)
            return res.status(404).json({message:"User not found"});
        res.status(200).json(user);
    } catch (error) {
        
    }
}

// 🔍 SEARCH USERS
export const searchUsers = async (req, res) => {
  try {
    const search = req.query.search || ''; // waxa user ku qoray query-ga
    const users = await UserModel.find({
      $or: [
        { email: { $regex: search, $options: 'i' } },
        { phoneNumber: { $regex: search, $options: 'i' } }
      ]
    }).select('-password'); // ha muujin password-ka

    res.status(200).json(users);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Server Error' });
  }
};