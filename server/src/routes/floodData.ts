import express from 'express';
import { getFloodData, getAndAddFloodData } from '../controllers/floodData';

const router = express.Router();

router.get('/', getFloodData);
router.get('/scrape', getAndAddFloodData);

export default router;