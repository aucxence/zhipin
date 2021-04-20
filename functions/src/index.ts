const functions = require("firebase-functions");
const { v4: uuidv4 } = require('uuid');

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

const FieldValue = admin.firestore.FieldValue;

exports.createUser = functions.auth.user().onCreate((user: any) => {
    db.collection('users').doc(user.uid).set({
        completedSubscription: false,
    })
});

exports.saveUserAndCompany = functions.https.onCall(async (data: any, context: any) => {

    const companyuid = uuidv4();

    const promise: Promise<any> = new Promise(async (resolve, reject) => {
        try {
            const batch = db.batch();

            

            const useruid = data.uid;

            const companyRef = db.collection("companylist")
                .doc(companyuid);

            batch.set(companyRef, {
                "companyfullname": data.entreprise,
                "expertise": data.expertise,
                "shortname": data.abbrev,
                "staffrangemin": data.staffmin,
                "staffrangemax": data.staffmax,
                "staff": data.staff,
                "createdAt": FieldValue.serverTimestamp(),
                "createdBy": useruid
            });



            const userRef = db.collection("users").doc(useruid);
            batch.update(userRef, {
                "pic": data.pic,
                "nom": data.nom,
                "email": data.mail,
                "fonction": data.fonction,
                "createdAt": FieldValue.serverTimestamp(),
                "companyref": companyuid,
            });

            await batch.commit();

            resolve("opération réussie");
        } catch (e) {
            reject(e);
        }

    });

    await promise;

    return companyuid;

});

exports.onCreateMsg = functions.firestore
    .document('chats/{chatID}/chatlines/{msgID}')
    .onCreate((snapshot: any, context: any) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const data = snapshot.data();

        const promise: Promise<any> = new Promise(async (resolve, reject) => {
            try {
                const batch = db.batch();

                const chatDoc = db.collection("chats").doc(context.params.chatID);

                

                batch.update(chatDoc, {
                    'lastmessage': {
                        'timestamp': data.timestamp,
                        'content': data.content,
                        'type': data.type,
                        'idFrom': data.idFrom,
                        'idTo': data.idTo,
                        //   "${widget.job.recruiterId}_unreadmessageCount": 0,
                    },
                    'messageCount': FieldValue.increment(1),
                    [data.idFrom + '_unreadmessageCount']: FieldValue.increment(1),
                    'users': [data.idFrom, data.idTo],
                });

                await batch.commit();

                resolve("opération réussie");
            } catch (e) {
                reject(e);
            }

        });

        return promise;

        // perform desired operations ...
    });

