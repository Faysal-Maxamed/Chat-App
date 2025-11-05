import express from 'express';
const userRoutes =express.Router();

import { RegisterUser, LoginUser, getProfile, searchUsers } from '../controllers/UsersControllers.js';
import {protect} from '../middleware/authmidlleware.js';

userRoutes.post('/register',RegisterUser);
userRoutes.post('/login',LoginUser);
userRoutes.get('/profile',protect,getProfile);
userRoutes.get('/search',protect,searchUsers);

export default userRoutes;