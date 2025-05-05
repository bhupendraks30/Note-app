import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService{
  var isDarkTheme = false.obs;

  Future<ThemeService> init() async{
      return this;
  }

  void toggleTheme(){
    isDarkTheme.value = !isDarkTheme.value;
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get theme => isDarkTheme.value ? ThemeMode.dark : ThemeMode.light;
}