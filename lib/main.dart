// 主程序总线

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';
import 'package:get/get.dart';
import 'package:linyaps_seal/pages/middle_page.dart';
import 'package:linyaps_seal/utils/Global_Variables/cur_app_config_info.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/Global_Variables/installed_apps.dart';
import 'package:linyaps_seal/utils/Global_Variables/repo_arch.dart';
import 'package:yaru/settings.dart';

void main() async {
  
  // 启动前先检查:
  // 1. 当前应用实例是否为单实例 (也就是只打开了一个app没打开第二个)
  // 2. 当前系统是否为Linux
  // 如果不是, 则退出程序
  bool isSingleInstance = await FlutterSingleInstance().isFirstInstance();
  if (!isSingleInstance || !Platform.isLinux) exit(0);

  // 初始化所有GetX管理的全局类实例
  // 创建GetX管理共享的ApplicationState实例
  Get.put(GlobalAppState_Arch());
  Get.put(GlobalAppState_InstalledApps());
  Get.put(GlobalAppState_Config());
  Get.put(GlobalAppState_AppConfig());

  // 初始化各实例
  GlobalAppState_Arch appGlobalInfo_arch = Get.find<GlobalAppState_Arch>();
  GlobalAppState_InstalledApps appGlobalInfo_installedApps = Get.find<GlobalAppState_InstalledApps>();
  GlobalAppState_Config appGlobalInfo_globalConf = Get.find<GlobalAppState_Config>();

  // 启动时更新系统架构信息
  await appGlobalInfo_arch.getUnameArch();
  await appGlobalInfo_arch.getLinyapsStoreApiArch();

  // 再更新已安装应用列表
  await appGlobalInfo_installedApps.updateInstalledAppsList();

  // 再更新全局的应用配置
  await appGlobalInfo_globalConf.updateGlobalConfig();

  runApp(
    GetMaterialApp(
      home: const MyApp(),
    ),
  );
  
}

class MyApp extends StatefulWidget {
  
  // 在这里声明当前应用版本号
  static String cur_version = '0.0.5';

  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YaruTheme(
        data: YaruThemeData(
          themeMode: ThemeMode.system,
        ),
        child: MainMiddlePage(),
      ),
    );
  }
}
