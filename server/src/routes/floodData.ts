import express from 'express';
import { getFloodData, getAndAddFloodData, getLatestFloodInfo } from '../controllers/floodData';

const router = express.Router();

router.get('/', getFloodData);
router.get('/latest', getLatestFloodInfo);
router.get('/scrape', getAndAddFloodData);

export default router;