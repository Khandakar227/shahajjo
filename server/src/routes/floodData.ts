import express from 'express';
import { getAndAddFloodData, getFloodData } from '../controllers/floodData';

const router = express.Router();

router.get('/', getFloodData);
router.get('/scrape', getAndAddFloodData);

export default router;