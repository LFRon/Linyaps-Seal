// 单独应用设置的总类

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class ConfigAll_App {

  // 需要应用自身信息
  LinyapsPackageInfo curAppInfo;

  // 总扩展信息
  // 其中包含了其对应Base的扩展信息
  // 和它本身的扩展信息
  List <Extension>? ext_defs;  

  Map <String, String>? env;  // 环境变量信息

  ConfigAll_App ({
    required this.curAppInfo,
    this.ext_defs,
  });

  Map <String, dynamic> toMap () {
    Map <String, dynamic> returnItems = {};   // 初始化用于返回的Map

    // 先添加扩展信息
    // 若用户设置了全局扩展, 则先处理全局扩展配置
    if (ext_defs != null) {
      returnItems["ext_defs"] = {};
      if (ext_defs != null) {
        // 往待返回字典对应信息中按照JSON转制规范制作字典列表
        returnItems["ext_defs"][curAppInfo.base] = [];
        for (Extension ext in ext_defs!) {
          returnItems["ext_defs"][curAppInfo.base].add({
            'name': ext.name,
            'version': ext.version,
            'directory': '',
          });
        }
      }
    }

    // 再增加环境变量选项
    if (env != null) {
      returnItems["env"] = env;
    }

    // TODO: 增加应用其他配置选项
    
    // 返回应该返回的Map
    return returnItems;
  }

}
