import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pix_hunt_project/Models/auth_model.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthService({required this.firebaseAuth, required this.googleSignIn});

Future<User?> getCurrentUser()async{
  await firebaseAuth.currentUser?.reload();
  return firebaseAuth.currentUser;
}

  Future<String> getCurrentUserUid() async {
    return firebaseAuth.currentUser!.uid;
  }

  Future<UserCredential> createAccount({
    required Auth auth,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: auth.email!,
      password: password,
    );
  }

  Future<void> updateUserName(String name)async{
var user= firebaseAuth.currentUser;
      if (name != user?.displayName && name!='') {
        await user?.updateDisplayName(name);
      }    
  }

  Future<void> updateEmail(String newEmail ,String password)async{
 var user= firebaseAuth.currentUser;
 if (newEmail != user?.email) {
      final cred = EmailAuthProvider.credential(
        email: user?.email??'',
        password: password,
      );
      await firebaseAuth.currentUser?.reauthenticateWithCredential(cred);
  
        await user?.verifyBeforeUpdateEmail(newEmail);
      }
  }

  Future<UserCredential> loginAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    await googleSignIn.disconnect();
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<Auth> signInWithGOOGLE() async {
    await googleSignIn.initialize(
      serverClientId:
          '991811837814-93f6uiiq4iartg4qrt9gq0s9ndlkoeb7.apps.googleusercontent.com',
    );

    // GoogleSignIn googleSignIn = GoogleSignIn.instance;

    GoogleSignInAccount googleSignInAccount = await googleSignIn.authenticate();

    GoogleSignInAuthentication googleSignInAuthentication =
        googleSignInAccount.authentication;

    AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential userCredential = await firebaseAuth.signInWithCredential(
      authCredential,
    );

    Auth auth = Auth(
      email: userCredential.user!.email,
      name: userCredential.user!.displayName,
      uid: userCredential.user!.uid,
      createdAtDate: DateTime.now().toString(),
    );
    return auth;
  }
}
