// سكربت Dart احترافي لتوليد مشروع Flutter كامل بترتيب Clean Architecture
// يحتوي على ملفات core, features, main app مع كود فعلي داخل كل ملف
import 'dart:io';
import 'package:path/path.dart';

void main(List<String> arguments) async {
  final projectDir = Directory.current;
  final projectName = basename(projectDir.path);
  final libDir = Directory(join(projectDir.path, 'lib'));

  await _generateCore(libDir, projectName);
  await _generateFeatures(libDir, projectName);
  await _generateMainApp(libDir, projectName);
  await _generateAssetsFolders(projectDir);
  await _generateLocalizationFiles(projectDir);
  await _generateReadme(projectDir, projectName);
  await _generatePubspecYaml(projectDir, projectName);

  print('\n✅ Flutter project is fully ready with Clean Architecture 🇪🇬');
}

Future<void> _generateAssetsFolders(Directory projectDir) async {
  final assetDirs = [
    'assets/images',
    'assets/icons',
    'assets/lottie',
    'assets/lang',
  ];
  for (final dir in assetDirs) {
    await Directory(join(projectDir.path, dir)).create(recursive: true);
  }
}

Future<void> _generateLocalizationFiles(Directory projectDir) async {
  final langDir = Directory(join(projectDir.path, 'assets/lang'));

  await File(join(langDir.path, 'en.json')).writeAsString('''{
 "appName": "My App",
 "welcome": "Welcome",
 "login": "Login",
 "signup": "Sign Up"
}''');

  await File(join(langDir.path, 'ar.json')).writeAsString('''{
 "appName": "تطبيقي",
 "welcome": "مرحبًا",
 "login": "تسجيل الدخول",
 "signup": "إنشاء حساب"
}''');
}

Future<void> _generateReadme(Directory projectDir, String projectName) async {
  final readmeFile = File(join(projectDir.path, 'README.md'));
  await readmeFile.writeAsString('''
Hello Created By Abdalluh Essam 🇪🇬🇪🇬🇪
abdallhesam100@gmail.com




# $projectName


🚀 Clean Architecture Flutter Project Generated Automatically


## Structure


```
lib/
├── core/
│   ├── constants
│   ├── network
│   ├── errors
│   ├── utils
│   ├── services
│   ├── routing
│   ├── theme
│   ├── cubit
│   └── extensions
├── features/
│   ├── splash
│   ├── onboarding
│   ├── auth
│   └── home
├── app.dart
├── main.dart
└── app_bloc_observer.dart
```


## Getting Started
```bash
flutter pub get
flutter run
```


---


✅ Built with ❤️ using the Clean Architecture Generator


Hello Created By Abdalluh Essam 🇪🇬🇪🇬🇪
''');
}

Future<void> _generateCore(Directory libDir, String projectName) async {
  final coreDir = Directory(join(libDir.path, 'core'));
  final structure = {
    'constants': {
      'app_constants.dart': _appConstantsCode(),
      'endpoint_constants.dart': _endpointConstantsCode(),
      'strings_constants.dart': _stringsConstantsCode(),
    },
    'network': {
      'api_consumer.dart': _apiConsumerCode(),
      'dio_consumer.dart': _dioConsumerCode(),
      'interceptors.dart': _interceptorsCode(),
      'status_code.dart': _statusCodeCode(),
    },
    'errors': {
      'exceptions.dart': _exceptionsCode(),
      'failures.dart': _failuresCode(),
    },
    'utils': {
      'app_utils.dart': _appUtilsCode(),
      'app_shared_preferences.dart': _appPrefsCode(),
    },
    'services': {
      'locale_service.dart': _localeServiceCode(),
      'theme_service.dart': _themeServiceCode(),
    },
    'routing': {
      'app_router.dart': _appRouterCode(projectName),
      'routes.dart': _routesCode(),
    },
    'theme': {
      'app_theme.dart': _appThemeCode(),
      'app_colors.dart': _appColorsCode(),
    },
    'cubit/locale': {
      'locale_cubit.dart': _localeCubitCode(),
      'locale_state.dart': _localeStateCode(),
    },
    'cubit/theme': {
      'theme_cubit.dart': _themeCubitCode(),
      'theme_state.dart': _themeStateCode(),
    },
    'extensions': {
      'navigation_extensions.dart': _navigationExtCode(),
      'sizedbox_extensions.dart': _sizedBoxExtCode(),
      'theme_extensions.dart': _themeExtCode(),
    },
  };

  for (final entry in structure.entries) {
    final dir = Directory(join(coreDir.path, entry.key));
    await dir.create(recursive: true);
    for (final fileEntry in entry.value.entries) {
      final filePath = join(dir.path, fileEntry.key);
      await File(filePath).writeAsString(fileEntry.value);
    }
  }
}

