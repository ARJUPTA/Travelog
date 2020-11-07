import { Request, Response } from "express";
import { db } from "../services/firebase";
import { validatePnr } from "../utils/utils";

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
export const createTrip = async (req: Request, res: Response) => {
  const tripCollRef = db.collection("trip");
  const pnrData = await validatePnr(req.body.pnr);
  res.setHeader('Content-Type', 'application/json');
  let response = {};
  if(pnrData) {
    try {
      console.log(pnrData);
      pnrData.creator = req.body.user.uid;
      const tripRef = await tripCollRef.add(pnrData);
      const trip = await tripRef.get();
      res.statusCode = 200;
      response = {
        "success": true,
        "trip": trip.data()
      }
    } catch (err) {
      console.log(err);
      res.statusCode = 400;
      response = {
        "success": false,
        "error": "PNR validated but trip creation failed"
      }
    }
  } else {
    res.statusCode = 400;
    res.setHeader('Content-Type', 'application/json');
    response = {
      "success": false,
      "error": "Invalid PNR."
    }
    res.send(response);
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
    tripRef.delete();
  } catch (err) {
    console.log(err);
    res.statusCode = 400;
    res.send("Error performing the delete operation");
  }
};
export const getUserTrips = async (req: Request, res: Response) => {
  const trips: any[] = [];
  try {
    const snapshot = await db.collection("trip").where("creator" , "==", req.body.user.id).get();

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
    const snapshot = await db.collection("trip").where("creator", "==", req.body.user.id).get();
    snapshot.forEach( doc => {
      let docRef = doc.ref;
      docRef.delete();
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
