import { Schema, model, models } from 'mongoose';

export const IncidentSchema = new Schema({
    incidentType: { type: String, required: true },
    description: { type: String, required: true },
    phoneNumber: { type: String },
    isUserVerified: { type: Boolean, default: false },
    showPhoneNo: { type: Boolean, default: false },
    isDeleted: { type: Boolean, default: false },
    location: {
        type: {
          type: String,
          enum: ['Point'], // 'location.type' must be 'Point'
          required: true,
          default: 'Point',
        },
        coordinates: {
          type: [Number],
          required: true,
        },
      },
});

IncidentSchema.index({ incidentType: 1, 'location.coordinates': 1 }, { unique: true });
// Create a geospatial index on the 'location' field
IncidentSchema.index({ location: '2dsphere' });

export const Incident = models.Incident ?? model('Incident', IncidentSchema);