Future<void> _generateFeatures(Directory libDir, String projectName) async {
  final featuresDir = Directory(join(libDir.path, 'features'));
  await featuresDir.create(recursive: true);

  final splashDir = Directory(
    join(featuresDir.path, 'splash/presentation/screens'),
  );
  final onboardingDir = Directory(
    join(featuresDir.path, 'onboarding/presentation/screens'),
  );

  await splashDir.create(recursive: true);
  await onboardingDir.create(recursive: true);

  await File(
    join(splashDir.path, 'splash_screen.dart'),
  ).writeAsString(_splashScreenCode(projectName));

  await File(
    join(onboardingDir.path, 'onboarding_screen.dart'),
  ).writeAsString(_onboardingScreenCode(projectName));
}

Future<void> _generateMainApp(Directory libDir, String projectName) async {
  await File(join(libDir.path, 'main.dart')).writeAsString(_mainCode());
  await File(join(libDir.path, 'app.dart')).writeAsString(_appCode());
  await File(
    join(libDir.path, 'app_bloc_observer.dart'),
  ).writeAsString(_blocObserverCode());
}

Future<void> _generatePubspecYaml(
  Directory projectDir,
  String projectName,
) async {
  final flutterCmd = Platform.isWindows ? 'flutter.bat' : 'flutter';

  late final String flutterVersionOutput;
  try {
    final flutterVersionResult = await Process.run(flutterCmd, ['--version']);
    flutterVersionOutput = flutterVersionResult.stdout.toString();
  } catch (e) {
    stderr.writeln(
        '❌ فشل في تشغيل flutter --version. تأكد أن Flutter موجود في PATH.');
    rethrow;
  }

  // استخراج إصدار Dart باستخدام RegExp
  final sdkMatch = RegExp(r'Dart\sSDK\sversion:\s(\d+\.\d+\.\d+)')
      .firstMatch(flutterVersionOutput);
  final dartVersion = sdkMatch != null ? sdkMatch.group(1)! : '3.0.0';
  final dartVersionClean = dartVersion.replaceAll('^', '');

  // استخراج إصدار Flutter
  final flutterMatch =
      RegExp(r'Flutter\s(\d+\.\d+\.\d+)').firstMatch(flutterVersionOutput);
  final flutterVersion =
      flutterMatch != null ? flutterMatch.group(1)! : 'unknown';

  final pubspecContent = '''
name: $projectName
description: A new Flutter project with Clean Architecture by Abdalluh Essam
# Flutter version on machine: $flutterVersion
publish_to: 'none'

environment:
  sdk: '>=$dartVersionClean <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  dio:
  shared_preferences:
  easy_localization:
  intl:
  equatable:
  get_it:
  cached_network_image:
  flutter_screenutil:
  flutter_animate:
  freezed_annotation:
  json_annotation:
  flutter_native_splash:
  animate_do:
  lottie:
  google_fonts:
  flutter_launcher_icons:
  animator:
  dartz:
  flutter_svg:
  cupertino_icons:

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner:
  freezed:
  json_serializable:
  bloc_test:
  mockito:
  flutter_lints:

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/lottie/
    - assets/lang/
''';

  final file = File(join(projectDir.path, 'pubspec.yaml'));
  await file.writeAsString(pubspecContent);

  print('📄 تم إنشاء ملف pubspec.yaml بنجاح!');
}

// ============================ الأكواد ============================

String _appConstantsCode() => '''
import 'dart:ui';


class AppConstants {
 static const String appName = 'My App';
 static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];
 static const String localeKey = 'app_locale';
 static const String themeKey = 'app_theme';
}
''';

String _endpointConstantsCode() => '''
class EndpointConstants {
 static const String baseUrl = 'https://api.example.com/v1';
 // Add your endpoints here
}
''';

String _stringsConstantsCode() => '''
class StringsConstants {
 static const Map<String, String> en = {
   'appName': 'My App',
 };


 static const Map<String, String> ar = {
   'appName': 'تطبيقي',
 };
}
''';

String _apiConsumerCode() => '''
abstract class ApiConsumer {
 Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
 Future<dynamic> post(String path, {Map<String, dynamic>? body});
 Future<dynamic> put(String path, {Map<String, dynamic>? body});
 Future<dynamic> delete(String path);
}
''';

