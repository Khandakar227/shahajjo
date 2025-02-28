import express from 'express';
import { getEmergencyContacts } from '../controllers/EmergenyContacts';

const router = express.Router();

router.get('/', getEmergencyContacts);

export default router;