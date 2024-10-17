import { Schema, model } from "mongoose";

const floodDataSchema = new Schema({
    st_id: { type: Number, required: true },
    wl_date: { type: Date, required: true },
    waterlevel: { type: Number, required: true },
});
floodDataSchema.index({ st_id: 1, wl_date: 1 }, { unique: true });
const FloodData = model('FloodData', floodDataSchema);

export default FloodData;