String _dioConsumerCode() => '''
import 'package:dio/dio.dart';
import '../constants/endpoint_constants.dart';
import 'api_consumer.dart';
import 'interceptors.dart';
import 'status_code.dart';


class DioConsumer implements ApiConsumer {
 final Dio client;


 DioConsumer({required this.client}) {
   client.options
     ..baseUrl = EndpointConstants.baseUrl
     ..responseType = ResponseType.json
     ..connectTimeout = const Duration(seconds: 15)
     ..receiveTimeout = const Duration(seconds: 15);


   client.interceptors.add(AppInterceptors());
 }


 @override
 Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
   try {
     final response = await client.get(path, queryParameters: queryParameters);
     return response.data;
   } on DioException catch (error) {
     _handleDioError(error);
   }
 }


 // Implement other methods (post, put, delete)


 void _handleDioError(DioException error) {
   // Handle different error types
 }


 @override
 Future delete(String path) {
   // TODO: implement delete
   throw UnimplementedError();
 }


 @override
 Future post(String path, {Map<String, dynamic>? body}) {
   // TODO: implement post
   throw UnimplementedError();
 }


 @override
 Future put(String path, {Map<String, dynamic>? body}) {
   // TODO: implement put
   throw UnimplementedError();
 }
}


''';

String _interceptorsCode() => '''
import 'package:dio/dio.dart';


class AppInterceptors extends Interceptor {
 @override
 void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
   // Add headers or tokens if needed
   super.onRequest(options, handler);
 }


 @override
 void onResponse(Response response, ResponseInterceptorHandler handler) {
   super.onResponse(response, handler);
 }


 @override
 void onError(DioException err, ErrorInterceptorHandler handler) {
   super.onError(err, handler);
 }
}
''';

String _statusCodeCode() => '''
class StatusCode {
 static const int ok = 200;
 static const int badRequest = 400;
 static const int unauthorized = 401;
 static const int forbidden = 403;
 static const int notFound = 404;
 static const int conflict = 409;
 static const int internalServerError = 500;
}
''';

String _exceptionsCode() => '''
abstract class AppException implements Exception {
 final String message;
 final int statusCode;


 const AppException(this.message, this.statusCode);
}


class ServerException extends AppException {
 const ServerException([super.message = 'Server Error', super.statusCode = 500]);
}


class CacheException extends AppException {
 const CacheException([super.message = 'Cache Error', super.statusCode = 500]);
}
// Add more exceptions as needed


''';

String _failuresCode() => '''
abstract class Failure {
 final String message;
 final int statusCode;


 Failure(this.message, this.statusCode);
}


class ServerFailure extends Failure {
 ServerFailure([super.message = 'Server Error', super.statusCode = 500]);
}


class CacheFailure extends Failure {
 CacheFailure([super.message = 'Cache Error', super.statusCode = 500]);
}
// Add more failures as needed


''';

String _appUtilsCode() => '''
class AppUtils {
 static bool isEmailValid(String email) {
   return RegExp(r'^[^@]+@[^@]+.[^@]+').hasMatch(email);
 }


 static bool hasLowerCase(String password) {
   return RegExp(r'^(?=.*[a-z])').hasMatch(password);
 }


 static bool hasUpperCase(String password) {
   return RegExp(r'^(?=.*[A-Z])').hasMatch(password);
 }


 static bool hasNumber(String password) {
   return RegExp(r'^(?=.*?[0-9])').hasMatch(password);
 }


 static bool hasMinLength(String password) {
   return RegExp(r'^(?=.{8,})').hasMatch(password);
 }
}


''';

String _appPrefsCode() => '''
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class AppPreferences {
 static final AppPreferences _instance = AppPreferences._internal();
 late SharedPreferences _prefs;


 factory AppPreferences() {
   return _instance;
 }


 AppPreferences._internal();


 /// ✅ **تهيئة SharedPreferences**
 Future<void> init() async {
   _prefs = await SharedPreferences.getInstance();
 }


 /// ✅ **حفظ البيانات بأي نوع (`String, int, double, bool, List<String>`)**
 Future<void> setData(String key, dynamic value) async {
   if (value is String) {
     await _prefs.setString(key, value);
   } else if (value is int) {
     await _prefs.setInt(key, value);
   } else if (value is double) {
     await _prefs.setDouble(key, value);
   } else if (value is bool) {
     await _prefs.setBool(key, value);
   } else if (value is List<String>) {
     await _prefs.setStringList(key, value);
   } else {
     throw Exception("Unsupported data type");
   }
 }


 /// ✅ **استرجاع البيانات (`String, int, double, bool, List<String>`)**
 dynamic getData(String key) {
   return _prefs.get(key);
 }


 /// ✅ **حذف بيانات مفتاح معين**
 Future<void> removeData(String key) async {
   await _prefs.remove(key);
 }


 /// ✅ **حفظ كائن Model (`T`)**
 Future<void> saveModel<T>(String key, T model, Map<String, dynamic> Function(T) toJson) async {
   final String jsonString = jsonEncode(toJson(model));
   await _prefs.setString(key, jsonString);
 }


 /// ✅ **استرجاع كائن Model (`T`)**
 T? getModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
   final String? jsonString = _prefs.getString(key);
   if (jsonString != null) {
     final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
     return fromJson(jsonMap);
   }
   return null;
 }


 /// ✅ **حفظ قائمة من النماذج (`List<T>`)**
 Future<void> saveModels<T>(String key, List<T> models, Map<String, dynamic> Function(T) toJson) async {
   final List<String> jsonList = models.map((model) => jsonEncode(toJson(model))).toList();
   await _prefs.setStringList(key, jsonList);
 }


 /// ✅ **استرجاع قائمة من النماذج (`List<T>`)**
 List<T> getModels<T>(String key, T Function(Map<String, dynamic>) fromJson) {
   final List<String>? jsonList = _prefs.getStringList(key);
   if (jsonList != null) {
     return jsonList.map((json) => fromJson(jsonDecode(json))).toList();
   }
   return [];
 }


 Future<void> clearExceptCredentials() async {
   // حفظ بيانات تسجيل الدخول قبل الحذف
   String? savedEmail = _prefs.getString('saved_email');
   String? savedPassword = _prefs.getString('saved_password');
   bool? rememberMe = _prefs.getBool('remember_me');


   // مسح كل البيانات
   await _prefs.clear();


   // استرجاع بيانات تسجيل الدخول
   if (savedEmail != null) await _prefs.setString('saved_email', savedEmail);
   if (savedPassword != null) await _prefs.setString('saved_password', savedPassword);
   if (rememberMe != null) await _prefs.setBool('remember_me', rememberMe);
 }
 bool isLoggedInUser() {
   return _prefs.containsKey("userModel");
 }


}
''';

