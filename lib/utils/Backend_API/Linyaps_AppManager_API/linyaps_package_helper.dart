// 对于底层API的二次抽象, 直接面向前端UI需要实现的玲珑应用信息获取

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, null_argument_to_non_null_type

import 'package:linyaps_seal/utils/Backend_API/Linyaps_CLI_API/linyaps_cli_helper.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/config_extension_info.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class LinyapsPackageHelper {

  // 获取玲珑本地应用的信息
  static Future <List<LinyapsPackageInfo>> get_installed_apps () async {
    // 先异步获取玲珑本地信息
    dynamic linyapsLocalInfo = await LinyapsCliHelper.get_linyaps_all_local_info();
    
    // 遇到没有安装玲珑或者没安装应用等情况,直接返回空列表
    if (linyapsLocalInfo == null) return [];
    
    // 初始化待返回已安装应用的临时对象
    List <LinyapsPackageInfo> installedItems = [];

    // 开始遍历本地的应用安装信息
    for (dynamic i in linyapsLocalInfo['layers']) {
      installedItems.add(
        LinyapsPackageInfo(
          id: i['info']['id'], 
          kind: i['info']['kind'],
          name: i['info']['name'], 
          version: i['info']['version'], 
          runtime: i['info']['runtime'], 
          description: i['info']['description'], 
          arch: i['info']['arch'][0],
          Icon: '',     // 此时未获取图标链接, 故为空
        ),
      );
    }
    return installedItems;
  }

  // 获取玲珑全局扩展信息的方法
  static Future <List<Config_Extension>> get_global_extension_config () async {
    // 先获取全局配置
    Map <String, dynamic>? global_config_get = await LinyapsCliHelper.get_linyaps_global_config();
    // 初始化待返回内容
    List <Config_Extension> returnItems = [];
    if (global_config_get != null) {
      global_config_get["ext_defs"].forEach((key, value) {
        // 在循环内初始化待赋值的extensions列表
        String base = key;
        List <Extension> extensions = [];
        for (var i in value) {
          extensions.add(
            Extension(
              name: i['name'], 
              version: i['version'], 
              directory: i['directory']
            ),
          );
        }
        returnItems.add(
          Config_Extension(
            base: base, 
            extensions_list: extensions,
          ),
        );
      });
      return returnItems;
    } else {
      return [];
    }
  }

}
