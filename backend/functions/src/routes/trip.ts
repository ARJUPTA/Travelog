import { Router } from "express";
import {getAllTrips, getTrip, updateTrip, createTrip, deleteTrip, getUserTrips, deleteUserTrips, isCreator, forbidden} from "../controllers/trip"
import { protect } from "../middlewares/auth";

const router = Router();

router
  .route("/")
  .get(getAllTrips)
  .put(forbidden)
  .post(forbidden)
  .delete(forbidden);
router.use(protect);
router
  .route("/usr")
  .get(getUserTrips)
  .put(forbidden)
  .post(createTrip)
  .delete(deleteUserTrips);
router
  .route("/:id")
  .get(getTrip)
  .put(isCreator, updateTrip)
  .post(forbidden)
  .delete(isCreator, deleteTrip);
export default router;