String _localeServiceCode() => '''
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';


import '../utils/app_shared_preferences.dart';


class LocaleService {


 LocaleService();


 static const _defaultLocale = Locale('en');


 /// Load saved locale or fallback
 Locale getCurrentLocale() {


   final localeCode = AppPreferences().getData(AppConstants.localeKey);
   if (localeCode != null) {
     return Locale(localeCode);
   }
   return _defaultLocale;
 }


 /// Save locale and update easy_localization
 Future<void> setLocale(BuildContext context, String languageCode) async {
   await AppPreferences().setData(AppConstants.localeKey, languageCode);
   await context.setLocale(Locale(languageCode));
 }
}


''';

String _themeServiceCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';




class AppTheme {




 // 🌓 الوضع الفاتح
 static ThemeData get lightTheme {
   return ThemeData(
     brightness: Brightness.light,
     primaryColor:  AppColor.primaryColor,
     scaffoldBackgroundColor:  AppColor.backgroundColor,
     fontFamily: 'Nunito',
     colorScheme: ColorScheme(
       primary: AppColor.primaryColor, // اللون الثاني
       secondary: Colors.green, // اللون الثانوي الثاني
       surface: Colors.white, // خلفية التطبيقات
       error: Colors.red, // اللون الخاص بالأخطاء
       onPrimary: Colors.white, // اللون عند استخدام الـ primary
       onSecondary: Colors.black, // اللون عند استخدام الـ secondary
       onSurface: AppColor.grayColor, // اللون عند استخدام الـ background
       onError: Colors.white, // اللون عند استخدام الـ error
       brightness: Brightness.light, // مستوى السطوع (فاتح أو غامق)
     ),
     appBarTheme: const AppBarTheme(
       elevation: 0,
       centerTitle: true,
       backgroundColor: Colors.white,
       iconTheme: IconThemeData(color: Colors.black),
       titleTextStyle: TextStyle(
         color: Colors.black,
         fontSize: 18,
         fontWeight: FontWeight.bold,
       ),
     ),
     textTheme: TextTheme(
       displayLarge: textStyle(24.sp, FontWeight.bold, AppColor.black),
       displayMedium: textStyle(20.sp, FontWeight.bold, AppColor.black),
       displaySmall: textStyle(18.sp, FontWeight.w600, AppColor.black),
       headlineMedium: textStyle(16.sp, FontWeight.bold, AppColor.black),
       bodyLarge: textStyle(14.sp, FontWeight.normal, AppColor.black),
       bodyMedium: textStyle(12.sp, FontWeight.normal, AppColor.black),
     ),


     cardColor: AppColor.primaryColor,
     buttonTheme: ButtonThemeData(
       buttonColor: AppColor.backgroundColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(8),
       ),
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         foregroundColor: Colors.white,
         backgroundColor: AppColor.primaryColor,
         textStyle: textStyle(16, FontWeight.bold, Colors.white),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8),
         ),
       ),
     ),
     iconTheme: const IconThemeData(color: Colors.black),
   );
 }


 // 🌙 الوضع الداكن
 static ThemeData get darkTheme {
   return ThemeData(
     brightness: Brightness.dark,
     primaryColor: AppColor.primaryColor,
     scaffoldBackgroundColor: AppColor.backgroundColor,
     fontFamily: 'Nunito',
     appBarTheme: const AppBarTheme(
       elevation: 0,
       centerTitle: true,
       backgroundColor: Colors.black,
       iconTheme: IconThemeData(color: Colors.white),
       titleTextStyle: TextStyle(
         color: Colors.white,
         fontSize: 18,
         fontWeight: FontWeight.bold,
       ),
     ),
     textTheme: TextTheme(
       displayLarge: textStyle(24.sp, FontWeight.bold, Colors.white),
       displayMedium: textStyle(20.sp, FontWeight.bold, Colors.white),
       displaySmall: textStyle(18.sp, FontWeight.w600, Colors.white),
       headlineMedium: textStyle(16.sp, FontWeight.bold, Colors.white),
       bodyLarge: textStyle(14.sp, FontWeight.normal, Colors.white),
       bodyMedium: textStyle(12.sp, FontWeight.normal, Colors.grey),
     ),
     cardColor: Colors.grey[900],
     buttonTheme: ButtonThemeData(
       buttonColor: AppColor.primaryColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(8),
       ),
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
       style: ElevatedButton.styleFrom(
         foregroundColor: Colors.white,
         backgroundColor: AppColor.primaryColor,
         textStyle: textStyle(16, FontWeight.bold, Colors.white),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8),
         ),
       ),
     ),
     iconTheme: const IconThemeData(color: Colors.white),
   );
 }


 // 🎨 دالة لإنشاء TextStyle بسهولة
 static TextStyle textStyle(double size, FontWeight weight, Color color) {
   return TextStyle(
     fontSize: size,
     fontWeight: weight,
     color: color,
   );
 }
}


