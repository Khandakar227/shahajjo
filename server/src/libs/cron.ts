import FloodData from "../models/FloodData";
import { FLOOD_DATA_URL } from "./const";
import axios from 'axios';

export const fetchFloodData = async () => {
  const data = await axios.get(FLOOD_DATA_URL);
  const floodData = await FloodData.insertMany(data.data);
  console.log('Flood data inserted');
  return floodData;
}