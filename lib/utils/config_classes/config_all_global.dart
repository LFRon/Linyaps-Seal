// 全部设置的总类

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';

class ConfigAll_Global {

  Map <String, List<Extension>>? ext_defs;  // 总扩展信息
  Map <String, String>? env;  // 环境变量信息

  ConfigAll_Global ({
    this.ext_defs,
  });

  Map <String, dynamic> toMap () {
    Map <String, dynamic> returnItems = {};   // 初始化用于返回的Map

    // 若用户设置了全局扩展, 则先处理全局扩展配置
    if (ext_defs != null) {
      returnItems["ext_defs"] = {};
      for (String key in ext_defs!.keys) {
        returnItems["ext_defs"]![key] = [];
        for (Extension ext in ext_defs![key]!) {
          returnItems["ext_defs"]![key]!.add({
            'name': ext.name,
            'version': ext.version,
            'directory': '',
          });
        }
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
