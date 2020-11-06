import jwt, {VerifyErrors } from "jsonwebtoken"
import { auth, configuration, db } from "../services/firebase"
import {Request, Response, NextFunction} from "express"

export interface User {
	name: string,
	username: string,
	institution: string,
	uid: string,
	privacy?: boolean,
	profile_pic?: string,
	phone_number?: string,
	email: string
}

export const verfiyIDToken = async (req: Request, res: Response, next: NextFunction):Promise<void|Response> => {
  const idToken = req.body.idToken;
  if (!idToken) return res.status(401).json({ message: "Token not provided" });
	try {
		const decodedToken = await auth.verifyIdToken(idToken);

		if (decodedToken) {
			let { email, emailVerified, providerData } = await auth.getUser(decodedToken.uid);

			const providers = ["google.com", "github.com", "facebook.com"];
			providerData
			if (!emailVerified) {
				const result = providerData.some((userInfo) => providers.some((provider) => provider === userInfo.providerId));
				if (result) {
					emailVerified = true;
					await auth.updateUser(decodedToken.uid, {
						emailVerified: true
					});
				}
			}

			req.body.profile_pic = providerData.filter(userInfo => !!userInfo.photoURL)[0] ?? null;
			req.body.email = email;
			req.body.uid = decodedToken.uid;
			req.body.email_verified = emailVerified;
			next();
		} else {
			return res.status(401).json({ message: "Unauthorized" });
		}
	} catch (e) {
		if (e.code === "auth/argument-error")
			return res.status(401).json({ message: "Invalid Firebase Token" });
		next(e);
	}
}

// verify jwt token using secret in config and return user id
const verifyToken = (token:string):Promise<any> =>
	new Promise((resolve, reject) => {
		jwt.verify(token, configuration.secrets.jwt, (err:VerifyErrors|null, payload:object|undefined) => {
			if (err) return reject(err);
			resolve(payload);
		});
	});


// generate new jwt token
export const newToken = (user:User) => {
	return jwt.sign({ id: user.uid }, configuration.secrets.jwt, {
		expiresIn: configuration.secrets.jwtexp
	});
};

// check header for authorization token prefixed with Bearer and then fetch user and add to request object
export const protect = async (req: Request, res: Response, next: NextFunction):Promise<Response|void> => {
	const token = req.headers.authorization

	if (!token) return res.status(401).json({ message: "No Token Provided" });

	const [identity, tokenVal] = token.split(" ");
	if (identity !== "Bearer") return res.status(401).end();

	try {
		const payload = await verifyToken(tokenVal);
		if (!payload?.uid)
			return res.status(404);

		const user = await db.collection("accounts").where("uid","==",payload.uid);
		req.body.user = user;
		next();
	} catch (error) {
		if (error.name === "JsonWebTokenError")
			return res.status(401).json({ message: "Malformed Token" });
		next(error);
	}
}
