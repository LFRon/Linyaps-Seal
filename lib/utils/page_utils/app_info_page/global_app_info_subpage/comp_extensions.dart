// 用于渲染扩展设置中每个base下的子扩展页面

// 关掉VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/Global_Variables/global_config_info.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';



class GlobalAppUI_Extensions extends StatefulWidget {

  // 传入当前扩展所属的Base名
  String cur_base;

  // 传入必需的当前子列表遍历指针
  int cur_index;

  // 传入必需的扩展列表名
  Extension cur_ext_info;

  // 传入必需的扩展名字与版本号控制的文本控制器列表
  TextEditingController textctl_name;
  TextEditingController textctl_version;

  // 传入扩展名更新时触发的回调函数
  Future <void> Function(String base, int ext_index, String newExtName) updateExtensionName;

  // 传入扩展版本号更新时触发的回调函数
  Future <void> Function(String base, int ext_index, String newExtVersion) updateExtensionVersion;

  // 传入必需的写入扩展信息的回调函数
  // 这里base用于区分确认是哪个Base
  // 而index用于确认是列表中的哪个元素
  // 因为下面ListView.builder构建时
  // 每个item都有唯一index, 故可用这个确定
  Future <void> Function(String base, int ext_index) deleteExtensionInfo;

  GlobalAppUI_Extensions({
    super.key,
    required this.cur_base,
    required this.cur_index,
    required this.cur_ext_info,
    required this.textctl_name,
    required this.textctl_version,
    required this.updateExtensionName,
    required this.updateExtensionVersion,
    required this.deleteExtensionInfo,
  });
  @override
  State<GlobalAppUI_Extensions> createState() => _GlobalAppUI_ExtensionsState();
}

class _GlobalAppUI_ExtensionsState extends State<GlobalAppUI_Extensions> {

  // 声明必需的全局应用变量
  late GlobalAppState_Config gAppConf;

  @override
  Widget build(BuildContext context) {
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
                    '扩展${widget.cur_index+1}名称:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: widget.textctl_name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                        border: OutlineInputBorder(), // 可选：添加边框样式
                      ),
                      style: TextStyle(
                        height: 1.3
                      ),
                      onChanged: (newName) async {
                        await widget.updateExtensionName(
                          widget.cur_base,
                          widget.cur_index,
                          newName,
                        );
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
                      controller: widget.textctl_version,
                      decoration: InputDecoration( 
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                        border: OutlineInputBorder(), // 可选：添加边框样式
                      ),
                      style: TextStyle(
                        height: 1.3
                      ),
                      onChanged: (newVersion) async {
                        await widget.updateExtensionVersion(
                          widget.cur_base,
                          widget.cur_index,
                          newVersion,
                        );
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
                      widget.cur_base,
                      widget.cur_index,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
