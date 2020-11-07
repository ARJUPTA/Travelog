import { Router } from "express"
import { signin, signup } from "../controllers/auth"
import { verfiyIDToken } from "../middlewares/auth"

const router = Router()

router.use(verfiyIDToken);

router.use("/signin", signin);
router.use("/signup", signup);

export default router
