import 'package:firebase_core/firebase_core.dart';

// Your Firebase project configuration
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      // apiKey: 'YOUR_API_KEY',
      // appId: 'YOUR_APP_ID',
      // messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      // projectId: 'YOUR_PROJECT_ID',
      // storageBucket: 'YOUR_STORAGE_BUCKET',
      // authDomain: 'YOUR_AUTH_DOMAIN',
        apiKey: "AIzaSyB3dkTy0AaLjUjKi6wlEMDtjDzYI4T7Qic",
        authDomain: "newsgenie-5c505.firebaseapp.com",
        projectId: "newsgenie-5c505",
        storageBucket: "newsgenie-5c505.appspot.com",
        messagingSenderId: "774970205401",
        appId: "1:774970205401:web:a7fd8fa28ab726c7a70ac8"
    );
  }
}
