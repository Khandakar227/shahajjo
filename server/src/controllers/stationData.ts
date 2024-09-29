import axios from "axios";
import { Request, Response } from "express";
import { FLOOD_DATA_URL } from "../libs/const";
import StationData from "../models/StationData";

export const getStationData = async (req: Request, res: Response) => {
    try {
        const data = await axios.get(FLOOD_DATA_URL);
        res.status(200).json(data.data);
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const getAndAddStationData = async (req: Request, res: Response) => {
    try {
        const data = await axios.get(FLOOD_DATA_URL);
        const fdata = await StationData.insertMany(data.data, { ordered: false });
        res.status(200).json(fdata);
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}