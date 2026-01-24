// 全局应用管理子页面

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_CLI_API/linyaps_cli_helper.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_createItem.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/global_app_info_subpage/comp_env.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/global_app_info_subpage/comp_extensions.dart';
import 'package:yaru/yaru.dart';

class AppInfoPage_GlobalConf extends StatefulWidget {

  const AppInfoPage_GlobalConf({super.key});

  @override
  State<AppInfoPage_GlobalConf> createState() => _AppInfoPage_GlobalConfState();
}

class _AppInfoPage_GlobalConfState extends State<AppInfoPage_GlobalConf> {

  // 声明全局应用变量配置信息
  late GlobalAppState_Config gAppConf;

  // 用于判断扩展信息是否加载完全的状态管理, 默认为假
  bool is_info_loaded = false;

  /*-----------------------------扩展配置部分---------------------------------*/

  // 初始化指向全局扩展列表的指针
  Map<String, List<Extension>>? get ext_defs => gAppConf.global_config.value
                                                .ext_defs; 
  set ext_defs (Map<String, List<Extension>>? value) {
    gAppConf.global_config.value
    .ext_defs = value;
  }

  // 声明新建Base扩展的按钮
  late MyButton_CreateItem createBaseExtensionButton;

  // 声明存储子页面中显示扩展名字与版本号的文本控制器列表
  // 声明存储所有扩展内Base信息的函数
  List <TextEditingController> textctl_ext_base_list = [];
  // 声明是否为空的检查器
  // 结构为: 一个Map对应一个Base, Map内存储对应Base内所有扩展的名字与版本号
  Map <String, List<TextEditingController>> textctl_ext_name_list = {};
  Map <String, List<TextEditingController>> textctl_ext_version_list = {};

  // 扩展: 初始化每个扩展名字与版本的文本控制器列表
  Future <void> ConfigExt_initTextCtlList () async {

    // 进行扩展信息空检查, 若为空直接跳过
    if (ext_defs != null) {
      if (ext_defs!.isNotEmpty) {
        ext_defs!.forEach((key, value) async {
          // 先初始化Base的文本控制器
          textctl_ext_base_list.add(TextEditingController(text: key));
          // 再初始化各文本控制器
          textctl_ext_name_list[key] = [];   
          textctl_ext_version_list[key] = [];
          for (var i in value) {
            textctl_ext_name_list[key]!.add(
              TextEditingController(text: i.name),
            );
            textctl_ext_version_list[key]!.add(
              TextEditingController(text: i.version),
            );
          }
        });
      }
    }
    return;
  }

