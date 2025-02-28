import express, { Express } from "express";
import dotenv from "dotenv";
import { connect } from "mongoose";
import cors from "cors";
import stationRoute from "./routes/stationData";
import cron from 'node-cron';
import floodRoute from "./routes/floodData";
import userRoute from "./routes/user";
import incidentRoute from "./routes/incident";
import emergencyContactsRoute from "./routes/EmergencyContacts";
import { taskFetchFloodData } from "./libs/cron";
import path from "node:path";

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 8000;

connect(process.env.MONGODB_URL as string, {
    dbName: process.env.DBNAME,
})
.then((_) => console.log("Connected to database"))
.catch((error) => {
    console.log("connection failed! ", error);
});

app.use(cors({
    origin: "*",
    methods: "GET,POST,PUT,DELETE",
}));

app.set('view engine', 'ejs');

app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ limit: "10mb", extended: true }));
app.use(express.static(path.join(__dirname, '../../public')));


app.get("/", async (req, res) => {
    res.send(`Live`);
});

app.get('/incident-monitor', (req, res) => {
    res.render('index', { mapApiKey: process.env.GOOGLE_MAP_API_KEY });
});


app.use("/api/v1/station", stationRoute);
app.use("/api/v1/flood", floodRoute);
app.use("/api/v1/user", userRoute);
app.use("/api/v1/incident", incidentRoute);
app.use("/api/v1/emergency-contact", emergencyContactsRoute);

app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

// A cron job to fetch flood data every 6 hours
cron.schedule('0 6,12 * * *', taskFetchFloodData, { scheduled: true });