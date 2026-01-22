// 用于渲染扩展设置中每个base下的子扩展页面

// 关掉VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';



class GlobalAppUI_Extensions extends StatefulWidget {

  // 传入必需的Base_Index列表遍历指针
  int base_index;

  // 传入必需的扩展名字与版本号控制的文本控制器列表
  List <TextEditingController> textctl_name_list;
  List <TextEditingController> textctl_version_list;

  // 传入必需的写入扩展信息的回调函数
  Future <void> Function() writeExtensionInfo;

  // 传入必需的写入扩展信息的回调函数
  // 这里base用于区分确认是哪个Base
  // 而index用于确认是列表中的哪个元素
  // 因为下面ListView.builder构建时
  // 每个item都有唯一index, 故可用这个确定
  Future <void> Function(String base, int ext_index) deleteExtensionInfo;

  GlobalAppUI_Extensions({
    super.key,
    required this.base_index,
    required this.textctl_name_list,
    required this.textctl_version_list,
    required this.writeExtensionInfo,
    required this.deleteExtensionInfo,
  });
  @override
  State<GlobalAppUI_Extensions> createState() => _GlobalAppUI_ExtensionsState();
}

class _GlobalAppUI_ExtensionsState extends State<GlobalAppUI_Extensions> {

  // 声明必需的全局应用变量
  late GlobalAppState_Config gAppConf;

  // 更新扩展名称触发的函数
  Future <void> updateExtensionName(int index,String new_name) async {
    if (mounted) setState(() {
      gAppConf.global_config.value
      .ext_defs![widget.base_index]
      .extensions_list[index]
      .name = new_name;
      gAppConf.update();  // 触发响应式更新
    });
    return;
  }

  // 更新扩展版本触发的函数
  Future <void> updateExtensionVersion(int index,String new_version) async {
    if (mounted) setState(() {
      gAppConf.global_config.value
      .ext_defs![widget.base_index]
      .extensions_list[index]
      .version = new_version;
      gAppConf.update();  // 触发响应式更新
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    // 初始化全局变量
    gAppConf = Get.find<GlobalAppState_Config>();
  }

  @override
  Widget build(BuildContext context) {

    // 获取当前Base下的扩展列表
    var extensions_ro = gAppConf.global_config.value
    .ext_defs![widget.base_index]
    .extensions_list;

    return extensions_ro.isEmpty 
    ? const Text(
      '暂无扩展',
      style: TextStyle(
        fontSize: 16,
      ),
    ) 
    : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: extensions_ro.length,
      itemBuilder: (context, index) {
        // 先初始化各文本控制器
        // 1.初始化存储扩展名称的 2.再初始化存储扩展版本的
        var name_controller = widget.textctl_name_list[index];
        var version_controller = widget.textctl_version_list[index];

        return Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 父行控件用于分离前面扩展版本与后面的删除按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '扩展${index+1}名称:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: name_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                            border: OutlineInputBorder(), // 可选：添加边框样式
                          ),
                          style: TextStyle(
                            height: 1.3
                          ),
                          onChanged: (value) async {
                            await updateExtensionName(index, value);
                            await widget.writeExtensionInfo();
                          },
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Text(
                        '版本:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: version_controller,
                          decoration: InputDecoration( 
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                            border: OutlineInputBorder(), // 可选：添加边框样式
                          ),
                          style: TextStyle(
                            height: 1.3
                          ),
                          onChanged: (value) async {
                            await updateExtensionVersion(index, value);
                            await widget.writeExtensionInfo();
                          },
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    // 设置删除对应base的extension按钮
                    child: MyButton_DeleteItem(
                      onPressed: () async {
                        await widget.deleteExtensionInfo(
                          gAppConf.global_config.value
                          .ext_defs![widget.base_index]
                          .appId,
                          index,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