  // 扩展: 当用户更改base文字时立刻触发的函数
  Future <void> ConfigExt_updateBaseInfo (String new_base_name, int index) async {
    
    // 存储原先oldBase的名字
    String oldBaseName = ext_defs!.keys.elementAt(index);

    // 更新base信息, 并移除旧base信息
    ext_defs![new_base_name] = ext_defs![oldBaseName]!;
    ext_defs!.remove(oldBaseName);

    // 分别更新extension子项内名字与版本文本控制器
    if (textctl_ext_name_list.containsKey(oldBaseName)) {
      var value = textctl_ext_name_list[oldBaseName]!;
      textctl_ext_name_list.remove(oldBaseName);
      textctl_ext_name_list[new_base_name] = value;
    }
    if (textctl_ext_version_list.containsKey(oldBaseName)) {
      var value = textctl_ext_version_list[oldBaseName]!;
      textctl_ext_version_list.remove(oldBaseName);
      textctl_ext_version_list[new_base_name] = value;
    }

    gAppConf.update();  // 触发响应式更新
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  // 扩展: 当用户在每个Base里更改其中扩展名字时触发的函数
  Future <void> ConfigExt_updateExtBaseName (String base, String newName, int ext_index) async {
    // 当用户能更改时一定是有对应文本框, 故这两者一定为真
    ext_defs![base]![ext_index].name = newName;
    gAppConf.update();  // 触发响应式更新
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  // 扩展: 当用户按下Base旁边的'+'号时触发的函数
  Future <void> ConfigExt_createNewBase () async {
    // 如果为ext_refs为空值则初始化
    ext_defs ??= {};
    if (mounted) setState(() {
      // 添加新的对应文本控制器
      textctl_ext_base_list.add(
        TextEditingController(
          text: '',
        ),
      );
      // 添加新的Base信息
      ext_defs![''] = [];
      gAppConf.update();
    });
    return;
  }

  // 扩展: 当用户按下Extension旁边的'+'号时触发的函数
  Future <void> ConfigExt_createNewExt (String base) async {
    // 如果为ext_refs, 文本控制器为空值则初始化
    ext_defs![base] ??= [];
    textctl_ext_name_list[base] ??= [];
    textctl_ext_version_list[base] ??= [];

    if (mounted) setState(() {
      ext_defs![base]!.add(
        Extension(
          name: '', 
          version: '',
          directory: '',
        ),
      );
      textctl_ext_name_list[base]!.add(
        TextEditingController(text: ''),
      );
      textctl_ext_version_list[base]!.add(
        TextEditingController(text: ''),
      );
    });
    gAppConf.update();  // 触发响应式更新
    return;
  }

  // 扩展: 用户更改Base下扩展名字/版本号时及时写入的两实现
  Future <void> ConfigExt_updateBaseExtName (String base, String newName, int ext_index) async {
    // 当用户能更改时一定是有对应文本框, 故这两者一定为真
    ext_defs![base]![ext_index].name = newName;
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    gAppConf.update();  // 触发响应式更新
    return;
  }
  Future <void> ConfigExt_updateBaseExtVersion (String base, String newVersion, int ext_index) async {
    // 当用户能更改时一定是有对应文本框, 故这两者一定为真
    ext_defs![base]![ext_index].version = newVersion;
    gAppConf.update();  // 触发响应式更新
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  // 扩展: 删除用户对应Base
  Future <void> ConfigExt_deleteBase (int index) async {
    if (mounted) setState(() {
      // 获取对应键
      String base = ext_defs!.keys.elementAt(index);
      ext_defs!.remove(base);
      // 删除对应Base的文本控制器
      textctl_ext_base_list.removeAt(index);
      // 删除与对应Base相关的所有扩展控制器
      textctl_ext_name_list.remove(base);
      textctl_ext_version_list.remove(base);
    });
    gAppConf.update();  // 触发响应式更新
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  // 扩展: 删除用户指定Base中的指定扩展
  Future <void> ConfigExt_deleteExt (String base, int ext_index) async {
    if (mounted) setState(() {
      // 删除对应Base
      ext_defs![base]!.removeAt(ext_index);
      // 删除对应Base的文本控制器
      textctl_ext_name_list[base]!.removeAt(ext_index);
      textctl_ext_version_list[base]!.removeAt(ext_index);
    });
    gAppConf.update();  // 触发响应式更新
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  /*--------------------------------------------------------*/


  /*---------------------环境变量部分-----------------------*/

  // 存储当前全局变量
  Map <String, String>? get global_env => gAppConf.global_config.value.env;

  // 声明对应修改环境变量需要的文本控制器
  List <TextEditingController> textctl_env_name = [];
  List <TextEditingController> textctl_env_value = [];

  // 获取当前全局变量信息
  Future <void> ConfigEnv_initial () async {
    // 先使用临时变量获取当前全局变量信息
    Map <String, String> global_env_get = gAppConf.global_config.value.env ?? {};

    // 更新对应修改环境变量的文本控制器
    if (mounted) setState(() {
      // 初始化对应修改环境变量的文本控制器
      if (global_env_get.isNotEmpty) {
        global_env_get.forEach((key, value) {
          textctl_env_name.add(
            TextEditingController(
              text: key,
            )
          );
          textctl_env_value.add(
            TextEditingController(
              text: value,
            )
          );
        });
      }
    });
  }

  // 环境变量: 当用户更改环境变量键时自动触发保存的函数
  // 当该键无重复(合法)时返回true, 非法时返回false
  Future <bool> ConfigEnv_updateEnvKey (int index, String key) async {
    var oldKey = global_env!.keys.elementAt(index);
    var value = global_env!.values.elementAt(index);

    // 检查新键是否已经存在, 若存在则不进行任何操作
    if (
      gAppConf.global_config.value
      .env!.containsKey(key)
    ) return false;

    // 移除旧的字典信息
    gAppConf.global_config.value
    .env!.remove(oldKey);
    // 增加新的字典信息
    gAppConf.global_config.value
    .env!.addAll({
      key: value,
    });
    await LinyapsCliHelper.write_linyaps_global_config();
    if (mounted) setState(() {
      gAppConf.update();
    });
    return true;
  }

  // 环境变量: 当用户按下新建按钮新建环境变量时触发的函数
  Future <void> ConfigEnv_createNewEnv () async {
    // 若此时环境变量为null则初始化
    if (gAppConf.global_config.value.env == null) {
      gAppConf.global_config.value.env = {};
    }
    // 先检查''空键是否存在
    if (gAppConf.global_config.value.env!.containsKey('')) {
      return;
    } else {
      // 添加新的环境变量
      global_env!.addAll({
        '': '',
      });
      if (mounted) setState(() {
        // 添加新的环境变量文本控制器
        textctl_env_name.add(
          TextEditingController(
            text: '',
          ),
        );
        textctl_env_value.add(
          TextEditingController(
            text: '',
          ),
        );
        gAppConf.update();  // 触发GetX响应式更新
      });
    }
  }

  // 环境变量: 当用户更改环境变量值时自动触发保存的函数
  Future <void> ConfigEnv_updateEnvValue (int index, String newValue) async {
    var key = global_env!.keys.elementAt(index);
    // 增加新的字典信息
    gAppConf.global_config.value
    .env![key] = newValue;
    await LinyapsCliHelper.write_linyaps_global_config();
    if (mounted) setState(() {
      gAppConf.update();
    });
    return;
  }

  // 环境变量: 当用户按下子控件中的删除按钮时删除对应环境变量的函数
  Future <void> ConfigEnv_deleteEnv (int index) async {
    var key = global_env!.keys.elementAt(index);
    // 删除对应环境变量
    global_env!.remove(key);
    // 删除对应环境变量的文本控制器
    textctl_env_name.removeAt(index);
    textctl_env_value.removeAt(index);
    await LinyapsCliHelper.write_linyaps_global_config();
    if (mounted) setState(() {
      gAppConf.update();
    });
    return;
  }


  

  /*--------------------------------------------------------*/



  /*---------------------权限管理部分-----------------------*/



  /*--------------------------------------------------------*/

  // 设置页面未加载的函数
  Future <void> setInfoNotLoaded () async {
    if (mounted) setState(() {
      is_info_loaded = false;
    });
  }

  // 设置页面完全加载的函数
  Future <void> setInfoLoaded () async {
    if (mounted) setState(() {
      is_info_loaded = true;
    });
  }

  @override
  void initState () {
    super.initState();
    // 初始化全局应用对象
    gAppConf = Get.find<GlobalAppState_Config>();
    gAppConf.updateGlobalConfig();
    Future.microtask(() async {
      // 初始化UI文本控制器
      await ConfigExt_initTextCtlList();
      // 初始化环境变量
      await ConfigEnv_initial();
      // 设置页面加载完成
      await setInfoLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {

    // 扩展: 初始化新建Base按钮
    createBaseExtensionButton = MyButton_CreateItem(
      canPress: ValueNotifier<bool>(true), 
      onPressed: () async {
        await ConfigExt_createNewBase();
      }
    );

    return GetBuilder<GlobalAppState_Config>(
      builder:(gAppBuild) {

        /*----------------获取扩展部分----------------*/
        // 获取构建时扩展信息
        // 涉及到列表渲染时需强制非空防止UI时出现问题
        Map <String, List<Extension>> ext_defs_build = gAppBuild.global_config.value
                                                       .ext_defs ?? {};

        /*----------------环境变量部分----------------*/
        // 获取构建时环境变量信息

        return Padding(
          padding: const EdgeInsets.only(top: 28.0, left: 35, right: 35),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          width: 90,
                          height: 90,
                          'assets/images/linyaps-generic-app.png',
                        ),
                        const SizedBox(width: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '全部应用程序',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              '适用于所有玲珑应用的更改',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    is_info_loaded
                    ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Global Env',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '全局环境变量',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: MyButton_CreateItem(
                                // 这里是否按下需要检查:
                                // 1. 是否有env, 没有就没问题
                                // 2. env是否已经有用户待创建的''键
                                // 如果有则禁止继续新建防止污染字典
                                canPress: gAppBuild.global_config.value
                                          .env == null
                                          ? ValueNotifier<bool>(true) 
                                          : gAppBuild.global_config.value
                                            .env!.containsKey('')
                                            ? ValueNotifier<bool>(false)
                                            : ValueNotifier<bool>(true),
                                onPressed: () async {
                                  await ConfigEnv_createNewEnv();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        global_env != null
                        ? global_env!.isNotEmpty
                          ? YaruBorderContainer(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),  // 禁止子控件滚动
                                itemCount: global_env == null
                                           ? 0
                                           : global_env!.length,
                                itemBuilder:(context, index) {
                                  return GlobalAppUI_Env(
                                    index: index, 
                                    name: global_env!.keys.elementAt(index),
                                    value: global_env!.values.elementAt(index),
                                    textctl_name: textctl_env_name[index],
                                    textctl_value: textctl_env_value[index],
                                    updateKey:(index_in, newKey) async {
                                      return await ConfigEnv_updateEnvKey(index_in, newKey);
                                    }, 
                                    updateValue:(index_in, newValue) async {
                                      await ConfigEnv_updateEnvValue(index_in, newValue);
                                    }, 
                                    deleteKey: (index_in) async {
                                      await ConfigEnv_deleteEnv(index_in);
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                          :SizedBox.shrink()
                        : SizedBox.shrink(),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ext_defs',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '全局加载的扩展',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: createBaseExtensionButton,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        YaruBorderContainer(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),  // 禁止子控件滚动
                            itemCount: ext_defs_build.length,
                            itemBuilder:(context, index) {
                              // 获取当前Base信息
                              String cur_base = ext_defs_build.keys.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // 套子Row用于跟新建按钮隔开
                                        Text(
                                          "基础环境:",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        SizedBox(
                                          height: 30,
                                          width: 220,
                                          child: TextField(
                                            controller: textctl_ext_base_list[index],
                                            onChanged: (value) async {
                                              await ConfigExt_updateBaseInfo(value, index);
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                                              border: OutlineInputBorder(),   // 可选：添加边框样式
                                            ),
                                            style: TextStyle(
                                              height: 1.3
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        // 将删除按钮与增加按钮并排
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: MyButton_DeleteItem(
                                            onPressed: () async {
                                              await ConfigExt_deleteBase(index);
                                            }
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: MyButton_CreateItem(
                                            canPress: ValueNotifier<bool>(
                                              !ext_defs_build.containsKey('')
                                            ),
                                            onPressed: () async {
                                              await ConfigExt_createNewExt(cur_base);
                                            }
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    // 检查对应Base扩展列表是否为Nul或空
                                    // 如果为Null/空则显示暂无扩展标识
                                    ext_defs_build[cur_base] != null
                                    ? ext_defs_build[cur_base]!.isNotEmpty
                                      ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(), // 禁用ListView的滚动
                                        itemCount: ext_defs_build[cur_base]!.length,
                                        itemBuilder: (context, index) {
                                          return GlobalAppUI_Extensions(
                                            cur_base: cur_base,
                                            cur_index: index,
                                            cur_ext_info: ext_defs_build[cur_base]![index],
                                            textctl_name: textctl_ext_name_list[cur_base]![index],
                                            textctl_version: textctl_ext_version_list[cur_base]![index],
                                            updateExtensionName: (base, ext_index, newExtName) async {
                                              await ConfigExt_updateBaseExtName(
                                                base, 
                                                newExtName, 
                                                ext_index,
                                              );
                                            },
                                            updateExtensionVersion: (base, ext_index, newExtVersion) async {
                                              await ConfigExt_updateBaseExtVersion(
                                                base, 
                                                newExtVersion, 
                                                ext_index,
                                              );
                                            },
                                            deleteExtensionInfo: (base, ext_index) async {
                                              await ConfigExt_deleteExt(
                                                base, 
                                                ext_index,
                                              );
                                            },
                                          );
                                        }
                                      )
                                      : Center(
                                        child: Text(
                                          '暂无扩展',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : Center(
                                      child: Text(
                                        '暂无扩展',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ),
                      ],
                    )
                    : SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
