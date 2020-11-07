import * as functions from "firebase-functions";
import express from "express";
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

exports.api = functions.https.onRequest(app)
