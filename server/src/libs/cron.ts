import FloodData from "../models/StationData";
import { FLOOD_DATA_URL } from "./const";
import axios from 'axios';
import { logger } from "./logger";

export const taskFetchFloodData = async () => {
  try {
    const data = await axios.get(FLOOD_DATA_URL);
    let fdata = [] as any[];
    // console.log(data);
    Object.keys(data.data).forEach(async (key) => {
      let date = Object.keys(data.data[key])[0];
      const floodData = { st_id: key, wl_date: date, waterlevel: data.data[key][date] };
      fdata.push(floodData);
    });
    await FloodData.insertMany(fdata, { ordered: false });
    logger.info("Flood data fetched and saved to the database at", new Date());
  } catch (error) {
    const err = error as Error;
    console.log(err.message);
    logger.error(error);
  }
}

