import { Router } from "express"
import { createGroup, getGroups, addUser, removeUser } from "../controllers/chat"
import { protect } from "../middlewares/auth"


const router = Router();

router.use(protect);

router.post("/create", createGroup);
router.get("/list", getGroups);
router.post("/add", addUser);
router.post("/remove", removeUser);

export default router
