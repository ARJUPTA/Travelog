import admin from "firebase-admin";
import { config } from "firebase-functions"


admin.initializeApp();
export const db = admin.firestore();
export const auth = admin.auth();
export const configuration = config();
