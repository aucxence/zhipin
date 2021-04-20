import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_zhipin_boss/models/chat.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

part 'auth_error.dart';

class UserDaoService {
  FirebaseFirestore firestore;
  FirebaseAuth auth;
  User user;
  bool connected = false;

  String verificationId = '';

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  UserDaoService() {
    prep();
  }

  prep() async {
    await Firebase.initializeApp();
    firestore = FirebaseFirestore.instance;
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User usr) {
      user = usr;
      connected = usr != null;
      print(connected);
      // auth.signOut();
    });
  }

  Future<DocumentReference> save(String collection, dynamic data) {
    return firestore.collection(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': user.uid ?? ''
    });
  }

  Future<DocumentReference> saveChatMessage(String id, dynamic data) {
    return firestore.collection('chats').doc(id).collection('chatlines').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': user.uid ?? ''
    });
  }

  Stream<QuerySnapshot> getMessageFeed(id) {
    return firestore
        .collection('chats')
        .doc(id)
        .collection('chatlines')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }

  Future<DocumentReference> saveWithId(String collection, {dynamic data}) {
    return firestore.collection(collection).doc(data.id).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': user.uid ?? ''
    });
  }

  updateMessageCount(chatid, count) {
    return firestore
        .collection('chats')
        .doc(chatid)
        .update({"${user.uid}_unreadmessageCount": count});
  }

  updateMessageRead(chatid, msgid) {
    return firestore
        .collection('chats')
        .doc(chatid)
        .collection('chatlines')
        .doc(msgid)
        .update({'read': true});
  }

  Stream<DocumentSnapshot> getUser([String uid]) {
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    // print(user.uid);
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

    return firestore.collection('users').doc(user.uid).snapshots();
  }

  Future<DocumentSnapshot> getUserByID([String uid]) {
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    // print(user.uid);
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');

    return (uid != null)
        ? firestore.collection('users').doc(user.uid).get()
        : firestore.collection('users').doc(user.uid).get();
  }

  Future<QuerySnapshot> getDocsArrayContainsCriteria(String collection,
      {String index, String searchindex, String order}) {
    CollectionReference col = firestore.collection(collection);
    // print(collection + ' -- ');
    Query query;
    if (index != null) {
      query = col.where(index, arrayContains: searchindex);
      if (order != null) {
        query = query.orderBy(order);
      }
    } else {
      if (order != null) {
        query = col.orderBy(order);
      }
    }
    if (query != null) return query.get();
    return col.get();
  }

  getDocsEqualCriteria(String collection,
      {String index, String field, String sortingField}) {
    // print(field + ' -> ' + index + ' -> ' + sortingField ?? '');
    var col = firestore.collection(collection);
    Query query;
    if (field != null) {
      query = col.where(index, isEqualTo: field);
      if (sortingField != null) {
        query = query.orderBy(sortingField);
      }
    } else {
      if (sortingField != null) {
        query = col.orderBy(sortingField);
      }
    }

    if (query != null)
      return query.get();
    else
      return col.get();
  }

  Stream<User> getFirebaseUser() {
    return auth.authStateChanges();
  }

  Future<void> updateUser(var data) {
    return firestore.collection('users').doc(user.uid).update(data);
  }

  Future<UserCredential> emailSignUp(String email, String password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  Future<void> sendVerificationEmail(UserCredential result) {
    return result.user.sendEmailVerification();
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final User usr =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    print("Logged-in User: " + usr.phoneNumber);

    return usr;
  }

  Future<void> sendCodeToPhoneNumber(
      String phonenumber,
      num timeout,
      Function afterVerificationCompleted,
      Function afterVerificationFailed,
      Function afterCodeSent,
      Function afterCodeAutoRetrievalTimeout) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) async {
      await auth.signInWithCredential(credential);
      afterVerificationCompleted();
    };

    final PhoneVerificationFailed verificationFailed = (authException) {
      afterVerificationFailed();
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      String smsCode = await afterCodeSent();

      print('-----------------------');

      print(smsCode);

      print('-----------------------');

      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(phoneAuthCredential);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      afterCodeAutoRetrievalTimeout();
    };

    return auth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        timeout: Duration(seconds: timeout),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  String parseAuthError(error) => _$parseAuthError(error);

  signOut() {
    return auth.signOut();
  }

  delete() {
    return user.delete();
  }

  Future<String> uploadFile(String filePath, {String directory}) async {
    File file = File(filePath);

    String reference = directory != null
        ? directory + '/' + basename(filePath)
        : basename(filePath);

    UploadTask task = storage.ref(reference).putFile(file);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  saveProfilePic(String src) {
    auth.currentUser.updateProfile(photoURL: src);
  }

  saveUserAndCompany(dynamic model) {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('saveUserAndCompany');
    return callable(model);
  }

  Stream<List<dynamic>> getUsersByList(List<String> userIds) {
    final List<Stream<dynamic>> streams = [];
    for (String id in userIds) {
      streams.add(firestore
          .collection('users')
          .doc(id)
          .snapshots()
          .map((DocumentSnapshot snap) => snap.data()));
    }
    return StreamZip<dynamic>(streams).asBroadcastStream();
  }

  Stream<List<Chat>> streamConversations(String uid) {
    return firestore
        .collection('chats')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot doc) => Chat.fromJson(doc.data()))
            .toList());
  }

  String get email => user.email;
}
