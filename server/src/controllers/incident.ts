import { Request, Response } from "express";
import { Incident } from "../models/Incident";

export const addNewIncident = async (req: Request, res: Response) => {
    try {
        if(!res.locals.user)
            return res.status(401).json({ error: true, message: "Unauthorized" });

        const { incidentType, description, showPhoneNo, lng, lat } = req.body;
        const location = {
            type: "Point",
            coordinates: [lng, lat],
        };
        const incident = new Incident({
            incidentType,
            description,
            phoneNumber: res.locals.user.phoneNumber,
            showPhoneNo: showPhoneNo ?? false,
            location,
            isUserVerified: true,
        });
        await incident.save();
        // may need to send notifications to nearby devices

        res.status(200).json({error: false, message: "ঘটনা পাব্লিক করা হয়েছে।"})
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const getIncidents = async (req: Request, res: Response) => {
    try {
        const { lng, lat } = req.query;
        const incidents = await Incident.find({
            isDeleted: false,
            location: {
                $near: {
                    $geometry: {
                        type: "Point",
                        coordinates: [lng, lat],
                    },
                    $maxDistance: 5000, // 5 km
                },
            },
        });
        res.status(200).json({ error: false, incidents });
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const getIncident = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const incident = await Incident.findById(id, { isDeleted: false });
        if (!incident) return res.status(404).json({ error: true, message: "রিপোর্ট পাওয়া যায়নি।" });
        res.status(200).json({ error: false, incident });
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const deleteIncident = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const incident = await Incident.findByIdAndUpdate(id, {
            $set: { isDeleted: true },
        });
        if (!incident) return res.status(404).json({ error: true, message: "রিপোর্ট পাওয়া যায়নি।" });
        res.status(200).json({ error: false, message: "রিপোর্ট মুছে ফেলা হয়েছে।" });
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}
