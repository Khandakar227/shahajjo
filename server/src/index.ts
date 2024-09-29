import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import { connect } from "mongoose";
import cors from "cors";
import stationRoute from "./routes/stationData";
import floodRoute from "./routes/floodData";

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
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.get("/", (req, res) => res.send("OK"));

app.use("/api/v1/station", stationRoute);
app.use("/api/v1/flood", floodRoute);

app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});
