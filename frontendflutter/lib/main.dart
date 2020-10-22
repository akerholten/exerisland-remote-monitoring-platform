import 'package:flutter/material.dart';
import 'src/handlers/tools.dart';
import 'src/constants/constants.dart';
import 'src/handlers/loginHandler.dart';
import 'src/pages/loginPage.dart';
import 'src/pages/signupPage.dart';
import 'src/pages/therapistDashboard.dart';
import 'src/pages/patientDashboard.dart';
import 'src/pages/forgotPasswordPage.dart';
import 'src/constants/route_names.dart';

void main() {
  // Can potentially do verification of login / cookie stuff here, and show correct screen accordingly
  // And what about url navigation / stack navigation?
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.applicationName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          headline4: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[300],
          ),
        ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => MyHomePage(title: Constants.applicationName),
        Routes.Login: (context) => LoginPage(),
        Routes.Signup: (context) => SignupPage(),
        Routes.ForgotPassword: (context) => ForgotPasswordPage(),

        // PROTECTED ROUTES (Always checks cookie)
        Routes.Dashboard: (context) {
          Tools.verifyCookieLogin(context);

          // TODO: Do an if check to see if the person is therapist or not,
          // if not, then go to specificPersonDashboard of that person here
          return TherapistDashboard();
        }, // TODO: Solve difference between showing therapist and patient dashboard when going here
        Routes.SpecificPersonDashboard: (context) {
          Tools.verifyCookieLogin(context);
          // TODO: Solve handling ID to retrieve correct person
          return PatientDashboard();
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget currentPage;

  void _tryCookieLogin() async {
    bool loggedIn = await LoginHandler.isLoggedInWithCookie();

    if (loggedIn) {
      // TODO: Check if user is observer or patient here? And then push correct accordingly
      Navigator.of(context).pushReplacementNamed(Routes.Dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    _tryCookieLogin();

    currentPage = LoginPage();

    return currentPage;
  }
}
