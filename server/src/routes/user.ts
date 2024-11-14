import express from "express";
import {
  checkTokenValidity,
  loginByPhone,
  register,
  verifyOTP,
  verifyToken,
  addDeviceToken,
  updateUserLocation,
} from "../controllers/user";

const router = express.Router();

router.get("/token", checkTokenValidity, verifyToken);
router.post("/register", register);
router.patch("/device-token", checkTokenValidity, addDeviceToken);
router.patch("/location", checkTokenValidity, updateUserLocation);
router.post("/phone-login", loginByPhone);
router.post("/verify-otp", verifyOTP);

export default router;
