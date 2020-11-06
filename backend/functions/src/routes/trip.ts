import { Router } from "express";
import {getTrips, createTrip} from "../controllers/trip"

const router = Router();

router
  .route("/")
  .get(getTrips)
  .post(createTrip);

export default router;
