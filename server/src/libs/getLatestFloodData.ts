import StationData from "../models/StationData";

const getLatestFloodData = async () => {
    const data = await StationData.aggregate([
      {
        $lookup: {
          from: 'flooddatas', // Name of the FloodData collection (ensure it's lowercase and matches the collection name)
          let: { stationId: '$st_id' },
          pipeline: [
            { $match: { $expr: { $eq: ['$st_id', '$$stationId'] } } },
            { $sort: { wl_date: -1 } }, // Sort by wl_date in descending order to get the latest
            { $limit: 1 }, // Take only the latest entry
          ],
          as: 'latestFloodData',
        },
      },
      {
        $unwind: {
          path: '$latestFloodData',
          preserveNullAndEmptyArrays: true, // Keep station data even if no flood data exists
        },
      },
      {
        $project: {
          st_id: 1,
          name: 1,
          lat: 1,
          long: 1,
          river: 1,
          basin_order: 1,
          basin: 1,
          division: 1,
          district: 1,
          upazilla: 1,
          union: 1,
          wl_date: "$latestFloodData.wl_date",
          waterlevel: "$latestFloodData.waterlevel",
          dangerlevel: 1,
          riverhighestwaterlevel: 1,
        },
      },
    ]);
  
    return data;
  };
  

export default getLatestFloodData;