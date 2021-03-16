import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_error.dart';

class UserDaoService {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool connected = false;

  String verificationId = '';

  UserDaoService() {
    auth.onAuthStateChanged.listen((FirebaseUser usr) {
      user = usr;
      connected = usr != null;

      // auth.signOut();
    });
  }

  Future<DocumentReference> save(String collection, dynamic data) {
    return firestore
        .collection(collection)
        .add({...data, 'createdAt': DateTime.now()});
  }

  Stream<DocumentSnapshot> getUser() {
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    // print(user.uid);
    // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    return firestore.collection('users').document(user.uid).snapshots();
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
    if (query != null) return query.getDocuments();
    return col.getDocuments();
  }

  getDocsEqualCriteria(String collection,
      {String index, String field, String sortingField}) {
    var col = Firestore.instance.collection(collection);
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
      return query.getDocuments();
    else
      return col.getDocuments();
  }

  Stream<FirebaseUser> getFirebaseUser() {
    return auth.onAuthStateChanged;
  }

  Future<void> updateUser(var data) {
    return firestore.collection('users').document(user.uid).updateData(data);
  }

  Future<AuthResult> emailSignUp(String email, String password) async {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  Future<void> sendVerificationEmail(AuthResult result) {
    return result.user.sendEmailVerification();
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final FirebaseUser usr =
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

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      afterVerificationFailed();
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      String smsCode = await afterCodeSent();

      print('-----------------------');

      print(smsCode);

      print('-----------------------');

      AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
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

  String get email => user.email;
}
