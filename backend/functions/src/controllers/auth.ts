import { newToken , User } from "../middlewares/auth"
import { db } from "../services/firebase"
import { NextFunction, Request, Response } from "express"

export const signin = async (req: Request, res: Response, next: NextFunction):Promise<Response|void> => {
  try {
    const user:unknown = await db.collection("accounts").where("uid", "==", req.body.uid).get();

    // User doesn't exist 404
		if (!user) {
			return res.status(404).send("User not registered");
		}
		// User isn't verified 401
		if (!req.body.email_verified) {
			return res.status(401).json({ "message": "User not Verified" });
		}

    const token = newToken((user as User));
    return res.status(200).send({ token });
  }
  catch (e) {
    next(e);
  }
}

export const signup = async (req: Request, res: Response, next: NextFunction): Promise<Response | void> => {
  if (!req.body.name || !req.body.institution || !req.body.username)
    return res.status(400).json({ "message": "Incomplete data provided" })

  try {
    const exists = await db.collection("accounts").where("email","==",req.body.email).get()
    if (!exists.empty) {
      return res.status(400).json({ "message": "Email already registered" });
    }

    delete req.body.idToken
    const user: User = { ...req.body };
    await db.collection('accounts').add(user);
    const token = newToken(user)
    return res.status(201).json({token})
  } catch (e) {
    next(e)
  }
}
