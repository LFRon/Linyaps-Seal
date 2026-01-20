// 扩展信息封装

// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';

class Config_Extension {

  String base;     // 需要加载对应扩展的base
  List <Extension> extensions_list;     // 对应base需要加载的扩展列表

  Config_Extension ({
    required this.base,
    required this.extensions_list,
  });

  // 实现转换为Map标准字典函数
  Map <String, dynamic> toMap () {
    Map <String, dynamic> returnItems = {};
    // 初始化对应base的列表
    returnItems[base] = [];
    for (var i in extensions_list) {
      returnItems[base].add({
        'name': i.name,
        'version': i.version,
        'directory': "",
      });
    }
    return returnItems;
  }

}
