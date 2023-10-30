// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGRPooDN-66Wu0-dERT8s1CmLv-ykEW6w',
    appId: '1:28348206438:web:e1026006a34a30e5',
    messagingSenderId: '28348206438',
    projectId: 'projetoademar',
    authDomain: 'projetoademar.firebaseapp.com',
    databaseURL: 'https://projetoademar.firebaseio.com',
    storageBucket: 'projetoademar.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUuppQOdWO5O9gEqEkxvgem9DlHXu47_E',
    appId: '1:28348206438:android:6afbebedabecab6fc60ca7',
    messagingSenderId: '28348206438',
    projectId: 'projetoademar',
    databaseURL: 'https://projetoademar.firebaseio.com',
    storageBucket: 'projetoademar.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqSVvxE_vc-U754NpQqWbhXiSOFIgGx1Y',
    appId: '1:28348206438:ios:e9f79ed2e02f165fc60ca7',
    messagingSenderId: '28348206438',
    projectId: 'projetoademar',
    databaseURL: 'https://projetoademar.firebaseio.com',
    storageBucket: 'projetoademar.appspot.com',
    iosClientId:
        '28348206438-o3g1lkq0d1gl5pc2rc7h36b2ts5ft9t8.apps.googleusercontent.com',
    iosBundleId: 'com.example.simpleProductCatalog',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqSVvxE_vc-U754NpQqWbhXiSOFIgGx1Y',
    appId: '1:28348206438:ios:f58385e34c9942c6c60ca7',
    messagingSenderId: '28348206438',
    projectId: 'projetoademar',
    databaseURL: 'https://projetoademar.firebaseio.com',
    storageBucket: 'projetoademar.appspot.com',
    iosClientId:
        '28348206438-ito8ivjqv51iqp1snm4a5g041s572i1o.apps.googleusercontent.com',
    iosBundleId: 'com.example.simpleProductCatalog.RunnerTests',
  );
}
