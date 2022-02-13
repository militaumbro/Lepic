import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_course/src/model/audio_database.dart';
import 'package:flutter_smart_course/src/model/hive/hive_models.dart';
import 'package:flutter_smart_course/src/model/quizz_database.dart';
import 'package:flutter_smart_course/src/model/reader_database.dart';
import 'package:flutter_smart_course/src/model/text_database.dart';
import 'package:flutter_smart_course/src/pages/menus_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:starflut/starflut.dart';
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
  Hive.registerAdapter(HiveAudioAdapter());
  Hive.registerAdapter(HiveQuizzAdapter());
  Hive.registerAdapter(HiveQuizzQuestionAdapter());
  Hive.registerAdapter(HiveReadingsListAdapter());
  Hive.registerAdapter(AnswerAdapter());
  Hive.registerAdapter(ReadingErrorAdapter());
  Hive.registerAdapter(ErrorControllerAdapter());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    runPythonCodePrep();
  }

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
        Provider<AudioDatabase>(
          create: (_) => AudioDatabase(),
        ),
        Provider<ReadersDatabase>(
          create: (_) => ReadersDatabase(),
        ),
        Provider<QuizzDatabase>(
          create: (_) => QuizzDatabase(),
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

  Future<void> runPythonCodePrep() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      StarCoreFactory starcore = await Starflut.getFactory();
      StarServiceClass Service = await starcore.initSimple("test", "123", 0, 0, []);
      await starcore
          .regMsgCallBackP((int serviceGroupID, int uMsg, Object wParam, Object lParam) async {
        print("$serviceGroupID  $uMsg   $wParam   $lParam");

        return null;
      });
      StarSrvGroupClass SrvGroup = await Service["_ServiceGroup"];

      /*---script python--*/
      bool isAndroid = await Starflut.isAndroid();
      if (isAndroid == true) {
        await Starflut.copyFileFromAssets(
            "testcallback.py", "flutter_assets/starfiles", "flutter_assets/starfiles");
        await Starflut.copyFileFromAssets(
            "testpy.py", "flutter_assets/starfiles", "flutter_assets/starfiles");
        await Starflut.copyFileFromAssets(
            "python3.6.zip", "flutter_assets/starfiles", null); //desRelatePath must be null
        await Starflut.copyFileFromAssets("zlib.cpython-36m.so", null, null);
        await Starflut.copyFileFromAssets("unicodedata.cpython-36m.so", null, null);
        await Starflut.loadLibrary("libpython3.6m.so");
      }

      String docPath = await Starflut.getDocumentPath();
      print("docPath = $docPath");
      String resPath = await Starflut.getResourcePath();
      print("resPath = $resPath");
      dynamic rr1 = await SrvGroup.initRaw("python36", Service);

      print("initRaw = $rr1");
      var result = await SrvGroup.loadRawModule(
          "python", "", resPath + "/flutter_assets/starfiles/" + "testpy.py", false);
      print("loadRawModule = $result");
      dynamic python = await Service.importRawContext("python", "","", false, "");
      print("python = " + await python.getString());
      StarObjectClass retobj = await python.call("tt", ["hello ", "world"]);
      print(await retobj[0]);
      print(await retobj[1]);
      print(await python["g1"]);
      StarObjectClass yy = await python.call("yy", ["hello ", "world", 123]);
      print(await yy.call("__len__", []));
      StarObjectClass multiply = await Service.importRawContext("python", "Multiply","", true, "");
      StarObjectClass multiplyInst = await multiply.newObject(["", "", 33, 44]);
      print(await multiplyInst.getString());
      print(await multiplyInst.call("multiply", [11, 22]));
      await SrvGroup.clearService();
      await starcore.moduleExit();
      platformVersion = 'Python 3.6';
    } on PlatformException catch (e) {
      print("{$e.message}");
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
}
