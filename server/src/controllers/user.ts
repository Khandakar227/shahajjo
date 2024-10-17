import axios from "axios";
import { Request, Response } from "express";
import { isPhoneNo, parsePhoneNumber, sendOTP } from "../libs/otp";
import { logger } from "../libs/logger";
import { User } from "../models/User";
import { createJwtToken } from "../libs/jwt";


export const register = async(req:Request, res:Response) => {
    try {
        const { mobileNo, name } = req.body;
        if (!mobileNo || !name) return res.status(400).json({ error: true, message: "Missing mobile number or name" });

        let phoneNumber = parsePhoneNumber(mobileNo);
        if (!isPhoneNo(phoneNumber)) return res.status(400).json({ error: true, message: "Invalid mobile number" });
        
        const user = await User.findOne({ phoneNumber });
        if (user) return res.status(400).json({ error: true, message: "User already exists" });
        
        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpExpiresAt = new Date(Date.now() + 360000);

        const newUser = new User({
            phoneNumber,
            name,
            otp,
            otpExpiresAt
        });
        
        await newUser.save();
        
        sendOTP(otp, phoneNumber)
        .then((res) => res.json())
        .then((data) => logger.info(`Otp Sent: ${JSON.stringify(data)}`))
        .catch((err) => logger.error(err));

        res.status(201).json({ error: false, message: "OTP has been sent to your mobile number"});
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const loginByPhone = async(req:Request, res:Response) => {
    try {
        const { mobileNo } = req.body;
        
        if (!mobileNo) return res.status(400).json({ error: true, message: "Mobile number is required" });
        let phoneNumber = parsePhoneNumber(mobileNo);
        if (!isPhoneNo(phoneNumber)) return res.status(400).json({ error: true, message: "Invalid mobile number" });

        const user = await User.findOne({
            phoneNumber,
        });

        if (!user) return res.status(404).json({ error: true, message: "User not found. Please register first" });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const otpExpiresAt = new Date(Date.now() + 360000);

        user.otp = otp;
        user.otpExpiresAt = otpExpiresAt;

        await user.save();

        sendOTP(otp, mobileNo)
        .then((res) => res.json())
        .then((data) => logger.info(`Otp Sent: ${data}`))
        .catch((err) => logger.error(err));

        res.status(200).json({
            error: false,
            message: "OTP has been sent to your mobile number",
        });
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const verifyOTP = async(req:Request, res:Response) => {
    try {
        const { otp, mobileNo } = req.body;
        let phoneNumber = parsePhoneNumber(mobileNo);
        const user = await User.findOne({ phoneNumber });
        if(!user) return res.status(404).json({ error: true, message: "User not found" });
        
        if(user.otpExpiresAt < new Date()) return res.status(401).json({ error: true, message: "OTP has expired" });
        if (user.otp != otp) return res.status(401).json({ error: true, message: "Invalid OTP" });

        user.otp = "";
        user.verified = true;
        await user.save();

        const token = createJwtToken({ phoneNumber: user.phoneNumber, name: user.name });
        res.status(200).json({ error: false, token });
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}