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
export const forbidden = (req: Request, res: Response) => {
  res.statusCode = 403;
  res.send("End point is not supported!");
};
