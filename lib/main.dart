import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Firebase',
      home: MyHomePage(title: "Flutter Firebase Dersleri"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth auth;
  String _email = "brksvncli@gmail.com";
  String _password = "burak2901";

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((user) {
      if (user == null) {
        debugPrint("User is currently signed out!");
      } else {
        debugPrint(
            "User is signed in! Email: ${user.email} - Email Status: ${user.emailVerified}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                createUserEmailAndPassword();
              },
              child: const Text(
                "Email & Şifre Kayıt",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                loginUserEmailAndPassword();
              },
              child: const Text(
                "Email & Şifre Giris",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () {
                signOutUser();
              },
              child: const Text(
                "Oturumu Kapat",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                deleteUser();
              },
              child: const Text(
                "Hesabı Sil",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                changePassword();
              },
              child: const Text(
                "Şifre Değiştir",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                changeEmail();
              },
              child: const Text(
                "Email Değiştir",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                signInWithGoogle();
              },
              child: const Text(
                "Google",
                style: TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                loginWithPhoneNumber();
              },
              child: const Text(
                "Telefon",
                style: TextStyle(color: Colors.white),
              )),
        ]),
      ),
    );
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      var _myUser = _userCredential.user;

      if (!_myUser!.emailVerified) {
        await _myUser.sendEmailVerification();
      } else {
        debugPrint("User email is verified!");
      }
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signOutUser() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

  void deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.delete();
    } else {
      debugPrint("Please login your account!");
    }
  }

  void changePassword() async {
    try {
      await auth.currentUser!.updatePassword("newPassword");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        debugPrint("Reauthanticate");
        var credential =
            EmailAuthProvider.credential(email: _email, password: _password);
        await auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.updatePassword("newPassword");
        await auth.signOut();
        debugPrint("Şifre Güncellendi");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Bu metot değişmiş ve Email göndermeden onay maili göndermemi istiyor.
  void changeEmail() async {
    try {
      await auth.currentUser!.updateEmail("brksevincli@gmail.com");
      await auth.signOut();
      debugPrint("Email değiştirildi");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void loginWithPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+905071908895',
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("Verification Complete Tetiklendi");
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        String _smsCode = "290195";
        debugPrint("Code Send Tetiklendi");
        var _credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: _smsCode);

        auth.signInWithCredential(_credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
