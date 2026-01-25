// 对于底层API的二次抽象, 直接面向前端UI需要实现的玲珑应用信息获取

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, null_argument_to_non_null_type, curly_braces_in_flow_control_structures

import 'package:linyaps_seal/utils/Backend_API/Linyaps_CLI_API/linyaps_cli_helper.dart';
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
      // 跳过玲珑Base和Runtime
      if (
        i['info']['kind'] == 'base' || 
        i['info']['kind'] == 'runtime' ||
        i['info']['kind'] == 'extension'
      ) {
        continue;
      }
      installedItems.add(
        LinyapsPackageInfo(
          id: i['info']['id'],
          base: i['info']['base'], 
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

  /*----------------------------扩展部分--------------------------------*/

  // 获取玲珑全局扩展信息的方法
  // 由于玲珑扩展覆盖机制是先加载Base信息再加载应用信息
  // 因此返回格式为Map<String, List<Config_Extension>>
  // 其中key为1: Base名称, value为该Base下的所有扩展
  // 2: 是应用包名, value为该应用下的所有扩展
  static Future <Map <String, List<Extension>>?> get_config_extension_global () async {
    // 先获取全局配置
    Map <String, dynamic>? app_config_get = await LinyapsCliHelper.get_linyaps_global_config();
    // 初始化待返回内容
    Map <String, List<Extension>> returnItems = {};
    if (app_config_get != null) {
      app_config_get["ext_defs"].forEach((key, value) {
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
        returnItems[base] = extensions;
      });
      return returnItems;
    } else {
      return null;
    }
  }

  // 获取应用单独配置信息的方法
  // 只返回玲珑当前应用的列表
  static Future <List<Extension>?> get_config_extension_app (LinyapsPackageInfo appInfo) async {
    // 获取出应用id
    String appId = appInfo.id;
    // 先获取全局配置
    Map <String, dynamic>? app_config_get = await LinyapsCliHelper.get_linyaps_app_config(appId);
    // 初始化待返回内容
    List<Extension>? returnItems;

    // 如果当前应用有对应的配置
    // (也就是app_config_get与app_config_get["ext_defs"]均非空)
    if (app_config_get != null) {
      if (app_config_get["ext_defs"] != null) {
        app_config_get["ext_defs"].forEach((key, value) async {
          if (key != appInfo.id) return;  // 如果不是指应用id, 那么扩展不会生效, 直接跳过所有
          else {
            returnItems = [];
            for (var i in value) {
              // 将扩展列表加入到待返回列表中
              returnItems!.add(
                Extension(
                  name: i['name'], 
                  version: i['version'], 
                  directory: i['directory'],
                ),
              );
            }
          }
        });
      }
    }
    return returnItems;
  }

  /*--------------------------------------------------------------------*/

  /*--------------------------环境变量部分------------------------------*/

  // 获取玲珑全局环境变量设置方法
  static Future <Map<String, String>?> get_env_config_global () async {
    // 先获取全局配置
    Map <String, dynamic>? global_config_get = await LinyapsCliHelper.get_linyaps_global_config();
    Map <String, String>? returnItems = {};   // 初始化若非空将会返回的变量
    if (global_config_get != null) {  // 如果全局变量不为空则返回env子项
      if (global_config_get['env'] != null) {
        global_config_get['env'].forEach((key, value) {
          returnItems[key] = value;
        });
      }
      return returnItems;
    } else {
      return null;
    }
  }

  // 获取玲珑单个应用环境变量设置方法
  static Future <Map<String, String>?> get_env_config_app (LinyapsPackageInfo appInfo) async {
    // 先获取全局配置
    Map <String, dynamic>? app_config_get = await LinyapsCliHelper.get_linyaps_app_config(
      appInfo.id,
    );

    Map <String, String>? returnItems = {};   // 初始化若非空将会返回的变量
    if (app_config_get != null) {  // 如果全局变量不为空则返回env子项
      if (app_config_get['env'] != null) {
        app_config_get['env'].forEach((key, value) {
          returnItems[key] = value;
        });
      }
      return returnItems;
    } else {
      return null;
    }

  }

}
