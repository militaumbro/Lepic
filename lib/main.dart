import 'package:flutter/material.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/menus_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(HiveTextAdapter());
  Hive.registerAdapter(HiveReadingAdapter());
  Hive.registerAdapter(HiveReaderAdapter());
  Hive.registerAdapter(HiveSchoolInfoAdapter());
  Hive.registerAdapter(HiveReadingDataAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var colorScheme = ColorScheme.light(
      primary: Colors.red,
      // secondary: const Color(0xFF002b66),
      secondary: Colors.orange[600],
      primaryVariant: Colors.red[700],
      onSecondary: Colors.white,
      onPrimary: Colors.white,
      onError: Colors.white,
    );

    var textTheme = GoogleFonts.quicksandTextTheme();

    var baseTheme = ThemeData(
      primaryColor: colorScheme.primary,
      primaryColorDark: colorScheme.primaryVariant,
      accentColor: colorScheme.secondary,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        color: colorScheme.primary,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: _buildTextTheme(textTheme, color: colorScheme.onPrimary),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
    );

    baseTheme = baseTheme.copyWith(
      textTheme: _buildTextTheme(textTheme),
      primaryTextTheme:
          _buildTextTheme(textTheme, color: colorScheme.onPrimary),
    );
    return MultiProvider(
      providers: [
        Provider<TextDatabase>(
          create: (_) => TextDatabase(),
        ),
        // Provider<AudioDatabase>(
        //   create: (_) => AudioDatabase(),
        // ),
        Provider<ReadersDatabase>(
          create: (_) => ReadersDatabase(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'BR'),
        ],
        title: "Lepic",
        theme: baseTheme,
        home: MenusPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme baseTheme, {Color color}) =>
      baseTheme.copyWith(
        overline: baseTheme.caption.copyWith(fontSize: 10, color: color),
        caption: baseTheme.caption.copyWith(fontSize: 12, color: color),
        bodyText1: baseTheme.bodyText1.copyWith(fontSize: 15, color: color),
        bodyText2: baseTheme.bodyText2.copyWith(fontSize: 15, color: color),
        subtitle1: baseTheme.subtitle1.copyWith(fontSize: 16, color: color),
        headline6: baseTheme.headline6.copyWith(fontSize: 20, color: color),
        headline5: baseTheme.headline5.copyWith(fontSize: 24, color: color),
        headline4: baseTheme.headline5.copyWith(fontSize: 34, color: color),
        headline3: baseTheme.headline5.copyWith(fontSize: 48, color: color),
        headline2: baseTheme.headline5.copyWith(fontSize: 60, color: color),
        headline1: baseTheme.headline5.copyWith(fontSize: 96, color: color),
      );
}
