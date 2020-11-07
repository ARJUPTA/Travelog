import { Router } from "express";
import {forbidden, getAllTrips, getTrip, updateTrip, createTrip, deleteTrip, getUserTrips, deleteUserTrips, isCreator} from "../controllers/trip"

const router = Router();

router
  .route("/")
  .get(getAllTrips)
  .put(forbidden)
  .post(forbidden)
  .delete(forbidden);

router
  .route("/:id")
  .get(getTrip)
  .put(isCreator, updateTrip)
  .post(forbidden)
  .delete(isCreator, deleteTrip);

  router
  .route("/usr/:userId")
  .get(getUserTrips)
  .put(forbidden)
  .post(createTrip)
  .delete(deleteUserTrips);

export default router;