''';

String _navigationExtCode() => '''
//! NAVIGATION EXTENSION
import 'package:flutter/material.dart';


extension NavigationExtensions on BuildContext {
 // Push a new page onto the stack
 void push(Widget page) =>
     Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));


 // Push a named route onto the stack
 Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
     Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);


 // Replace the current route with a new one
 Future<T?> pushReplacement<T, TO>(Widget page) => Navigator.of(
   this,
 ).pushReplacement(MaterialPageRoute(builder: (_) => page));


 // Replace the current route with a named route
 Future<T?> pushReplacementNamed<T, TO>(
   String routeName, {
   Object? arguments,
 }) => Navigator.of(
   this,
 ).pushReplacementNamed<T, TO>(routeName, arguments: arguments);


 // Pop the current route off the stack
 void back() => Navigator.of(this).pop();


 // Pop until the predicate returns true
 void popUntil(RoutePredicate predicate) =>
     Navigator.of(this).popUntil(predicate);


 // Pop the current route and push a new route
 Future<T?> popAndPushNamed<T, TO>(String routeName, {Object? arguments}) =>
     Navigator.of(
       this,
     ).popAndPushNamed<T, TO>(routeName, arguments: arguments);


 // Push a new route and remove all previous routes
 Future<T?> pushAndRemoveUntil<T>(Widget page, RoutePredicate predicate) =>
     Navigator.of(
       this,
     ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), predicate);


 // Push a named route and remove all previous routes
 Future<T?> pushNamedAndRemoveUntil<T>(
   String routeName, {
   Object? arguments,
 }) => Navigator.of(this).pushNamedAndRemoveUntil<T>(
   routeName,
    (route) => false,
   arguments: arguments,
 );


 // Try to pop the route; returns true if successful, otherwise false
 Future<bool> maybePop() => Navigator.of(this).maybePop();


 // Replace the current route with a new route using a custom route
 Future<T?> replaceWithCustomRoute<T, TO>(Route<T> route) =>
     Navigator.of(this).pushReplacement(route);


 // Push a custom route onto the stack
 Future<T?> pushCustomRoute<T>(Route<T> route) =>
     Navigator.of(this).push(route);
}


''';

String _sizedBoxExtCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


SizedBox verticalSpace(double height) => SizedBox(height: height.h);
SizedBox horizontalSpace(double width) => SizedBox(width: width.w);
''';

