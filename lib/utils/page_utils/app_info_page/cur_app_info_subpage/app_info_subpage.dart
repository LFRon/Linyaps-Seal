// 单独应用配置页面

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyaps_seal/utils/Backend_API/Linyaps_CLI_API/linyaps_cli_helper.dart';
import 'package:linyaps_seal/utils/Global_Variables/cur_app_config_info.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/config_classes/config_cur_app.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_createItem.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/cur_app_info_subpage/conf_env_widget/app_env/conf_env_app_builder.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/cur_app_info_subpage/conf_env_widget/global_env/conf_env_global_builder.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/cur_app_info_subpage/conf_ext_widget/app_ext/conf_app_ext_builder.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/cur_app_info_subpage/conf_ext_widget/base_ext/conf_base_list_builder.dart';
import 'package:yaru/widgets.dart';

class AppInfoPage_AppConf extends StatefulWidget {

  // 声明需传入必要的应用信息
  LinyapsPackageInfo curAppInfo;

  AppInfoPage_AppConf({
    super.key,
    required this.curAppInfo,
  });

  @override
  State<AppInfoPage_AppConf> createState() => _AppInfoPage_AppConfState();
}

class _AppInfoPage_AppConfState extends State<AppInfoPage_AppConf> {

  // 声明全局变量中存储全局配置信息的对象
  // 当下会被获取全局应用扩展和环境变量中用到
  // 声明全局变量中存储当前页面应用配置信息的对象
  late GlobalAppState_Config gConf;
  late GlobalAppState_AppConfig gAppConf;

  // 声明从父类传入的当前应用信息
  late LinyapsPackageInfo curAppInfo;

  // 声明存储当前应用的配置信息
  late Rx <ConfigAll_App> curAppConf;

  /*----------------------扩展部分-------------------------*/

  // 声明当前应用扩展列表的指针
  List <Extension>? get ext_list_app => gAppConf
                                        .curAppConf.value
                                        .ext_defs;
  set ext_list_app (List <Extension>? value) {
    gAppConf
    .curAppConf.value
    .ext_defs = value;
  }

  // 声明当前应用自身加载的扩展文本控制器
  List <TextEditingController> textctl_ext_name_list = [];
  List <TextEditingController> textctl_ext_version_list = [];

  // 初始化扩展内应用文本控制器方法
  Future <void> ConfigExt_initTextCtl () async {    

    // 若应用当前扩展列表不为空, 则初始化对应index的文本控制器
    if (ext_list_app != null) {
      if (ext_list_app!.isNotEmpty) {
        for (var i in ext_list_app!) {
          textctl_ext_name_list.add(TextEditingController(text: i.name));
          textctl_ext_version_list.add(TextEditingController(text: i.version));
        }
      }
    }
    
    return;
  }

  // 新建按钮新建扩展时触发的方法
  Future <void> ConfigExt_createExt () async {
    // 如果全局扩展列表配置未初始化则初始化
    ext_list_app ??= [];
    ext_list_app!.add(
      Extension(
        name: '', 
        version: '', 
        directory: '',
      ),
    );
    gAppConf.update();  // 触发响应式更新
    if (mounted) setState(() {
      // 对应文本控制器列表也进行新建
      textctl_ext_name_list.add(TextEditingController(text: ''));
      textctl_ext_version_list.add(TextEditingController(text: ''));
    });
    return;
  }

  // 更新并写入新的扩展信息
  Future <void> ConfigExt_updateExtInfo (int index, String name, String version) async {

    // 更新扩展信息
    // 这时直接空检查, 是因为用户只可能在列表有元素时进行修改
    ext_list_app![index].name = name;
    ext_list_app![index].version = version;
    gAppConf.update();

    // 写入配置信息
    await LinyapsCliHelper.write_linyaps_app_config();
    return;
  }

  // 删除指定扩展
  Future <void> ConfigExt_deleteExt (int index) async {

    // 如果存在应用当前扩展配置信息则获取并删除
    ext_list_app!.removeAt(index);

    // 更新扩展配置信息并通知重构UI
    gAppConf.update();

    if (mounted) setState(() {
      // 对应文本控制器列表也进行删除
      textctl_ext_name_list.removeAt(index);
      textctl_ext_version_list.removeAt(index);
    });

    // 写入配置信息
    await LinyapsCliHelper.write_linyaps_app_config();

    return;
  } 

