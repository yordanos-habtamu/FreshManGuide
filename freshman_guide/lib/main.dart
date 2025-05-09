// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter/material.dart';

// import 'package:freshman_guide/buisness/features/presentation/main_screen_business.dart';
// import 'package:freshman_guide/clubManager/features/data/repositories/club_repository.dart';

// import 'package:freshman_guide/clubManager/features/presentation/fifthScreen.dart';
// import 'package:freshman_guide/clubManager/features/presentation/main_screen.dart';
// import 'package:freshman_guide/clubManager/features/presentation/secondScreen.dart';
// import 'package:freshman_guide/clubManager/features/presentation/thirdScreen.dart';
// import 'package:freshman_guide/clubManager/features/providers/club_provider.dart';
// import 'package:freshman_guide/login.dart';
// import 'package:freshman_guide/shared/services/provider/login_provider.dart';
// import 'package:freshman_guide/shared/services/user_auth.dart';
// import 'package:provider/provider.dart';

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
//   runApp( MyApp());
// }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',

// //       home: const HomePage(),
// //     );
// //   }
// // }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => ClubProvider(ClubService()),
//         ),
//          ChangeNotifierProvider(
//           create: (_) => SigninProvider(SigninService()),
//         ),
//       ],
//       child: MaterialApp(
//         home: HomePage(),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Clubs App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),

//       //ROUTE FOR CLUB SCREEN

//       // initialRoute: '/',
//       // routes: {
//       //   // '/': (context) => const ClubsOverviewScreen(),
//       //   '/': (context) => const MainScreen(),
//       //   '/IT_club': (context) => const ITClubChatScreen(),
//       //   '/charity_club': (context) => const ArrangeEventScreen(),
//       //   '/notification_screen': (context) => const NotificationsScreen(),
//       //   '/profile': (context) => const PostClubScreen(),
//       // },

//       // ROUTE FOR BUSINESS SCREEN

//       initialRoute: '/',
//       routes: {
//         // '/': (context) => const AddBannerScreen(),
//          '/':(context)=>LoginScreen(),
//         //FOR CLUB MANAGER SCREENS
//         '/main': (context) => const MainScreen(),

//         //FOR BUSINESS SCREENS
//         // '/': (context) => const NavigationScreen(),

//         '/IT_club': (context) => const ITClubChatScreen(),
//         '/charity_club': (context) => const ArrangeEventScreen(),
//         // '/notification_screen': (context) => const NotificationsScreen(),
//         '/profile': (context) => const PostClubScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshman_guide/buisness/features/data/repositories/business_repo.dart';
import 'package:freshman_guide/buisness/features/data/repositories/menu_service.dart';
import 'package:freshman_guide/buisness/features/presentation/sixthScreen.dart';
import 'package:freshman_guide/buisness/features/presentation/thirdScreen.dart';
import 'package:freshman_guide/buisness/features/provider/menu_provider.dart';
import 'package:freshman_guide/clubManager/features/presentation/fifthScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/firstScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/secondScreen.dart';
import 'package:freshman_guide/clubManager/features/presentation/thirdScreen.dart';
import 'package:freshman_guide/clubManager/features/providers/club_provider.dart';
import 'package:provider/provider.dart';
import 'package:freshman_guide/clubManager/features/data/repositories/club_repository.dart';
import 'package:freshman_guide/clubManager/features/presentation/main_screen.dart';
import 'package:freshman_guide/login.dart';
import 'package:freshman_guide/shared/services/provider/login_provider.dart';
import 'package:freshman_guide/shared/services/user_auth.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // options: DefaultFirebaseOptions.currentPlatform,
//     options: FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId)
//   );
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseConfig = FirebaseOptions(
      apiKey: "AIzaSyBbjXG9CLtU8yQ3z9TdbFcLn2EZLaP37Kg",
      authDomain: "bot-ecom.firebaseapp.com",
      projectId: "bot-ecom",
      storageBucket: "bot-ecom.firebasestorage.app",
      messagingSenderId: "485477818454",
      appId: "1:485477818454:web:57da1073c512a9fb6d5bf7");
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ClubProvider(ClubService()),
        ),
        ChangeNotifierProvider(
          create: (_) => SigninProvider(SigninService()),
        ),
        ChangeNotifierProvider(
            create: (_) => MenuProvider(MenuService(MenuRepository()))),
      ],
      child: MaterialApp(
        title: 'Clubs App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/clubs-overview': (context) => const ClubsOverviewScreen(),
          '/it-club': (context) => const ITClubChatScreen(),
          '/arrange-event': (context) =>
              const ArrangeEventScreen(clubId: 'tech-club-id'),
          '/notifications': (context) => const NotificationsScreen(),
          '/post-club': (context) =>
              const PostClubScreen(clubId: 'tech-club-id'),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
