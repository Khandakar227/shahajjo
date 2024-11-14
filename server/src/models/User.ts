import { Schema, model, Document, models, Model } from 'mongoose';

export interface IUser {
    name: string;
    phoneNumber: string;
    avatar: string;
    otp: string;
    otpExpiresAt: Date;
    verified: boolean;
    deviceToken: string;
    currentLocation: {
        type: string;
        coordinates: number[];
    };
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
    deviceToken: { type: String },
    currentLocation: {
        type: {
          type: String,
          enum: ['Point'], // 'location.type' must be 'Point'
        },
        coordinates: {
          type: [Number],
        },
      },
    createdAt: { type: Date, default: Date.now() },
    updatedAt: { type: Date, default: Date.now() },
});

UserSchema.index({ currentLocation: '2dsphere' });

export const User = models.User as Model<IUser> ?? model<IUser>('User', UserSchema);