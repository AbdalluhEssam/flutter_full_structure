const vscode = require('vscode');
const fs = require('fs');
const path = require('path');

function activate(context) {
	
  const disposable = vscode.commands.registerCommand('flutter-full-structure.generate', function () {
    const terminal = vscode.window.createTerminal('Flutter Generator');
    const workspaceFolders = vscode.workspace.workspaceFolders;

    if (workspaceFolders) {
      const projectPath = workspaceFolders[0].uri.fsPath;
      const toolDir = path.join(projectPath, 'tool');
      const dartScriptPath = path.join(toolDir, 'generate_project.dart');

      if (!fs.existsSync(toolDir)) {
        fs.mkdirSync(toolDir, { recursive: true });
      }

      const dartScript = `// tool/generate_project.dart
import 'dart:io';
import 'package:path/path.dart';

void main(List<String> arguments) {
  final projectDir = Directory.current;
  final projectName = basename(projectDir.path);
  final libDir = Directory(join(projectDir.path, 'lib'));
  final assetsDir = Directory(join(projectDir.path, 'assets'));

  _generateCoreStructure(libDir);
  _generateFeatureStructure(libDir);
  _generateMainFiles(libDir, projectName);
  _generateAssetsFolder(assetsDir);
  _generatePubspecYaml(projectDir, projectName);
  _generateGitignore(projectDir);
  _generateReadme(projectDir, projectName);
  _generateAnalysisOptions(projectDir);

  print('\\n✅ Project "\$projectName" structure generated successfully!');
}

void _generateCoreStructure(Directory libDir) {
  final coreDirs = [
    'animations', 'constants', 'errors', 'network', 'services', 'utils', 'widgets',
    'theme', 'routing', 'di', 'cubit/locale', 'cubit/theme'
  ];
  for (final dir in coreDirs) {
    _createDir(Directory(join(libDir.path, 'core', dir)));
  }
  _createFile(join(libDir.path, 'core', 'di', 'service_locator.dart'), '/* Dependency Injection Setup */');
  _createFile(join(libDir.path, 'core', 'routing', 'app_router.dart'), '/* Routing Setup */');
  _createFile(join(libDir.path, 'core', 'utils', 'app_shared_preferences.dart'), '/* Shared Preferences Utility */');
  _createFile(join(libDir.path, 'app_bloc_opserver.dart'), '/* Bloc Observer Setup */');
  _createFile(join(libDir.path, 'core', 'constants', 'app_constants.dart'), '''
  import 'package:flutter/material.dart';
  class AppConstants {
    static const String appName = 'Quick Wash';
    static const supportedLocales = [Locale('en'), Locale('ar')];
  }''');
  _createDir(Directory(join(libDir.path, 'generated')));
  _createFile(join(libDir.path, 'generated', 'assets.dart'), '/* generated assets references */');
}
  
void _generateFeatureStructure(Directory libDir) {
  final featuresDir = Directory(join(libDir.path, 'features'));
  _createDir(featuresDir);
  final modules = ['auth', 'splash', 'onboarding'];
  final subDirs = [
    'data/datasources', 'data/models', 'data/repositories',
    'domain/entities', 'domain/repositories', 'domain/usecases',
    'presentation/bloc', 'presentation/screens', 'presentation/widgets',
  ];
  for (final module in modules) {
    final moduleDir = Directory(join(featuresDir.path, module));
    for (final dir in subDirs) {
      _createDir(Directory(join(moduleDir.path, dir)));
    }
    _createFile(join(moduleDir.path, 'presentation/screens/${module}_screen.dart'), '''
  import 'package:flutter/material.dart';
  class ${_capitalize(module)}Screen extends StatelessWidget {
    const ${_capitalize(module)}Screen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('${_capitalize(module)}')),
        body: const Center(child: Text('${_capitalize(module)} content here')),
      );
    }
  }''');
  }
}
  
void _generateMainFiles(Directory libDir, String projectName) {
  _createFile(join(libDir.path, 'main.dart'), '''
  import 'package:easy_localization/easy_localization.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:$projectName/app.dart';
  import 'app_bloc_opserver.dart';
  import 'core/constants/app_constants.dart';
  import 'core/cubit/Locale/locale_cubit.dart';
  import 'core/cubit/theme/theme_cubit.dart';
  import 'core/routing/app_router.dart';
  import 'core/utils/app_shared_preferences.dart';
  
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    Bloc.observer = AppBlocObserver();
    await AppPreferences().init();
    runApp(
      EasyLocalization(
        supportedLocales: AppConstants.supportedLocales,
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocaleCubit()),
            BlocProvider(create: (_) => ThemeCubit()),
          ],
          child: QuickWashApp(appRouter: AppRouter()),
        ),
      ),
    );
  }''');
  
  _createFile(join(libDir.path, 'app.dart'), '''
  import 'package:easy_localization/easy_localization.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'core/constants/app_constants.dart';
  import 'core/cubit/theme/theme_cubit.dart';
  import 'core/routing/app_router.dart';
  import 'core/routing/routes.dart';
  import 'core/theme/app_theme.dart';
  
  class QuickWashApp extends StatelessWidget {
    final AppRouter appRouter;
    const QuickWashApp({super.key, required this.appRouter});
    @override
    Widget build(BuildContext context) {
      return ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) => MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            initialRoute: Routes.splashScreen,
            onGenerateRoute: appRouter.generateRoute,
            home: child,
          ),
        ),
      );
    }
  }''');
}
  
// أضف جميع الدوال الأخرى هنا بنفس الطريقة كما في الكود الأصلي...

void _createDir(Directory dir) {
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    print('📁 Created directory: ${dir.path}');
  }
}

void _createFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
    print('📄 Created file: $path');
  }
}

String _capitalize(String input) => input[0].toUpperCase() + input.substring(1);
`;

      fs.writeFileSync(dartScriptPath, dartScript);
      terminal.show();
      terminal.sendText('dart run tool/generate_project.dart');
    } else {
      vscode.window.showErrorMessage('No Flutter workspace folder found!');
    }
  });

  context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};

function _capitalize(input) {
	if (!input) return input; // التحقق من أن المدخل ليس فارغاً أو غير معرف
	return input.charAt(0).toUpperCase() + input.slice(1); // استخدام charAt بدلاً من [0]
  }