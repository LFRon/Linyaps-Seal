// 应用全局变量管理

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_AppManager_API/linyaps_package_helper.dart';
import 'package:linyaps_seal/utils/config_classes/config_all.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/config_extension_info.dart';

class GlobalAppState_Config extends GetxController {

  // 已存在的全局玲珑配置, 并提供转换为JSON的Map<String, dynamic>形式
  Rx <Config_All> global_config = Config_All().obs;

  // 用于更新已存在的玲珑全局配置
  Future <void> updateGlobalConfig () async {

    // 先更新扩展部分
    List <Config_Extension> global_extension_config = await LinyapsPackageHelper.get_global_extension_config();
    if (global_extension_config.isNotEmpty) {
      global_config.value.ext_defs = global_extension_config.obs;
    }

    // ToDo: 去做新加别的扩展功能

    update();
    return;
  }

}
