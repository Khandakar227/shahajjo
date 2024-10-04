import axios from "axios";
import { Request, Response } from "express";
import { FLOOD_DATA_URL } from "../libs/const";
import FloodData from "../models/FloodData";
import getLatestFloodData from "../libs/getLatestFloodData";

export const getFloodData = async (req: Request, res: Response) => {
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

export const getAndAddFloodData = async (req: Request, res: Response) => {
    try {
        const data = await axios.get(FLOOD_DATA_URL);
        let fdata = [] as any[];
        // console.log(data);
        Object.keys(data.data).forEach(async (key) => {
            let date = Object.keys(data.data[key])[0];
            const floodData = {st_id: key, wl_date: date, waterlevel: data.data[key][date] };
            fdata.push(floodData);
        });
        const floodData = await FloodData.insertMany(fdata, { ordered: false });
        res.status(200).json(floodData);
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}

export const getLatestFloodInfo = async (req: Request, res: Response) => {
    try {
        const data = await getLatestFloodData();
        res.status(200).json(data);
    } catch (error) {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({
            error: true,
            message: `Unexpected error occured on the server. ${err.message}`,
        });
    }
}