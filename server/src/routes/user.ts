import express from 'express';
import { loginByPhone, register, verifyOTP } from '../controllers/user';

const router = express.Router();

router.post('/register', register);
router.post('/phone-login', loginByPhone);
router.post('/verify-otp', verifyOTP);

export default router;