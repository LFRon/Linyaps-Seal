// 应用全局变量管理

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_AppManager_API/linyaps_package_helper.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_Store_API/linyaps_store_api.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class GlobalAppState_InstalledApps extends GetxController {

  // 私有已安装应用列表
  RxList installedAppsList = [].obs;

  /*--         玲珑应用信息获取部分        --*/

  // 用于更新当前安装应用列表
  Future <void> updateInstalledAppsList () async {
    installedAppsList.value = await LinyapsPackageHelper.get_installed_apps();
    update();
    return;
  }

  // 用于更新已安装应用的图标
  Future <void> updateAppsIcon () async {
    installedAppsList.value = await LinyapsStoreApiService.updateAppIcon(installedAppsList.cast<LinyapsPackageInfo>());
    update();
    return;
  }

}