  /*----------------------------------------------------*/

  /*-------------------环境变量部分---------------------*/

  // 存储当前全局环境变量的指针
  Map <String, String>? get env_global => gConf.global_config.value
                                          .env;
  set env_global (Map <String, String>? value) {
    gConf.global_config.value.env = value;
  }

  // 存储当前应用的环境变量指针
  Map <String, String>? get env_app => gAppConf.curAppConf.value
                                       .env;
  set env_app (Map <String, String>? value) {
    gAppConf.curAppConf.value.env = value;
  }

  // 声明环境变量用的文本控制器                                     
  late List <TextEditingController> textctl_env_name_list;
  late List <TextEditingController> textctl_env_value_list;

  // 环境变量: 初始化环境变量文本控制器方法
  Future <void> ConfigEnv_initTextCtl () async {
    textctl_env_name_list = [];
    textctl_env_value_list = [];
    // 如果存在应用当前环境变量配置信息则获取
    if (env_app != null) {
      env_app!.forEach((key, value) {
        textctl_env_name_list.add(TextEditingController(text: key));
        textctl_env_value_list.add(TextEditingController(text: value));
      });
    }
    return;
  }

  // 环境变量: 当用户按下新建按钮需要新建
  // 对应应用的环境变量时触发的方法
  Future <void> ConfigEnv_createItem () async {
    // 如果字典未初始化则进行初始化
    env_app ??= {};
    // 新建键值对
    if (!env_app!.containsKey('')) {
      curAppConf.value.env![''] = '';
    }
    // 对应文本控制器列表也进行新建
    textctl_env_name_list.add(TextEditingController(text: ''));
    textctl_env_value_list.add(TextEditingController(text: ''));
    gAppConf.update();  // 触发响应式更新
    if (mounted) setState(() {});
  }

  // 环境变量: 当用户修改子页面的字典键时所修改的内容
  // 若newKey合法或无重复则合法, 返回true, 否则返回false
  Future <bool> ConfigEnv_updateKey (int index, String newKey) async {
    // 注: 此时字典必定被初始化
    // 否则用户不可能通过下面的文本控制器触发这个函数

    // 先检查字典键是否为空
    if (newKey == '') return false;

    // 获取旧键的键和值
    var key_old = env_app!.keys.elementAt(index);
    var value_get = env_app!.values.elementAt(index);

    // 检查用户临时更改的新键是否重复
    // 如果重复则返回false
    if (env_app!.containsKey(newKey)) return false;

    env_app!.remove(key_old);  // 移除旧键
    env_app![newKey] = value_get;  // 给新键赋上新值

    gAppConf.update();  // 触发响应式更新
    // 保存并写入配置
    await LinyapsCliHelper.write_linyaps_app_config();
    return true;
  }

  // 环境变量: 当用户修改子页面的字典值时所修改的内容
  Future <void> ConfigEnv_updateValue (int index, String newValue) async {
    // 注: 此时字典必定被初始化
    // 否则用户不可能通过下面的文本控制器触发这个函数

    // 获取旧键的键和值
    var key_get = env_app!.keys.elementAt(index);

    env_app![key_get] = newValue;  // 给新键赋上新值

    gAppConf.update();  // 触发响应式更新
    // 保存并写入配置
    await LinyapsCliHelper.write_linyaps_app_config();
    return;
  }

  // 环境变量: 当用户删除子页面的字典键时所修改的内容
  Future <void> ConfigEnv_deleteItem (int index) async {
    // 注: 此时字典必定被初始化
    // 否则用户不可能通过下面的文本控制器触发这个函数

    // 获取旧键的键和值
    var key_old = env_app!.keys.elementAt(index);
    env_app!.remove(key_old);  // 移除旧键

    // 保存并写入配置
    await LinyapsCliHelper.write_linyaps_app_config();

    gAppConf.update();  // 触发响应式更新
    if (mounted) setState(() {
      // 对应文本控制器列表也进行删除
      textctl_env_name_list.removeAt(index);
      textctl_env_value_list.removeAt(index);
    });
    return;
  }

