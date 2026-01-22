// 扩展信息封装

// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';

class Config_Extension {

  String appId;     // 需要加载对应扩展的appId
  List <Extension> extensions_list;     // 对应appId需要加载的扩展列表

  Config_Extension ({
    required this.appId,
    required this.extensions_list,
  });

  // 实现转换为Map标准字典函数
  Map <String, dynamic> toMap () {
    Map <String, dynamic> returnItems = {};
    // 初始化对应appId的列表
    returnItems[appId] = [];
    for (var i in extensions_list) {
      returnItems[appId].add({
        'name': i.name,
        'version': i.version,
        'directory': "",
      });
    }
    return returnItems;
  }

}
