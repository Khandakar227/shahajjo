import { Schema, model } from "mongoose";

const stationDataSchema = new Schema({
    st_id: { type: Number, unique: true, required: true },
    name: { type: String, required: true },
    lat: { type: Number, required: true },
    long: { type: Number, required: true },
    river: { type: String, required: true },
    basin_order: { type: Number },
    basin: { type: String },
    division: { type: String, required: true },
    district: { type: String, required: true },
    upazilla: { type: String, required: true },
    union: { type: String },
    wl_date: { type: Date, required: true },
    waterlevel: { type: Number, required: true },
    dangerlevel: { type: Number, required: true },
    riverhighestwaterlevel: { type: Number, required: true }
});

const StationData = model('stationData', stationDataSchema);

export default StationData;