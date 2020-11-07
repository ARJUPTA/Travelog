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
export const validateTrainTrip = async (req: Request) => {
  const fromStationCode = req.body.from;
  const toStationCode = req.body.to;
  const trainNumber = req.body.refCode;
  const date_ob = new Date(req.body.boardingDate);
  let date = ("0" + date_ob.getDate()).slice(-2);
  let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
  let year = date_ob.getFullYear();
  const requestUrl = `https://www.irctc.co.in/eticketing/protected/mapps1/tbstns/${fromStationCode}/${toStationCode}/${year}${month}${date}?dateSpecific=N&ftBooking=N&redemBooking=N&journeyType=GN&captcha=`
  const options: AxiosRequestConfig = {
    method: "GET",
    url: requestUrl,
    headers: {
      greq: "1604773426539"
    },
  };
  try {
    const response = await axios.request(options);
    console.log(response.status);
    const trainBtwnStnsList = response.data.trainBtwnStnsList;
    let flag = false;
    for(let i=0;i<trainBtwnStnsList.length;i++) {
      if (trainBtwnStnsList[i].trainNumber === trainNumber) {
        flag = true;
        break;
      }
    };
    return flag;
  } catch (err) {
    console.log(err);
    return false;
  }
};
