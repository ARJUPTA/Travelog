import { Router } from "express"
import { profileGet, profileUpdate } from "../controllers/user"
import { protect } from "../middlewares/auth"

const router = Router()

router.use(protect);

router.route("/")
  .get(profileGet)
  .put(profileUpdate)

export default router
