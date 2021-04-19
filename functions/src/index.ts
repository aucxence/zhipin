const functions = require("firebase-functions");
// const { v4: uuidv4 } = require('uuid');

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.createUser = functions.auth.user().onCreate((user: any) => {
    db.collection('users').doc(user.uid).set({
        completedSubscription: false,
    })
});

exports.saveUserAndCompany = functions.https.onCall((data: any, context: any) => {

    const promise: Promise<any> = new Promise(async (resolve, reject) => {
        try {
            const batch = db.batch();

            const companyuid = data.entreprise
                + data.expertise
                + data.abbrev
                + data.staffmin.toString()
                + data.staffmax.toString();

            const useruid = data.email
                + data.fonction
                + data.nom;

            const companyRef = db.collection("companylist")
                .doc(companyuid);

            batch.set(companyRef, {
                "companyfullname": data.entreprise,
                "expertise": data.expertise,
                "shortname": data.abbrev,
                "staffrangemin": data.staffmin,
                "staffrangemax": data.staffmax,
                "staff": data.staff,
                "createdOn": new Date(),
                "createdBy": useruid
            });



            const userRef = db.collection("users").doc(useruid);
            batch.update(userRef, {
                "pic": data.pic,
                "nom": data.nom,
                "email": data.mail,
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

