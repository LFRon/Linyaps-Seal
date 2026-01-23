// 用于跟玲珑后端进行

// 忽略VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:env_variables/env_variables.dart';
import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Global_Variables/cur_app_config_info.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/config_classes/config_all_global.dart';
import 'package:linyaps_seal/utils/config_classes/config_cur_app.dart';

class LinyapsCliHelper {

  // 用于返回玲珑所有安装信息的方法
  static Future <Map<String, dynamic>?> get_linyaps_all_local_info () async {
    // 指定玲珑的states.json路径
    String linyaps_states_path = '/var/lib/linglong/states.json';
    File file = File(linyaps_states_path);
    if (await file.exists()) {
      // 以字符串的形式读取states.json
      String get_states_content = await file.readAsString();
      // 将字符串对象转成列表字典
      Map<String, dynamic> jsonData = jsonDecode(get_states_content) as Map<String, dynamic>;
      return jsonData;
    }
    else return Future.value(null);
  }

  // 用于返回玲珑用户全局配置信息的方法
  static Future <Map<String, dynamic>?> get_linyaps_global_config () async {
    // 先获取当前用户名
    String USER = EnvVariables.fromEnvironment('USER');
    // 指定玲珑的states.json路径
    String linyaps_global_states_path = '/home/$USER/.config/linglong/config.json';
    File file = File(linyaps_global_states_path);
    if (await file.exists()) {
      // 以字符串的形式读取states.json
      String get_states_content = await file.readAsString();
      // 将字符串对象转成列表字典
      Map<String, dynamic> jsonData = jsonDecode(get_states_content) as Map<String, dynamic>;
      return jsonData;
    } else {
      return null;
    }
  }

  // 用于返回玲珑用户对应应用配置信息的方法
  static Future <Map<String, dynamic>?> get_linyaps_app_config (String appId) async {
    // 先获取当前用户名
    String USER = EnvVariables.fromEnvironment('USER');
    // 指定玲珑的states.json路径
    String linyaps_global_states_path = '/home/$USER/.config/linglong/apps/$appId/config.json';
    File file = File(linyaps_global_states_path);
    if (await file.exists()) {
      // 以字符串的形式读取states.json
      String get_states_content = await file.readAsString();
      // 将字符串对象转成列表字典
      Map<String, dynamic> jsonData = jsonDecode(get_states_content) as Map<String, dynamic>;
      return jsonData;
    } else {
      return null;
    }
  }

  // 用于将用户更改的内容写入JSON
  static Future <void> write_linyaps_global_config () async {
    // 获取全局变量状态
    GlobalAppState_Config curAppConfState = Get.find<GlobalAppState_Config>();
    ConfigAll_Global global_config_get = curAppConfState.global_config.value;
    // 转换字典为JSON格式的字符串, 以两个空格隔开
    String jsonString = const JsonEncoder.withIndent('  ').convert(global_config_get.toMap());
    // 获取当前用户名
    String USER = EnvVariables.fromEnvironment('USER');
    // 指定玲珑的states.json路径
    String linyaps_global_states_path = '/home/$USER/.config/linglong/config.json';
    File file = File(linyaps_global_states_path);
    // 确保目录存在
    await file.parent.create(recursive: true);
    // 将JSON文件写入路径
    await file.writeAsString(jsonString, mode: FileMode.write);
    return;
  }

  // 用于将用户更改的内容作为JSON写入至每个应用中
  static Future <void> write_linyaps_app_config () async {
    // 获取全局变量状态
    GlobalAppState_AppConfig curAppConfState = Get.find<GlobalAppState_AppConfig>();
    ConfigAll_App app_config_get = curAppConfState.curAppConf.value;
    // 获取当前应用ID
    String appId = app_config_get.curAppInfo.id;
    // 转换字典为JSON格式的字符串, 以两个空格隔开
    String jsonString = const JsonEncoder.withIndent('  ').convert(app_config_get.toMap());
    // 获取当前用户名
    String USER = EnvVariables.fromEnvironment('USER');
    // 指定玲珑的states.json路径
    String linyaps_global_states_path = '/home/$USER/.config/linglong/apps/$appId/config.json';
    File file = File(linyaps_global_states_path);
    // 确保目录存在
    await file.parent.create(recursive: true);
    // 将JSON文件写入路径
    await file.writeAsString(jsonString, mode: FileMode.write);
    return;
  }

}