  /*----------------------------------------------------*/

  /*----------------------扩展部分----------------------*/

  /*----------------------------------------------------*/

  // 页面加载状态管理, 默认为未加载状态
  bool is_page_loaded = false;

  // 设置页面加载完成
  Future <void> setPageLoaded () async {
    if (mounted) setState(() {
      is_page_loaded = true;
    });
    return;
  }
  
  // 设置页面未加载完成
  Future <void> setPageNotloaded () async {
    if (mounted) setState(() {
      is_page_loaded = false;
    });
    return;
  }

  // 覆写初始化方法, 加入私货
  @override
  void initState() {
    super.initState();

    // 初始化当前应用信息
    curAppInfo = widget.curAppInfo;
    // 初始化全局对象获取
    gConf = Get.find<GlobalAppState_Config>();
    // 初始化全局变量中存储当前页面应用配置信息的对象
    gAppConf = Get.find<GlobalAppState_AppConfig>();
    // 初始化当前应用配置信息 (注: 这里是响应式变量)
    // 也就是更改了curAppConf的值会直接更改gAppConf.curAppConf !!!
    curAppConf = gAppConf.curAppConf;

    // 通过Future暴力异步开始初始化页面
    Future.microtask(() async {

      await setPageNotloaded();  // 重置页面加载状态

      await gAppConf.updateAppConfig(curAppInfo);
      // 初始化扩展部分
      // 文本控制器
      await ConfigExt_initTextCtl();

      // 初始化环境变量文本控制器 
      await ConfigEnv_initTextCtl();

      await setPageLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 声明需传入必要的应用信息
    LinyapsPackageInfo curAppInfo = widget.curAppInfo;
    return GetBuilder<GlobalAppState_AppConfig>(
      builder: (gAppBuilder) {

        /*--------------------------扩展部分-------------------------*/

        // 在Builder内获取Base扩展信息
        String cur_app_base = curAppInfo.base;

        // 页面构建时存储应用对应Base扩展的列表, 这里强制非空防止UI构建时出现空异常
        List <Extension> ext_list_base_builder = [];
        if (gConf.global_config.value.ext_defs != null) {
          ext_list_base_builder = gConf.global_config.value
                          .ext_defs![cur_app_base] ?? [];
        }

        // 页面构建时存储应用对应的扩展列表, 这里强制非空防止UI构建时出现空异常
        List <Extension> ext_list_app_builder = ext_list_app ?? [];
        
        /*------------------------------------------------------------*/

        /*-----------------------环境变量部分-------------------------*/        

        /*------------------------------------------------------------*/

        // UI界面构建部分
        return is_page_loaded
        ? Padding(
          padding: const EdgeInsets.only(top: 28.0, left: 35, right: 17),
          child: ListView(
            children: [
              // 此处使用Padding是避免与右侧滚轮区域重叠
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 左侧显示应用图标
                        CachedNetworkImage(
                          imageUrl: curAppInfo.Icon ?? '',
                          key: ValueKey(curAppInfo.name),
                          height: 150,width: 150,
                          placeholder: (context, loadingProgress) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                strokeWidth: 3.0,
                              ),
                            );
                          },
                          errorWidget: (context, error, stackTrace) => Center(
                            child: Image(
                              image: AssetImage(
                                'assets/images/linyaps-generic-app.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              curAppInfo.name,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              '包名: ${curAppInfo.id}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '版本: ${curAppInfo.version}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '运行环境: ${curAppInfo.runtime ?? '无'}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 显示扩展信息字样
                    const SizedBox(height: 25,),
                    // 环境变量子项UI构建
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'App Env',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '当前应用的环境变量',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    YaruBorderContainer(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '已经设置的全局环境变量:   ',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                // 检查全局变量是否为空
                                // 根据这个合理提示的UI渲染与提示
                                env_global != null
                                ? env_global!.isEmpty
                                  ? Text(
                                    '暂无',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                  : SizedBox.shrink()
                                : Text(
                                  '暂无',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            ListView.builder(
                              shrinkWrap: true,
                              // 禁止子列表滚动
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: env_global == null
                                         ? 0
                                         : env_global!.length,
                              itemBuilder:(context, index) {
                                return AppInfoPage_EnvWidget_Global(
                                  curIndex: index, 
                                  curKey: env_global!.keys.elementAt(index), 
                                  curValue: env_global!.values.elementAt(index),
                                );
                              },
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '当前应用设置的环境变量: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: MyButton_CreateItem(
                                    // 是否能按下时, 需要检查用户是否
                                    // 已经新建了键为''的变量
                                    // 若新建了不能再让用户急需创建, 防止污染字典 
                                    canPress: env_app == null
                                              ? ValueNotifier<bool>(true) 
                                              : env_app!.containsKey('')
                                                ? ValueNotifier<bool>(false)
                                                : ValueNotifier<bool>(true),
                                    onPressed: () async {
                                      await ConfigEnv_createItem();
                                    }
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            env_app != null
                            ? env_app!.isNotEmpty
                              ? ListView.builder(
                                shrinkWrap: true,
                                // 禁止子列表滚动
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: env_app == null
                                          ? 0
                                          : env_app!.length,
                                itemBuilder:(context, index) {
                                  // 处理Flutter的BUG引起的ListView.builder
                                  // 提早加载的问题
                                  try {
                                    return AppInfoPage_EnvWidget_App(
                                      curIndex: index, 
                                      curKey: env_app!.keys.elementAt(index), 
                                      curValue: env_app!.values.elementAt(index),
                                      textctl_env_name: textctl_env_name_list[index],
                                      textctl_env_value: textctl_env_value_list[index],
                                      updateEnvKey: (curIndex, newKey) async {
                                        return await ConfigEnv_updateKey(curIndex, newKey);
                                      },
                                      updateEnvValue: (curIndex, newValue) async {
                                        await ConfigEnv_updateValue(curIndex, newValue);
                                      },
                                      deleteEnvItem: (curIndex) async {
                                        await ConfigEnv_deleteItem(curIndex);
                                      },
                                    );
                                  }
                                  catch (e) {
                                    return SizedBox.shrink();
                                  }
                                },
                              )
                              : SizedBox.shrink()
                            : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25,),
                    // 扩展信息子项UI构建
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              '应用加载的扩展',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    YaruBorderContainer(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '基础环境: $cur_app_base 加载的扩展:',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            // 渲染对应Base的扩展列表
                            ext_list_base_builder.isNotEmpty
                            ? ListView.builder(
                              shrinkWrap: true,
                              // 禁止子列表滚动
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: ext_list_base_builder.length,
                              itemBuilder:(context, index) {
                                return AppInfoPage_ExtWidget_Base(
                                  cur_base_ext: ext_list_base_builder[index],
                                  index: index,
                                );
                              },  
                            )
                            : Center(
                              child: Text(
                                '暂无扩展',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '当前应用加载的扩展:',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: MyButton_CreateItem(
                                    canPress: ValueNotifier<bool>(true), 
                                    onPressed: () async {
                                      await ConfigExt_createExt();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            ext_list_app_builder.isNotEmpty
                            ? ListView.builder(
                              shrinkWrap: true,
                              // 禁止子列表滚动
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: ext_list_app_builder.length,
                              itemBuilder:(context, index) {
                                // 通过捕捉异常修复子页面类加载过早问题
                                try {
                                  return AppInfoPage_ExtListWidget_App(
                                    cur_ext_info: ext_list_app_builder[index], 
                                    textctl_ext_name: textctl_ext_name_list[index],
                                    textctl_ext_version: textctl_ext_version_list[index],
                                    index: index,
                                    updateExtInfo: (index, name, version) async {
                                      await ConfigExt_updateExtInfo(index, name, version);
                                    },
                                    deleteExtInfo:(index) async {
                                      await ConfigExt_deleteExt(index);
                                    },
                                  );
                                } catch (e) {
                                  return SizedBox.shrink();
                                }
                              },  
                            )
                            : const SizedBox.shrink(),
                          ],  
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        : SizedBox.shrink();
      }
    );
  }
}