String _themeExtCode() => '''
//! THEME EXTENSION
import 'package:flutter/material.dart';


extension ThemeExtensions on BuildContext {
 //! Recommended to use: ThemeData get theme => Theme.of(this);
 ThemeData get theme => Theme.of(this);


 // Existing extensions
 IconThemeData get iconTheme => Theme.of(this).iconTheme;


 TextTheme get textTheme => Theme.of(this).textTheme;


 AppBarTheme get appBarTheme => Theme.of(this).appBarTheme;


 InputDecorationTheme get inputDecorationTheme =>
     Theme.of(this).inputDecorationTheme;


 CheckboxThemeData get checkboxTheme => Theme.of(this).checkboxTheme;


 ElevatedButtonThemeData get elevatedButtonTheme =>
     Theme.of(this).elevatedButtonTheme;


 OutlinedButtonThemeData get outlinedButtonTheme =>
     Theme.of(this).outlinedButtonTheme;


 TextButtonThemeData get textButtonTheme => Theme.of(this).textButtonTheme;


 CardThemeData get cardTheme => Theme.of(this).cardTheme;


 DialogThemeData get dialogTheme => Theme.of(this).dialogTheme;


 FloatingActionButtonThemeData get floatingActionButtonTheme =>
     Theme.of(this).floatingActionButtonTheme;


 BottomNavigationBarThemeData get bottomNavigationBarTheme =>
     Theme.of(this).bottomNavigationBarTheme;


 NavigationRailThemeData get navigationRailTheme =>
     Theme.of(this).navigationRailTheme;


 SliderThemeData get sliderTheme => Theme.of(this).sliderTheme;


 TabBarThemeData get tabBarTheme => Theme.of(this).tabBarTheme;


 TooltipThemeData get tooltipTheme => Theme.of(this).tooltipTheme;


 PopupMenuThemeData get popupMenuTheme => Theme.of(this).popupMenuTheme;


 MaterialBannerThemeData get bannerTheme => Theme.of(this).bannerTheme;


 DividerThemeData get dividerTheme => Theme.of(this).dividerTheme;


 BottomSheetThemeData get bottomSheetTheme => Theme.of(this).bottomSheetTheme;


 TimePickerThemeData get timePickerTheme => Theme.of(this).timePickerTheme;


 ThemeData get darkTheme => ThemeData.dark();


 ThemeData get lightTheme => ThemeData.light();


 // Additional extensions
 ButtonThemeData get buttonTheme => Theme.of(this).buttonTheme;


 ChipThemeData get chipTheme => Theme.of(this).chipTheme;


 DataTableThemeData get dataTableTheme => Theme.of(this).dataTableTheme;


 DrawerThemeData get drawerTheme => Theme.of(this).drawerTheme;


 ExpansionTileThemeData get expansionTileTheme =>
     Theme.of(this).expansionTileTheme;


 ListTileThemeData get listTileTheme => Theme.of(this).listTileTheme;


 MenuThemeData get menuTheme => Theme.of(this).menuTheme;


 NavigationBarThemeData get navigationBarTheme =>
     Theme.of(this).navigationBarTheme;


 PageTransitionsTheme get pageTransitionsTheme =>
     Theme.of(this).pageTransitionsTheme;


 ProgressIndicatorThemeData get progressIndicatorTheme =>
     Theme.of(this).progressIndicatorTheme;


 RadioThemeData get radioTheme => Theme.of(this).radioTheme;


 ScrollbarThemeData get scrollbarTheme => Theme.of(this).scrollbarTheme;


 SwitchThemeData get switchTheme => Theme.of(this).switchTheme;


 TextSelectionThemeData get textSelectionTheme =>
     Theme.of(this).textSelectionTheme;


 BottomAppBarTheme get bottomAppBarTheme => Theme.of(this).bottomAppBarTheme;


 MaterialTapTargetSize get materialTapTargetSize =>
     Theme.of(this).materialTapTargetSize;


 Typography get typography => Theme.of(this).typography;


 VisualDensity get visualDensity => Theme.of(this).visualDensity;


 IconButtonThemeData get iconButtonTheme => Theme.of(this).iconButtonTheme;


ColorScheme get colorScheme => Theme.of(this).colorScheme;
}


''';

String _splashScreenCode(projectName) => '''
import 'package:flutter/material.dart';
import '../../../../core/routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import '../../../../core/extensions/navigation_extensions.dart';


class SplashScreen extends StatefulWidget {
 const SplashScreen({super.key});


 @override
 State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
 @override
 void initState() {
   super.initState();
   Timer(const Duration(seconds: 2), () {
     context.pushNamed(Routes.onBoardingScreen);
   });
 }


 @override
 Widget build(BuildContext context) {
   return const Scaffold(
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           FlutterLogo(size: 100),
           SizedBox(height: 20),
           Text("Splash Screen", style: TextStyle(fontSize: 20)),
         ],
       ),
     ),
   );
 }
}


''';
String _localeCubitCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_shared_preferences.dart';
import '../../constants/app_constants.dart';


part 'locale_state.dart';


class LocaleCubit extends Cubit<LocaleState> {
 LocaleCubit() : super(LocaleState(_getInitialLocale()));


 static Locale _getInitialLocale() {
   final savedLocale = AppPreferences().getData(AppConstants.localeKey);
   return savedLocale == 'ar' ? const Locale('ar') : const Locale('en');
 }


 Future<void> changeLocale(Locale newLocale) async {
   await AppPreferences().setData(AppConstants.localeKey, newLocale.languageCode);
   emit(LocaleState(newLocale));
 }
}


