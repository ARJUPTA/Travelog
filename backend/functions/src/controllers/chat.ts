import { Request, Response, NextFunction } from "express"
import { db } from "../services/firebase"
import admin from "firebase-admin"

export const createGroup = async (req: Request, res: Response, next:NextFunction) => {
  const trip = await db.collection("trip").doc(req.body.tripId).get();
  const participants = [req.body.user.uid];
  const tripData:any = { ...trip.data(), id: trip.id };
  const response = await db.collection("groups").doc(tripData.refCode + tripData.boardingDate).set({ participants, tripData, topic: req.body.topic })
  return res.status(201).json(response);
}

export const addUser = async (req: Request, res: Response, next: NextFunction) => {
  const query = await db.collection("groups").where("topic", "==", req.body.topic).get();

  if (!query.empty) {
    const snapshot = query.docs[0];
    const id = snapshot.id;
    const response = await db.collection("groups").doc(id).update({ participants: admin.firestore.FieldValue.arrayUnion(req.body.user.uid) });
    return res.status(200).json(response);
  } else {
    return res.sendStatus(404)
  }
}

export const removeUser = async (req: Request, res: Response, next: NextFunction) => {
  const query = await db.collection("groups").where("topic", "==", req.body.topic).get();

  if (!query.empty) {
    const snapshot = query.docs[0];
    const id = snapshot.id;
    await db.collection("groups").doc(id).update({ participants: admin.firestore.FieldValue.arrayRemove(req.body.user.uid) });
    return res.sendStatus(204);
  } else {
    return res.sendStatus(404)
  }
}

export const getGroups = async (req: Request, res: Response, next: NextFunction) => {
  const query = await db.collection("groups").where("participants", "array-contains", req.body.user.uid).get();
  const groups:any[] = []
  query.forEach(doc => {
    groups.push(doc.data());
  })

  return res.status(200).json({data:groups});
}
