import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NotificationDemo.dart';
import 'Screens/AddMedsPage.dart';
import 'Screens/CalenderPage.dart';
import 'Screens/Changepasswordpage.dart';
import 'Screens/Feedbackpage.dart';
import 'Screens/ForgotPasswordPage.dart';
import 'Screens/DetailsPage.dart';
import 'Screens/GetStartedPage.dart';
import 'Screens/LandingPage.dart';
import 'Screens/NavPages.dart';
import 'Screens/NewmedsPage.dart';
import 'Screens/PeriodTrackerPage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/RegisterPage.dart';
import 'Screens/ReportPage.dart';
import 'Screens/SettingPage.dart';
import 'Screens/PeriodDetailsPage.dart';
import 'services/NotificationService.dart';
import 'viewmodels/Auth_viewmodel.dart';
import 'viewmodels/Meds_viewmodel.dart';
import 'viewmodels/Period_viewmodel.dart';
import 'package:provider/provider.dart';
import 'Components/Palette.dart';
import 'Screens/EmailVerifyPage.dart';
import 'Screens/FinalLogPage.dart';
import 'Screens/HomePage.dart';
import 'Screens/LoginPage.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  tz.initializeTimeZones(); // Initialize the timezones
  NotificationService.initialize();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Add providers here
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>MedsViewModel()),
        ChangeNotifierProvider(create: (_)=>PeriodViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Pallete.primarySwatch,
          textTheme: GoogleFonts.poppinsTextTheme(), // Customize the font using Google Fonts
          // User this where you want to add poppins>>style: Theme.of(context).textTheme.headline6,
        ),
        //donot change this, rollback before you
        initialRoute: "/NavPages",//change the route here
        routes: {
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterPage(),
          "/profile": (context)=> const Profile(),

          "/landing":(context)=>LandingPage(),
          "/EmailVerify":(context)=>const EmailVerify(),

          "/Calender":(context)=>const CalendarPage(),
          "/SettingScreen":(context)=>const SettingScreen(),
          "/AddMedsPage":(context)=> AddMedsPage(),
          "/NavPages":(context)=> const NavPages(),
          "/forgotpass":(context)=>ForgotPasswordPage(),
          "/finalLog":(context)=> const finalLog(),
          "/ReportPage":(context)=> ReportPage(),
          "/Details-page":(context)=>const DetailsPage(),
          "/NotificationPage":(context)=>const NotificationDemo(),
          "/FeedbackPage":(context)=>FeedbackPage(),
          "/NewMedsPage":(context)=>const NewMedsPage(),
          "/GetStartedPage":(context)=>const GetStartedPage(),
          "/TrackPeriodPage":(context)=>const PeriodDetails(),
          "/TrackP":(context)=>const PeriodTracker(),
          "/changepassword":(context)=>ChangePasswordPage(),
          "/HomePage":(context)=>const HomePage(),

        },//Add the page here

      ),
    );
  }
}