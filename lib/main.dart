import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sqlite_database_practice/controller/note_controller.dart';
import 'package:sqlite_database_practice/screens/splash_screen.dart';
import 'package:sqlite_database_practice/service/theme_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(NoteController());
  Get.put(ThemeService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeService = Get.find<ThemeService>();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeService.theme,
          home:  SplashScreen()
      ),
    );
  }
}

