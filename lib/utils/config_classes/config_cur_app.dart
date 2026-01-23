// 单独应用设置的总类

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:linyaps_seal/utils/config_classes/ext_defs/config_extension_info.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class ConfigAll_App {

  // 需要应用自身信息
  LinyapsPackageInfo curAppInfo;

  // 总扩展信息
  // 其中包含了其对应Base的扩展信息
  // 和它本身的扩展信息
  Map <String, Config_Extension>? ext_defs;  

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
      // 再检查对应应用扩展信息是否为null
      // 不为null直接加入字典
      if (ext_defs![curAppInfo.id] != null) {
        returnItems["ext_defs"].addAll(
          ext_defs![curAppInfo.id]!.toMap(),
        );
        // 更改对应的键从AppId改为BaseId
        var value = returnItems["ext_defs"][curAppInfo.id];
        returnItems["ext_defs"].remove(curAppInfo.id);
        returnItems["ext_defs"][curAppInfo.base] = value;
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
