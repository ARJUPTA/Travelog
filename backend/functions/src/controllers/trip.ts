import { Request, Response } from "express";
import { db } from "../services/firebase";
import { getFlightData } from "../utils/airline"


export const getAllTrips = async (req: Request, res: Response) => {
  const trips: any[] = [];
  try {
    const snapshot = await db.collection("trip").get();
    snapshot.forEach((doc: { data: () => any }) => {
      trips.push(doc.data());
    });
    res.status(200).send(JSON.stringify(trips));
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
    res.setHeader('Content-Type', 'application/json');
    res.send(doc.data())
  } catch (err) {
    console.log(err);
    res.statusCode = 404;
    res.send("Not found");
  }
};
export const createTrip = async (req: Request, res: Response):Promise<Response|void> => {
  const tripCollRef = db.collection("trip");
  const journeyType = req.body.journeyType;
  // complete the trip creation and add new trip to doc we will refactor later on for redundancy.
  if(journeyType === "T") {
    return res.sendStatus(200);
  } else {
    const trip = {depart_date:req.body.date, from:req.body.from, to:req.body.to, time:req.body.time, refCode:req.body.refCode}
    const response:any = await getFlightData({ ...trip });
    if (!response)
      return res.status(404);

    const data = await tripCollRef.add({...trip,duartion:response.totalDurationInMinutes,end:response.lastArrival})
    return res.status(201).json(data)

  }
};
export const updateTrip = async (req: Request, res: Response) => {
  try {
    const tripRef = db.collection("trip").doc(req.params.id);
    await tripRef.update(req.body);
    const updatedTrip = await db.collection("trip").doc(req.params.id).get();
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.send(updatedTrip);
  } catch(err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Error performing the update operation");
  }
};
export const deleteTrip = async (req: Request, res: Response) => {
  try {
    const tripRef = db.collection("trip").doc(req.params.id);
    await tripRef.delete();
  } catch (err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Error performing the delete operation");
  }
};
export const getUserTrips = async (req: Request, res: Response) => {
  const trips: any[] = [];
  try {
    const snapshot = await db.collection("trip").where("creator" , "==", req.body.user.uid).get();

    snapshot.forEach((doc: { data: () => any }) => {
      trips.push(doc.data());
    });
    res.status(200).send(JSON.stringify(trips));
  } catch (err) {
    console.log(err);
    res.statusCode = 404;
    res.send("Not found!");
  }
};
export const deleteUserTrips = async (req: Request, res: Response) => {
  try {
    const snapshot = await db.collection("trip").where("creator", "==", req.body.user.uid).get();
    snapshot.forEach( async doc => {
      const docRef = doc.ref;
      await docRef.delete();
    });
    res.statusCode = 200;
    res.send("Successfully deleted the trips!");
  } catch(err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Could not delete the Trips!");
  }
};
export const isCreator = async (req: Request, res: Response, next: any) => {
  try {
    const user = req.body.user;
    const trip = await db.collection("trip").doc(req.params.id).get();
    const tripData = trip.data() as FirebaseFirestore.DocumentData;
    if(user.uid === tripData.creator) {
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