''';

String _themeCubitCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/app_shared_preferences.dart';
import '../../constants/app_constants.dart';


part 'theme_state.dart';


class ThemeCubit extends Cubit<ThemeState> {
 ThemeCubit() : super(ThemeState(_getInitialTheme()));


 static ThemeMode _getInitialTheme() {
   final savedTheme = AppPreferences().getData(AppConstants.themeKey);
   if (savedTheme == 'dark') return ThemeMode.dark;
   if (savedTheme == 'light') return ThemeMode.light;
   return ThemeMode.system;
 }


 Future<void> changeTheme(ThemeMode newTheme) async {
   await AppPreferences().setData(AppConstants.themeKey, newTheme.name);
   emit(ThemeState(newTheme));
 }
}


''';

String _appRouterCode(String projectName) => '''
import 'package:flutter/material.dart';
import '../routing/routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';


class AppRouter {
 Route? generateRoute(RouteSettings settings) {
   switch (settings.name) {
     case Routes.splashScreen:
       return _createRoute(const SplashScreen());
     case Routes.onBoardingScreen:
       return _createRoute(const OnboardingScreen());


     default:
       return null;
   }
 }


 PageRouteBuilder _createRoute(Widget page) {
   return PageRouteBuilder(
     transitionDuration: const Duration(milliseconds: 400),
     pageBuilder: (context, animation, secondaryAnimation) => page,
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       return FadeTransition(
         opacity: animation,
         child: child,
       );
     },
   );
 }
}
''';

String _routesCode() => '''
class Routes {
 static const String splashScreen = '/splashScreen';
 static const String onBoardingScreen = '/onBoardingScreen';
 static const String loginScreen = '/loginScreen';
 static const String signupScreen = '/signupScreen';
 static const String homeScreen = '/homeScreen';
}
''';

String _appThemeCode() => '''
import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTheme {
 static ThemeData get lightTheme => ThemeData(
   primaryColor: AppColor.primaryColor,
   scaffoldBackgroundColor: AppColor.backgroundColor,
   fontFamily: 'Nunito',
   brightness: Brightness.light,
   appBarTheme: const AppBarTheme(
     backgroundColor: AppColor.white,
     elevation: 0,
     centerTitle: true,
     iconTheme: IconThemeData(color: AppColor.black),
     titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.black),
   ),
 );


 static ThemeData get darkTheme => ThemeData(
   primaryColor: AppColor.primaryColor,
   scaffoldBackgroundColor: Colors.black,
   fontFamily: 'Nunito',
   brightness: Brightness.dark,
   appBarTheme: const AppBarTheme(
     backgroundColor: Colors.black,
     elevation: 0,
     centerTitle: true,
     iconTheme: IconThemeData(color: AppColor.white),
     titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.white),
   ),
 );
}
''';

String _appColorsCode() => '''
import 'package:flutter/material.dart';


class AppColor {
 static const Color primaryColor = Color(0xff1F21A8);
 static const Color backgroundColor = Color(0xffF8FBFC);
 static const Color grayColor = Colors.grey;
 static const Color white = Colors.white;
 static const Color black = Colors.black;
}
''';

String _mainCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/constants/app_constants.dart';
import 'core/cubit/locale/locale_cubit.dart';
import 'core/cubit/theme/theme_cubit.dart';
import 'core/utils/app_shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'app.dart';
import 'app_bloc_observer.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await EasyLocalization.ensureInitialized();
 Bloc.observer = AppBlocObserver();
 await AppPreferences().init();


 runApp(EasyLocalization(
   supportedLocales: AppConstants.supportedLocales,
   path: 'assets/lang',
   fallbackLocale: const Locale('en'),
   child: MultiBlocProvider(
     providers: [
       BlocProvider(create: (_) => LocaleCubit()),
       BlocProvider(create: (_) => ThemeCubit()),
     ],
     child: MyApp(appRouter: AppRouter()),
   ),
 ));
}
''';

String _appCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/cubit/theme/theme_cubit.dart';


class MyApp extends StatelessWidget {
 final AppRouter appRouter;
 const MyApp({super.key, required this.appRouter});


 @override
 Widget build(BuildContext context) {
   return BlocBuilder<ThemeCubit, ThemeState>(
     builder: (context, themeState) => MaterialApp(
       debugShowCheckedModeBanner: false,
       title: AppConstants.appName,
       theme: AppTheme.lightTheme,
       darkTheme: AppTheme.darkTheme,
       themeMode: themeState.themeMode,
       locale: context.locale,
       supportedLocales: context.supportedLocales,
       localizationsDelegates: context.localizationDelegates,
       onGenerateRoute: appRouter.generateRoute,
       initialRoute: '/',
     ),
   );
 }
}
''';

