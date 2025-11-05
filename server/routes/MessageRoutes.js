import express from 'express';

const messageRoutes =express.Router();

import {sendMessage,getMessages,getChatList, searchUsers} from '../controllers/MessageController.js'
import { protect } from '../middleware/authmidlleware.js';

messageRoutes.post('/send',protect,sendMessage);
messageRoutes.get('/:userId',protect,getMessages);
messageRoutes.get('/chats/list',protect,getChatList);
messageRoutes.get('search',protect,searchUsers)

export default messageRoutes;