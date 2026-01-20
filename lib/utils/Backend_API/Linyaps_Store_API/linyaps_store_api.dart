// 与玲珑应用商店后端API对接的中间件

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:linyaps_seal/utils/Global_Variables/repo_arch.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class LinyapsStoreApiService {
  // 初始化指定API总线链接地址
  static String serverHost_Store = "https://storeapi.linyaps.org.cn";
  static String serverHost_Repo = "https://mirror-repo-linglong.deepin.com";
  static String serverHost_RepoExtra = "https://cdn-linglong.odata.cc/icon/main";

  // 拿到GetX的全局应用信息
  static GlobalAppState_Arch gAppState_Arch = Get.find<GlobalAppState_Arch>();

  // 进行系统架构更新
  static String os_arch = gAppState_Arch.os_arch.value;
  static String repo_arch = gAppState_Arch.repo_arch.value;

  // 单开获取本地应用图标的函数, 同步进行减少应用加载时间
  static Future <List<LinyapsPackageInfo>> updateAppIcon (List<LinyapsPackageInfo> installed_apps) async {
    // 指定具体响应API地址
    String serverUrl = '$serverHost_Store/visit/getAppDetails';
    
    // 初始化待提交应用
    List <Map<String, String>> upload_installed_apps = [];
    for (LinyapsPackageInfo i in installed_apps) {
      upload_installed_apps.add({
        'appId': i.id,
        'channel': 'main',
        'module': 'binary',
        'arch': repo_arch
      });
    }
    // 创建Dio请求对象
    Dio dio = Dio ();    
    // 发送并获取返回信息
    Response response = await dio.post(
      serverUrl,
      data: jsonEncode(upload_installed_apps),
    );  
    dio.close();

    List <dynamic> app_info_get = response.data['data'];
    List <LinyapsPackageInfo> returnItems = [];

    // 拿到请求后遍历返回的列表逐个加入后, 进行标准玲珑应用类返回
    for (dynamic i in app_info_get) {
      // 先检查返回的应用信息是否在已安装应用里
      LinyapsPackageInfo app_local_info = installed_apps.firstWhere(
        (app) => app.id == i['appId'],
        orElse: () => LinyapsPackageInfo(
          kind: 'app',
          id: '', 
          name: '', 
          version: '', 
          description: '', 
          runtime: '',
          arch: ''
        )
      );
      // 依次加入元素
      returnItems.add(
        LinyapsPackageInfo(
          kind: i['kind'] ?? app_local_info.kind,
          id: i['appId'], 
          name: app_local_info.name, 
          version: app_local_info.version, 
          description: i['description'] ?? app_local_info.description, 
          runtime: app_local_info.runtime,
          arch: i['arch'] ?? app_local_info.arch,
          Icon: i['icon'],
        )
      );
    }

    return returnItems;
  }
}
