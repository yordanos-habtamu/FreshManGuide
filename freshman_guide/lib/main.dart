// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   const firebaseConfig = FirebaseOptions(
//   apiKey: "AIzaSyBbjXG9CLtU8yQ3z9TdbFcLn2EZLaP37Kg",
//   authDomain: "bot-ecom.firebaseapp.com",
//   projectId: "bot-ecom",
//   storageBucket: "bot-ecom.firebasestorage.app",
//   messagingSenderId: "485477818454",
//   appId: "1:485477818454:web:57da1073c512a9fb6d5bf7"
//   );
//   await Firebase.initializeApp(options:firebaseConfig);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:freshman_guide/buisness/features/presentation/fifthScreen.dart';

import 'package:freshman_guide/buisness/features/presentation/fourthScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/main_screen_business.dart';

import 'package:freshman_guide/clubManager/features/presentation/fifthScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/secondScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/thirdScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clubs App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      //ROUTE FOR CLUB SCREEN

      // initialRoute: '/',
      // routes: {
      //   // '/': (context) => const ClubsOverviewScreen(),
      //   '/': (context) => const MainScreen(),
      //   '/IT_club': (context) => const ITClubChatScreen(),
      //   '/charity_club': (context) => const ArrangeEventScreen(),
      //   '/notification_screen': (context) => const NotificationsScreen(),
      //   '/profile': (context) => const PostClubScreen(),
      // },

      // ROUTE FOR BUSINESS SCREEN

      initialRoute: '/',
      routes: {
        // '/': (context) => const AddBannerScreen(),

        //FOR CLUB MANAGER SCREENS
        // '/': (context) => const MainScreen(),

        //FOR BUSINESS SCREENS
        '/': (context) => const NavigationScreen(),

        '/IT_club': (context) => const ITClubChatScreen(),
        '/charity_club': (context) => const ArrangeEventScreen(),
        // '/notification_screen': (context) => const NotificationsScreen(),
        '/profile': (context) => const PostClubScreen(),
      },
    );
  }
}
