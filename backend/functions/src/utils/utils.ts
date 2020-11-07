import axios, { AxiosRequestConfig } from "axios";
import { Request } from "express";

// Returns day as Mon, Tue, Wed, etc. from an Iso Date string.

export const getDayFromIsoDate: (dateString: string) => string | boolean = (
  dateString: string
) => {
  const dayMap = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  try {
    const date = new Date(dateString);
    const day = date.getDay();
    return dayMap[day];
  } catch (err) {
    console.log(err);
    return false;
  }
};

// Returns details of pnr else returns false
export const validatePnr = async (pnr: string) => {
  const options: AxiosRequestConfig = {
    method: "GET",
    url: `https://pnr-status-indian-railway.p.rapidapi.com/rail/${pnr}`,
    headers: {
      "x-rapidapi-key": "2920326c74msh76b3d11efcebf53p1fbc5ajsn2eadf9d76347",
      "x-rapidapi-host": "pnr-status-indian-railway.p.rapidapi.com",
    },
  };
  try {
    const response = await axios.request(options);
    const data = response.data;
    if ("error" in data) {
      return false;
    } else {
      return data;
    }
  } catch (err) {
    console.log(err);
    return false;
  }
};
export const validateTrainTrip = async (req: Request) => {
  const boardingDay = "running" + getDayFromIsoDate(req.body.boardingDate);
  const fromStationCode = req.body.from;
  const toStationCode = req.body.to;
  const trainNumber = req.body.trainNumber;
  const date_ob = new Date(req.body.boardingDate);
  let date = ("0" + date_ob.getDate()).slice(-2);
  let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
  let year = date_ob.getFullYear();
  const requestUrl = `https://www.irctc.co.in/eticketing/protected/mapps1/tbstns/${fromStationCode}/${toStationCode}/${year}${month}${date}?dateSpecific=Y&ftBooking=N&redemBooking=N&journeyType=GN&captcha=`;
  console.log("requestUrl", requestUrl);
  console.log(trainNumber);
  console.log(boardingDay);
  const options: AxiosRequestConfig = {
    method: "GET",
    url: requestUrl,
    headers: {
      greq: "1604739383672",
    },
  };
  try {
    const response = await axios.request(options);
    console.log(response.status);
    const alternateTrainBtwnStnsList = response.data.alternateTrainBtwnStnsList;
    alternateTrainBtwnStnsList.forEach((train: any) => {
      console.log('train:', train);
      console.log(console.log("train[boardingDay]",train[boardingDay]));
      if (train.trainNumber === trainNumber) {
        console.log("hello", train.trainNumber)
        if (train[boardingDay] === "Y") {
          return true;
        } else {
          return false;
        }
      }
    });
    return false;
  } catch (err) {
    console.log(err);
    return false;
  }
};
