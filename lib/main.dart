import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/localization/l10n/l10n.dart';
import 'package:yelpax_pro/config/localization/locale_provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/config/themes/theme_provider.dart';
import 'package:yelpax_pro/core/utils/app_restart.dart';
import 'package:yelpax_pro/features/inbox/presentation/screens/signup_screen.dart';
import 'package:yelpax_pro/generated/app_localizations.dart';
import 'package:yelpax_pro/providers/providers.dart';
import 'package:yelpax_pro/shared/screens/unexpected_error_screen.dart';
import 'package:yelpax_pro/shared/screens/unexpected_release_mode_error.dart';

import 'config/themes/theme_mode_type.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      ErrorWidget.builder = (FlutterErrorDetails details) {
        if (kReleaseMode) {
          return UnexpectedReleaseModeError(message: details.toString());
        }
        return MaterialApp(
          navigatorKey: navigatorKey,
          home: UnexpectedErrorScreen(message: details.toString()),
        );
      };
      runApp(
        RestartWidget(
          child: MultiProvider(providers: appProviders, child: const MyApp()),
        ),
      );
    },
    (error, stack) {
      Logger().log(
        Level.error,
        "Dart Server Error occured on $error on Stack \n $stack",
      );

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => UnexpectedErrorScreen(message: 'message'),
        ),
      );
      // navigatorKey.currentState!.pushNamed(AppRouter.unknownRouteScreen);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
  
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      onUnknownRoute: (settings) => AppRouter.unknownRoute(settings),
      locale: Locale('en'),
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: themeProvider.themeData,
      home: SignupScreen()
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//     required this.themeProvider,
//   });
//   final ThemeProvider themeProvider;
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
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             DropdownButton<ThemeModeType>(
//               value: widget.themeProvider.currentTheme,
//               items: ThemeModeType.values.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type.toString().split('.').last),
//                 );
//               }).toList(),
//               onChanged: (type) {
//                 if (type != null) {
//                   widget.themeProvider.setTheme(type);
//                 }
//               },
//             ),
//                 Text('سلام و علیکم',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
//             Text(AppLocalizations.of(context)!.icrement),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           throw Exception('Exception');
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
