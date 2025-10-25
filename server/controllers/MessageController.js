import express from 'express';
import MessageModel from '../models/MessgeSchema.js';

export const sendMessage = (req, res) => {
    try {
        const { receiverId, content } = req.body;
        if (!receiverId || !content) {
            return res.status(400).json({ message: 'Receiver and content are required' });
        }
        const message = MessageModel.create({
            senderId: req.user._id,
            receiverId: receiverId,
            text
        })

        res.status(201).json({ message: 'Message sent successfully', data: message });
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });

    }
}


export const getMessages = async (req, res) => {
    try {
        const { userId } = req.params;
        const messages = await MessageModel.find({
            $or: [
                { senderId: req.user._id, receiverId: userId },
                { senderId: userId, receiverId: req.user._id }
            ]
        }).sort({ createdAt: 1 });
        res.status(200).json({ messages })
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Server error', error: error.message });
    }
}


export const getChatList = async (req, res) => {
    try {
        const messages = await MessageModel.find({
            $or: [{ sender: req.user._id }, { receiver: req.user._id }],
        })
            .populate('senderId', 'name email')
            .populate('receiverId', 'name email')
            .sort({ createdAt: -1 });

        const chatUsers = [];
        const uniqueUsers = new Set();

        messages.forEach((msg) => {
            const otherUser =
                msg.sender._id.toString() === req.user._id.toString()
                    ? msg.receiver
                    : msg.sender;

            if (!uniqueUsers.has(otherUser._id.toString())) {
                uniqueUsers.add(otherUser._id.toString());
                chatUsers.push({
                    user: otherUser,
                    lastMessage: msg.content,
                    time: msg.createdAt,
                });
            }
        });

        res.status(200).json(chatUsers);
    } catch (error) {
        console.error('Error fetching chat list:', error);
        res.status(500).json({ message: 'Server error' });
    }
};