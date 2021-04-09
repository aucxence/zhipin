const functions = require("firebase-functions");

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.saveUserAndCompany = functions.https.onCall((data: any, context: any) => {

    const promise: Promise<any> = new Promise(async (resolve, reject) => {
        try {
            const batch = db.batch();

            const companyRef = db.collection("companylist").doc(data.uid + data.companyfullname);
            batch.set(companyRef, {
                "companyfullname": data.companyfullname,
                "shortname": data.companyshortname,
                "staffrangemin": data.staffmin,
                "staffrangemax": data.staffmax,
            });

            const userRef = db.collection("users").doc(data.uid);
            batch.update(userRef, {
                "fullname": data.bossname,
                "email": data.email,
                "fonction": data.fonction,
                "companyref": data.uid + "-" + data.companyfullname,
            });

            await batch.commit();

            resolve("opération réussie");
        } catch (e) {
            reject(e);
        }

    });

    return promise;

});

