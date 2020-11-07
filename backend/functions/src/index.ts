import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
const createError = require("http-errors");
import cors from "cors";
import helmet from "helmet";
import { json, urlencoded } from "body-parser";
import logger from "morgan";
import compression from "compression";
import cookieParser from "cookie-parser";

//routes
import trip from "./routes/trip";
import auth from "./routes/auth"
import user from "./routes/user"
import group from "./routes/chat"

const app = express();
// remove powered by cookie
app.disable("x-powered-by");
// enhance API security
app.use(helmet());
// allow cors origin for all
app.use(cors({ origin: true }));
//log https requests using morgan
app.use(logger("dev"));
// using bodyparser to parse json bodies into js objects
app.use(json());
// body parsing urlencoded data
app.use(urlencoded({ extended: true }));
// compress response
app.use(compression());
// use cookie-parser for refresh token
app.use(cookieParser());

app.use("/trip", trip);
app.use("/auth", auth);
app.use("/user", user);
app.use("/group", group);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
	next(createError(404));
});

// error handler
app.use(function (err:Error, req:Request, res:Response) {
	// set locals, only providing error in development
	res.locals.message = err.message;
	// console error for debugging
	console.error(err);
	// check type of error
	switch (true) {
	case typeof err === "string":
		// custom application error
		// eslint-disable-next-line no-case-declarations
		const is404 = err.message.toLowerCase().endsWith("not found");
		// eslint-disable-next-line no-case-declarations
		const statusCode = is404 ? 404 : 400;
		return res.status(statusCode).json({ message: err });
	case err.name === "ValidationError":
		// mongoose validation error
		return res.status(400).json({ message: err.message });
	case err.name === "UnauthorizedError":
		// jwt authentication error
		return res.status(401).json({ message: "Unauthorized" });
	default:
		return res.status(500).json({ message: err.message });
	}
});

exports.api = functions.https.onRequest(app)
