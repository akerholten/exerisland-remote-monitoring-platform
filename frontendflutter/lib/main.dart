import 'package:flutter/material.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/pages/errorPage.dart';
import 'package:frontendflutter/src/pages/sessionPage.dart';
import 'src/components/alerts.dart';
import 'src/handlers/tools.dart';
import 'src/constants/constants.dart';
import 'src/handlers/loginHandler.dart';
import 'src/pages/loginPage.dart';
import 'src/pages/signupPage.dart';
import 'src/pages/therapistDashboard.dart';
import 'src/pages/patientDashboard.dart';
import 'src/pages/forgotPasswordPage.dart';
import 'src/constants/route_names.dart';
import 'dart:html';

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
      initialRoute: "/",
      onGenerateRoute: (settings) {
        // ----- LOGIN ROUTE -----
        if (settings.name == Routes.Login) {
          Tools.redirectIfAlreadyLoggedIn(context);
          return MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
            settings: RouteSettings(name: settings.name),
          );
        }
        // ----- SIGNUP ROUTE -----
        if (settings.name == Routes.Signup) {
          Tools.redirectIfAlreadyLoggedIn(context);

          return MaterialPageRoute(
            builder: (context) {
              return SignupPage();
            },
            settings: RouteSettings(name: settings.name),
          );
        }
        // ----- FORGOT PASSWORD ROUTE -----
        if (settings.name == Routes.ForgotPassword) {
          return MaterialPageRoute(
            builder: (context) {
              return ForgotPasswordPage();
            },
            settings: RouteSettings(name: settings.name),
          );
        }
        // ----- DASHBOARD ROUTE -----
        // TODO: change to contains and take into account when looking at specific session for personal user
        if (settings.name == Routes.Dashboard) {
          Tools.verifyCookieLogin(context);

          // Routing accordingly based on logged in or not and what type of logged in user
          if (window.localStorage.containsKey('userType')) {
            if (window.localStorage['userType'] == 'patient') {
              return MaterialPageRoute(
                builder: (context) {
                  return PatientDashboard(
                    personalPage: true,
                  );
                },
                settings: RouteSettings(name: settings.name),
              );
            } else if (window.localStorage['userType'] == '') {
              return MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                  settings: RouteSettings(name: Routes.Login));
            }
          }

          return MaterialPageRoute(
            builder: (context) {
              return TherapistDashboard();
            },
            settings: RouteSettings(name: settings.name),
          );
        }
        // ----- SPECIFIC PERSONAL SESSION DASHBOARD ROUTE -----
        // TODO: this currently does not totally work as intended, the link becomes the same
        // as for obersvers point-of-view
        if (settings.name.contains(
            Routes.Dashboard + "/" + Routes.SpecificSessionDashboard)) {
          Tools.verifyCookieLogin(context);
          // Cast the arguments to the correct type: ScreenArguments.
          PatientSessionArguments args = settings.arguments;

          // Check in-case we are not logged in anymore
          if (window.localStorage.containsKey('userType')) {
            if (window.localStorage['userType'] == '') {
              return MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                  settings: RouteSettings(name: Routes.Login));
            }
          }

          if (args == null || args.sessionId <= -1) {
            // URL looks like this http://localhost:3000/#/dashboard/session/SOMESESSIONID
            // meaning that the split will give us: [#, dashboard, session, SOMESESSIONID]
            var argArray = settings.name.split("/");

            if (argArray.length <= 2) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorPage(title: "404 page not found");
                },
                settings: RouteSettings(name: settings.name),
              );
            }

            // Collecting args from URL (does that work?)
            args = new PatientSessionArguments("", int.parse(argArray[3]));

            //   if (args.patientShortId.length < 1 ||
            //       args.patientShortId.length > 20) {
            //     return MaterialPageRoute(
            //       builder: (context) {
            //         return ErrorPage(title: "404 page not found");
            //       },
            //       settings: RouteSettings(name: settings.name),
            //     );
            //   }
            // }

            // Then, extract the required data from the arguments and
            // pass the data to the correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return SessionPage(
                  personalPage: true,
                  sessionId: args.sessionId,
                );
              },
              settings: RouteSettings(
                  name: Routes.Dashboard +
                      "/" +
                      Routes.SpecificSessionDashboard +
                      "/" +
                      args.sessionId.toString()),
            );
          }
        }
        // ----- SPECIFIC PATIENT SESSION ROUTE -----
        if (settings.name.contains(Routes.SpecificSessionDashboard)) {
          Tools.verifyCookieLogin(context);
          // Cast the arguments to the correct type: ScreenArguments.
          PatientSessionArguments args = settings.arguments;

          // Check in-case we are not logged in anymore
          if (window.localStorage.containsKey('userType')) {
            if (window.localStorage['userType'] == '') {
              return MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                  settings: RouteSettings(name: Routes.Login));
            }
          }

          if (args == null || args.patientShortId.length < 1) {
            // URL looks like this http://localhost:3000/#/id/SOMEID/session/SOMESESSIONID
            // meaning that the split will give us: [#, id, SOMEID, session, SOMESESSIONID]
            var argArray = settings.name.split("/");

            if (argArray.length <= 2) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorPage(title: "404 page not found");
                },
                settings: RouteSettings(name: settings.name),
              );
            }

            // Collecting args from URL (does that work?)
            args = new PatientSessionArguments(
                argArray[2], int.parse(argArray[4]));

            if (args.patientShortId.length < 1 ||
                args.patientShortId.length > 20) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorPage(title: "404 page not found");
                },
                settings: RouteSettings(name: settings.name),
              );
            }
          }

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return SessionPage(
                patientShortId: args.patientShortId,
                sessionId: args.sessionId,
              );
            },
            settings: RouteSettings(
                name: Routes.SpecificPersonDashboard +
                    "/" +
                    args.patientShortId +
                    Routes.SpecificSessionDashboard +
                    "/" +
                    args.sessionId.toString()),
          );
        }
        // ----- SPECIFIC PERSON DASHBOARD ROUTE -----
        if (settings.name.contains(Routes.SpecificPersonDashboard)) {
          Tools.verifyCookieLogin(context);
          // Cast the arguments to the correct type: ScreenArguments.
          PatientDashboardArguments args = settings.arguments;

          // Check in-case we are not logged in anymore
          if (window.localStorage.containsKey('userType')) {
            if (window.localStorage['userType'] == '') {
              return MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                  settings: RouteSettings(name: Routes.Login));
            }
          }

          if (args == null || args.id.length < 1) {
            // URL looks like this http://localhost:3000/#/id/SOMEID
            // meaning that the split will give us: [#, id, SOMEID]
            var argArray = settings.name.split("/");

            if (argArray.length <= 2) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorPage(title: "404 page not found");
                },
                settings: RouteSettings(name: settings.name),
              );
            }

            // Collecting args from URL (does that work?)
            args = new PatientDashboardArguments(argArray[2]);

            if (args.id.length < 1 || args.id.length > 20) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorPage(title: "404 page not found");
                },
                settings: RouteSettings(name: settings.name),
              );
            }
          }

          // Then, extract the required data from the arguments and
          // pass the data to the correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PatientDashboard(shortId: args.id);
            },
            settings: RouteSettings(
                name: Routes.SpecificPersonDashboard + "/" + args.id),
          );
        }
        // ----- HOME ROUTE -----
        if (settings.name == "/") {
          return MaterialPageRoute(
            builder: (context) {
              return MyHomePage(title: Constants.applicationName);
            },
            settings: RouteSettings(name: settings.name),
          );
        }
      },
      // routes: {
      //   '/': (context) => MyHomePage(title: Constants.applicationName),
      //   Routes.Login: (context) => LoginPage(),
      //   Routes.Signup: (context) => SignupPage(),
      //   Routes.ForgotPassword: (context) => ForgotPasswordPage(),

      //   // PROTECTED ROUTES (Always checks cookie)
      //   Routes.Dashboard: (context) {
      //     Tools.verifyCookieLogin(context);

      //     // TODO: Do an if check to see if the person is therapist or not,
      //     // if not, then go to specificPersonDashboard of that person here
      //     return TherapistDashboard();
      //   }, // TODO: Solve difference between showing therapist and patient dashboard when going here
      //   Routes.SpecificPersonDashboard: (context) {
      //     Tools.verifyCookieLogin(context);
      //     // TODO: Solve handling ID to retrieve correct person
      //     return PatientDashboard();
      //   }
      // },
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

    Tools.redirectIfAlreadyLoggedIn(context);

    currentPage = LoginPage();

    return currentPage;
  }
}
