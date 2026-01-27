// 应用全局变量管理

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_AppManager_API/linyaps_package_helper.dart';
import 'package:linyaps_seal/utils/config_classes/config_all_global.dart';

class GlobalAppState_Config extends GetxController {

  // 已存在的全局玲珑配置, 并提供转换为JSON的Map<String, dynamic>的响应式
  Rx <ConfigAll_Global> global_config = ConfigAll_Global().obs;

  // 用于更新已存在的玲珑全局配置
  Future <void> updateGlobalConfig () async {
    // 先更新扩展部分
    var global_extension_config = await LinyapsPackageHelper.get_config_extension_global();
    if (global_extension_config != null) {
      global_config.value.ext_defs = global_extension_config.obs;
    }

    // 再更新环境变量部分
    Map <String, String>? env_get = await LinyapsPackageHelper.get_env_config_global();
    if (env_get != null) {
      global_config.value.env = env_get;
    }

    // TODO: 去做新加别的扩展功能

    update();
    return;
  }

}
