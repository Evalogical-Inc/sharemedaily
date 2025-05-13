import 'package:google_sign_in/google_sign_in.dart';

class SignInServices {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> googleLogin() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> googleLogout() => _googleSignIn.signOut();

//   signInWithGoogle() async {
// // begin interactive sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
// // obtaiin auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     print(gUser!.authentication);
// // create a new credential for user
//     // final credential = GoogleAuthProvider.credential(
//     //   accessToken: gAuth.accessToken,
//     //   idToken: gAuth.idToken,
//     // );
//   }
// finally, lets sign in
}