String _blocObserverCode() => '''
import 'package:flutter_bloc/flutter_bloc.dart';


class AppBlocObserver extends BlocObserver {
 @override
 void onCreate(BlocBase bloc) {
   super.onCreate(bloc);
   print('🔍 Bloc Created: \${bloc.runtimeType}');
 }


 @override
 void onChange(BlocBase bloc, Change change) {
   super.onChange(bloc, change);
   print('🔁 Bloc Change in \${bloc.runtimeType}: \$change');
 }


 @override
 void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
   print('❌ Bloc Error in \${bloc.runtimeType}: \$error');
   super.onError(bloc, error, stackTrace);
 }


 @override
 void onClose(BlocBase bloc) {
   print('🛑 Bloc Closed: \${bloc.runtimeType}');
   super.onClose(bloc);
 }
}
''';
String _onboardingScreenCode(String projectName) => '''
import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class OnboardingScreen extends StatefulWidget {
 const OnboardingScreen({super.key});


 @override
 State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
 final controller = PageController();
 bool isLastPage = false;


 @override
 void dispose() {
   controller.dispose();
   super.dispose();
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: 24.w),
       child: Column(
         children: [
           SizedBox(height: 60.h),
           Expanded(
             child: PageView(
               controller: controller,
               onPageChanged: (index) => setState(() => isLastPage = index == 2),
               children: const [
                 OnboardPage(title: 'Welcome', description: 'This is onboarding 1'),
                 OnboardPage(title: 'Explore', description: 'This is onboarding 2'),
                 OnboardPage(title: 'Start', description: 'This is onboarding 3'),
               ],
             ),
           ),
   
           SizedBox(height: 20.h),
           SizedBox(
             width: double.infinity,
             child: ElevatedButton(
               onPressed: () {
                 if (isLastPage) {
                 } else {
                   controller.nextPage(
                     duration: const Duration(milliseconds: 500),
                     curve: Curves.easeInOut,
                   );
                 }
               },
               child: Text(isLastPage ? 'Get Started' : 'Next'),
             ),
           ),
           SizedBox(height: 40.h),
         ],
       ),
     ),
   );
 }
}


class OnboardPage extends StatelessWidget {
 final String title;
 final String description;
 const OnboardPage({super.key, required this.title, required this.description});


 @override
 Widget build(BuildContext context) {
   return Padding(
     padding: EdgeInsets.symmetric(horizontal: 24.w),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(Icons.flutter_dash, size: 120.r),
         SizedBox(height: 20.h),
         Text(
           title,
           style: GoogleFonts.nunito(
             fontSize: 26.sp,
             fontWeight: FontWeight.bold,
           ),
         ),
         SizedBox(height: 12.h),
         Text(
           description,
           textAlign: TextAlign.center,
           style: GoogleFonts.nunito(fontSize: 16.sp),
         ),
       ],
     ),
   );
 }
}


''';

String _loginScreenCode(String projectName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:$projectName/core/routing/routes.dart';


class LoginScreen extends StatelessWidget {
 const LoginScreen({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: const Text('Login')),
     body: Padding(
       padding: EdgeInsets.all(20.w),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           TextField(decoration: const InputDecoration(labelText: 'Email')),
           SizedBox(height: 16.h),
           TextField(obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
           SizedBox(height: 24.h),
           ElevatedButton(
             onPressed: () => Navigator.pushReplacementNamed(context, Routes.homeScreen),
             child: const Text('Login'),
           ),
           SizedBox(height: 8.h),
           TextButton(
             onPressed: () => Navigator.pushNamed(context, Routes.signupScreen),
             child: const Text("Don\'t have an account? Sign up"),
           ),
         ],
       ),
     ),
   );
 }
}
''';

String _signupScreenCode() => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SignUpScreen extends StatelessWidget {
 const SignUpScreen({super.key});


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: const Text('Sign Up')),
     body: Padding(
       padding: EdgeInsets.all(20.w),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           const TextField(decoration: InputDecoration(labelText: 'Name')),
           SizedBox(height: 16.h),
           const TextField(decoration: InputDecoration(labelText: 'Email')),
           SizedBox(height: 16.h),
           const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
           SizedBox(height: 24.h),
           ElevatedButton(
             onPressed: () {},
             child: const Text('Create Account'),
           ),
         ],
       ),
     ),
   );
 }
}
''';
String _themeStateCode() => '''
part of 'theme_cubit.dart';


class ThemeState {
 final ThemeMode themeMode;


 const ThemeState(this.themeMode);


 @override
 bool operator ==(Object other) {
   if (identical(this, other)) return true;
   return other is ThemeState && other.themeMode == themeMode;
 }


 @override
 int get hashCode => themeMode.hashCode;
}
''';

String _localeStateCode() => '''
part of 'locale_cubit.dart';


class LocaleState {
 final Locale locale;


 const LocaleState(this.locale);


 @override
 bool operator ==(Object other) {
   if (identical(this, other)) return true;
   return other is LocaleState && other.locale == locale;
 }


 @override
 int get hashCode => locale.hashCode;
}
''';
