import express from 'express';
const userRoutes =express.Router();

import { RegisterUser, LoginUser, getProfile } from '../controllers/UsersControllers.js';
import {protect} from '../middleware/authmidlleware.js';

userRoutes.post('/register',RegisterUser);
userRoutes.post('/login',LoginUser);
userRoutes.get('/profile',protect,getProfile);

export default userRoutes;