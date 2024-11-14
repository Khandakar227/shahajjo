import express from 'express';
import { getAndAddStationData, getStationData } from '../controllers/stationData';

const router = express.Router();

router.get('/', getStationData);
router.get('/scrape', getAndAddStationData);

export default router;