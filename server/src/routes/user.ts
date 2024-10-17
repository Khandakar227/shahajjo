import express from 'express';
import { checkTokenValidity, loginByPhone, register, verifyOTP, verifyToken } from '../controllers/user';

const router = express.Router();

router.get('/token', checkTokenValidity, verifyToken);
router.post('/register', register);
router.post('/phone-login', loginByPhone);
router.post('/verify-otp', verifyOTP);

export default router;