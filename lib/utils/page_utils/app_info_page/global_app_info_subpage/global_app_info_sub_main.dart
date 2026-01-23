// 全局应用管理子页面

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_CLI_API/linyaps_cli_helper.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/config_classes/config_all_global.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/config_extension_info.dart';
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

  // 存储全局配置信息
  late ConfigAll_Global global_config_info;

  /*-------------------扩展配置部分-----------------------*/

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
    for (var i in gAppConf.global_config.value.ext_defs ?? <Config_Extension>[]) {
      textctl_ext_name_list[i.appId] = [];   // 初始化各文本控制器
      textctl_ext_base_list.add(
        TextEditingController(text: i.appId),
      );
      textctl_ext_version_list[i.appId] = [];
      for (var j in i.extensions_list) {
        textctl_ext_name_list[i.appId]!.add(
          TextEditingController(text: j.name),
        );
        textctl_ext_version_list[i.appId]!.add(
          TextEditingController(text: j.version),
        );
      }
    }
    return;
  }

  // 扩展: 当用户更改base文字时立刻触发的函数
  Future <void> ConfigExt_updateBaseInfo (String new_base_name, int index) async {
    
    // 存储原先oldBase的名字
    String oldBaseName = gAppConf.global_config.value
    .ext_defs![index]
    .appId;

    // 更新base信息
    gAppConf.global_config.value
    .ext_defs![index]
    .appId = new_base_name;

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

  // 扩展: 当用户按下Base旁边的'+'号时触发的函数
  Future <void> ConfigExt_createNewBase () async {
    // 如果为ext_refs为空值则初始化
    if (gAppConf.global_config.value.ext_defs == null) {
      gAppConf.global_config.value
      .ext_defs = <Config_Extension>[].obs;
    } 
    if (mounted) setState(() {
      // 添加新的对应文本控制器
      textctl_ext_base_list.add(
        TextEditingController(
          text: '',
        ),
      );
      // 添加新的Base信息
      gAppConf.global_config.value
      .ext_defs!
      .add(
        Config_Extension(
          appId: '', 
          extensions_list: [],
        )
      );
    });
    return;
  }

  // 扩展: 当用户按下Extension旁边的'+'号时触发的函数
  // 这里之所以只需要传参index, 是因为实际存储时是用列表
  // 在存储时, 每个Base对应一个列表, 所以只需要知道Base的索引即可
  Future <void> ConfigExt_createNewExt (int index) async {
    // 如果为ext_refs为空值则初始化
    if (gAppConf.global_config.value.ext_defs == null) {
      gAppConf.global_config.value
      .ext_defs = <Config_Extension>[].obs;
    } 

    if (mounted) setState(() {
      // 如果对应控制器未初始化则进行初始化
      if (
        textctl_ext_name_list[
          gAppConf.global_config.value
          .ext_defs![index]
          .appId
        ] == null
      ) {
        textctl_ext_name_list[
          gAppConf.global_config.value
          .ext_defs![index]
          .appId
        ] = [];
      }
      if (
        textctl_ext_version_list[
          gAppConf.global_config.value
          .ext_defs![index]
          .appId
        ] == null
      ) {
        textctl_ext_version_list[
          gAppConf.global_config.value
          .ext_defs![index]
          .appId
        ] = [];
      }
      // 添加新的对应文本控制器
      textctl_ext_name_list[
        gAppConf.global_config.value
        .ext_defs![index]
        .appId
      ]!.add(
        TextEditingController(
          text: '',
        ),
      );
      textctl_ext_version_list[
        gAppConf.global_config.value
        .ext_defs![index]
        .appId
      ]!.add(
        TextEditingController(
          text: '',
        ),
      );
      // 添加新的Extension信息
      gAppConf.global_config.value
      .ext_defs![index]
      .extensions_list
      .add(
        Extension(
          name: '', 
          version: '',
          directory: '',
        )
      );
    });
    gAppConf.update();  // 触发响应式更新
    return;
  }

  // 扩展: 用户更改Base下扩展名字/版本号时及时写入
  // 这里使用index是因为会在下方构建树里直接传出对应元素列表的索引
  // 故index是扩展名字/版本号列表的索引
  Future <void> ConfigExt_writeExtionInfo () async {
    await LinyapsCliHelper.write_linyaps_global_config();   // 写入新配置
    return;
  }

  // 扩展: 删除用户对应Base
  Future <void> ConfigExt_deleteBase (String base, int index) async {
    if (mounted) setState(() {
      // 删除对应Base
      gAppConf.global_config.value
      .ext_defs!
      .removeAt(index);
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
  Future <void> ConfigExt_deleteExt (String base,int base_index, int ext_index) async {
    if (mounted) setState(() {
      // 删除对应Base
      gAppConf.global_config.value
      .ext_defs![base_index]
      .extensions_list
      .removeAt(ext_index);
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
  Future <void> ConfigEnv_updateEnvKey (int index, String key) async {
    var oldKey = global_env!.keys.elementAt(index);
    var value = global_env!.values.elementAt(index);
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
    return;
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
                                      await ConfigEnv_updateEnvKey(index_in, newKey);
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
                            itemCount: gAppBuild.global_config.value
                                       .ext_defs == null
                            ? 0
                            : gAppBuild.global_config.value.ext_defs!.length,
                            itemBuilder:(context, index) {
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
                                              await ConfigExt_deleteBase(
                                                gAppBuild.global_config.value
                                                .ext_defs![index]
                                                .appId,
                                                index
                                              );
                                            }
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: MyButton_CreateItem(
                                            canPress: ValueNotifier<bool>(
                                              gAppBuild.global_config.value.ext_defs![index].appId.isNotEmpty
                                            ),
                                            onPressed: () async {
                                              await ConfigExt_createNewExt(index);
                                            }
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    GlobalAppUI_Extensions(
                                      base_index: index,
                                      textctl_name_list: textctl_ext_name_list[
                                        gAppBuild.global_config.value
                                        .ext_defs![index].appId
                                      ] ?? [],
                                      textctl_version_list: textctl_ext_version_list[
                                        gAppBuild.global_config.value
                                        .ext_defs![index].appId
                                      ] ?? [],
                                      writeExtensionInfo: () async {
                                        await ConfigExt_writeExtionInfo();
                                      },
                                      deleteExtensionInfo: (base, ext_index) async {
                                        await ConfigExt_deleteExt(
                                          base, 
                                          index,
                                          ext_index,
                                        );
                                      },
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
