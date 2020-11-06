import { Request, Response } from "express"
import { db } from "../services/firebase"

export const getTrips = async (req:Request, res:Response) => {
    const trips: any[] = [];
    try {
      const snapshot = await db.collection("trip").get();
      snapshot.forEach((doc: { data: () => any }) => {
        trips.push(doc.data());
      });
      res.status(200).send(JSON.stringify(trips));
    } catch (err) {
      res.statusCode = 404;
      res.send("No trips found!");
    }
}

export const createTrip = async (req:Request, res:Response) => {
    const trip = req.body;
    try {
      await db.collection("trip").add(trip);
    } catch (err) {
      res.statusCode = 400;
      res.send("Unable to add trip!");
    }
    res.status(201).send();
}
