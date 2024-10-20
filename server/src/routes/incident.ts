import express from 'express';
import { addNewIncident, deleteIncident, getIncident, getIncidents } from '../controllers/incident';
import { checkTokenValidity } from '../controllers/user';

const router = express.Router();

router.post("/", checkTokenValidity,  addNewIncident);
router.get("/", getIncidents);
router.get("/:id", getIncident);
router.delete("/:id", checkTokenValidity, deleteIncident);

export default router;