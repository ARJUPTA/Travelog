import { Request, Response, NextFunction } from "express";
import { db } from "../services/firebase";
import { getFlightData } from "../utils/airline";
import { validateTrainTrip } from "../utils/utils";

export const getAllTrips = async (req: Request, res: Response) => {
  const trips: any[] = [];
  try {
    const snapshot = await db.collection("trip").get();
    snapshot.forEach((doc) => {
      trips.push({ id: doc.ref.id, ...doc.data() });
    });
    res.statusCode = 200;
    res.setHeader("Content-Type", "application/json");
    res.send(trips);
  } catch (err) {
    console.log(err);
    res.statusCode = 404;
    res.send("Not found");
  }
};
export const getTrip = async (req: Request, res: Response) => {
  try {
    const doc = await db.collection("trip").doc(req.params.id).get();
    res.statusCode = 200;
    res.setHeader("Content-Type", "application/json");
    res.send(doc.data());
  } catch (err) {
    console.log(err);
    res.statusCode = 404;
    res.send("Not found");
  }
};
export const createTrip = async (
  req: Request,
  res: Response
): Promise<Response | void> => {
  const tripCollRef = db.collection("trip");
  const journeyType = req.body.journeyType;
  // complete the trip creation and add new trip to doc we will refactor later on for redundancy.
  if (journeyType === "T") {
    const fromStationCode = req.body.from;
    const toStationCode = req.body.to;

    res.setHeader("Content-Type", "application/json");
    const duration = await validateTrainTrip(req)
    if (duration) {
      const newTripData = {
        from: fromStationCode,
        to: toStationCode,
        trainNumber: req.body.refCode,
        boardingDate: req.body.boardingDate,
        creator: req.body.user.uid,
        duration: duration,
        journeyType: journeyType
      };
      try {
        const newTripRef = await tripCollRef.add(newTripData);
        res.statusCode = 200;
        const responseData = {
          success: true,
          ...(await newTripRef.get()).data()
        };
        res.send(responseData);
      } catch (err) {
        console.log(err);
        const responseData = {
          success: false,
          error: "Valid journey detils but couldn't create trip."
        };
        res.statusCode = 400;
        res.send(responseData);
      }
    } else {
      const response = {
        success: false,
        error: "Invalid journey details!"
      };
      res.send(response);
    }
  } else {
    const trip = {
      depart_date: req.body.boardingDate,
      from: req.body.from,
      to: req.body.to,
      refCode: req.body.refCode
    };
    const response: any = await getFlightData({ ...trip });
    if (!response) return res.status(404);
    const durationinMins = response.totalDurationInMinutes;
    let hrs = Math.floor(durationinMins/60).toString();
    let mins = (durationinMins%60).toString();
    hrs = ("0" + hrs).slice(-2);
    mins = ("0" + mins).slice(-2);
    const data = await tripCollRef.add({
      boardingDate: trip.depart_date,
      trainNumber: trip.refCode,
      from: req.body.from,
      to: req.body.to,
      duartion: response.totalDurationInMinutes,
      endDate: (new Date(response.lastArrival)).toISOString(),
      creator: req.body.user.uid
    });
    return res.status(200).json((await data.get()).data());
  }
};
// export const updateTrip = async (req: Request, res: Response) => {
//   if(req.body.journeyType) {
//     res.statusCode = 400;
//     res.send("Cannot change the journey type.")
//   }
//   try {
//     const tripRef = db.collection("trip").doc(req.params.id);
//     delete request.body.user;
//     await tripRef.update(req.body);
//     const updatedTrip = (await db.collection("trip").doc(req.params.id).get()).data() as FirebaseFirestore.DocumentData;
//     res.statusCode = 200;
//     res.setHeader("Content-Type", "application/json");
//     if (req.body.boardingDate || req.body.endingDate) {
//       const newDuration = getTimeDelta(new Date(updatedTrip.boardingDate), new Date(updatedTrip.endingDate))
//       const updatedDuration = {
//         "duration": newDuration
//       }
//       tripRef.update(updatedDuration);
//       res.send({...updatedTrip, "duration": newDuration});
//     } else {
//       res.send(updatedTrip);
//     }
//   } catch (err) {
//     console.log(err);
//     res.statusCode = 400;
//     res.send("Error performing the update operation");
//   }
// };
export const deleteTrip = async (req: Request, res: Response) => {
  try {
    const tripRef = db.collection("trip").doc(req.params.id);
    await tripRef.delete();
    res.statusCode = 204;
    res.setHeader("Content-Type", "application/json");
    res.send({"success": true});
  } catch (err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Error performing the delete operation");
  }
};
export const getUserTrips = async (req: Request, res: Response) => {
  const trips: any[] = [];
  try {
    const snapshot = await db
      .collection("trip")
      .where("creator", "==", req.body.user.uid)
      .get();

    snapshot.forEach((doc) => {
      trips.push({ id: doc.ref.id, ...doc.data() });
    });
    console.log("tirps", trips);
    res.statusCode = 200;
    res.setHeader("Content-Type", "application/json");
    res.send(trips);
  } catch (err) {
    console.log(err);
    res.statusCode = 404;
    res.send("Not found!");
  }
};
export const deleteUserTrips = async (req: Request, res: Response) => {
  try {
    const snapshot = await db
      .collection("trip")
      .where("creator", "==", req.body.user.uid)
      .get();
    snapshot.forEach(async (doc) => {
      const docRef = doc.ref;
      await docRef.delete();
    });
    res.statusCode = 200;
    res.send("Successfully deleted the trips!");
  } catch (err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Could not delete the Trips!");
  }
};
export const isCreator = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = req.body.user;
    const trip = await db.collection("trip").doc(req.params.id).get();
    const tripData = trip.data() as FirebaseFirestore.DocumentData;
    if (user.uid === tripData.creator) {
      next();
    } else {
      res.statusCode = 403;
      res.send("Only creator can modify/delete the trip");
    }
  } catch (err) {
    res.statusCode = 400;
    res.send("Error performing the delete operation!");
  }
};
export const forbidden = (req: Request, res: Response) => {
  res.statusCode = 403;
  res.send("End point is not supported!");
};
