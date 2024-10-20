import { Schema, model, Document, models, Model } from 'mongoose';

export interface IUser {
    name: string;
    phoneNumber: string;
    avatar: string;
    otp: string;
    otpExpiresAt: Date;
    verified: boolean;
    createdAt: Date;
    updatedAt: Date;
}

export const UserSchema = new Schema<IUser>({
    name: { type: String, required: true },
    phoneNumber: { type: String, required: true, unique: true },
    avatar: { type: String },
    otp: { type: String },
    otpExpiresAt: { type: Date, required: true },
    verified: { type: Boolean, default: false },
    createdAt: { type: Date, default: Date.now() },
    updatedAt: { type: Date, default: Date.now() },
});

export const User = models.User as Model<IUser> ?? model<IUser>('User', UserSchema);