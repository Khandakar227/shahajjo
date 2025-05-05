import { Request, Response } from "express";
import EmergencyContact from '../models/EmergencyContact';

export const getEmergencyContacts = async (req: Request, res: Response) => {
    try {
        const { lat, lng, type } = req.query;

        if (!lat || !lng) {
            return res.status(400).json({ error: 'Invalid request' });
        }

        const query: any = {
            location: {
                $near: {
                    $geometry: {
                        type: 'Point',
                        coordinates: [parseFloat(lng as string), parseFloat(lat as string)]
                    },
                    $maxDistance: 10000
                }
            },
            contact_number: { $ne: "N/A" }
        };

        if (type && type !== 'All') {
            query.type = type;
        }

        const contacts = await EmergencyContact.find(query);
        return res.status(200).json({ contacts });
    } catch (error) {
        console.error('Error: ', error);
        return res.status(500).json({ error: 'Something went wrong...' });
    }
}
