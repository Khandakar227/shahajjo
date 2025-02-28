import { Model, model, models, Schema } from 'mongoose';

interface IEmergencyContact {
    name: string,
    address: string,
    contact_number: string,
    location: {
        type: string,
        coordinates: number[],
    },
    type: string,
    status: 'updated' | 'outdated',
    createdAt: Date,
}

const EmergencyContactSchema = new Schema<IEmergencyContact>({
    name: { type: String, required: true },
    address: { type: String },
    contact_number: { type: String, required: true },
    location: {
        type: { type: String, enum: ['Point'], required: true, default: 'Point' }, // 'location.type' must be 'Point'
        coordinates: { type: [Number], required: true, },
      },
    status: { type: String, enum: ['updated', 'outdated'], default: 'updated' },
    type: { type: String, default: 'other' },
    createdAt: { type: Date, default: Date.now },
});

EmergencyContactSchema.index({ location: '2dsphere' });
EmergencyContactSchema.index({ name: 'text', address: 'text' });

const EmergencyContact = models?.emergency_contact as Model<IEmergencyContact> || model('EmergencyContact', EmergencyContactSchema);

export default EmergencyContact;