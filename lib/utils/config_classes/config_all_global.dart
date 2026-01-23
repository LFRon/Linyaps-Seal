// 全部设置的总类

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:get/get.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/config_extension_info.dart';

class ConfigAll_Global {

  RxList <Config_Extension>? ext_defs;  // 总扩展信息
  Map <String, String>? env;  // 环境变量信息

  ConfigAll_Global ({
    this.ext_defs,
  });

  Map <String, dynamic> toMap () {
    Map <String, dynamic> returnItems = {};   // 初始化用于返回的Map

    // 若用户设置了全局扩展, 则先处理全局扩展配置
    if (ext_defs != null) {
      returnItems["ext_defs"] = {};
      for (var i in ext_defs ?? []) {
        returnItems["ext_defs"].addAll(i.toMap());
      }
    }

    // 若用户设置了全局变量, 则急需处理全局变量设置
    if (env != null) {
      returnItems["env"] = env;
    }
    
    // 返回应该返回的Map
    return returnItems;
  }

}
