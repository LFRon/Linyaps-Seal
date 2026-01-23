// 单个应用中其对应扩展列表的子元素
// 这是应用自身会加载的扩展

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';

class AppInfoPage_ExtListWidget_App extends StatefulWidget {

  // 获取当前扩展信息
  Extension cur_ext_info;

  // 获取当前的文本控制器
  TextEditingController textctl_ext_name;
  TextEditingController textctl_ext_version;

  // 获取当前列表index项
  int index;

  // 声明更新扩展信息用的回调函数
  Future <void> Function (int index, String name, String version) updateExtInfo;

  // 声明删除扩展信息用的回调函数
  Future <void> Function (int index) deleteExtInfo;
  
  AppInfoPage_ExtListWidget_App({
    super.key,
    required this.cur_ext_info,
    required this.textctl_ext_name,
    required this.textctl_ext_version,
    required this.index,
    required this.updateExtInfo,
    required this.deleteExtInfo,
  });
  @override
  State<AppInfoPage_ExtListWidget_App> createState() => _AppInfoPage_ExtListWidget_AppState();
}

class _AppInfoPage_ExtListWidget_AppState extends State<AppInfoPage_ExtListWidget_App> {
  @override
  Widget build(BuildContext context) {
    // 传入父类信息
    // 当前列表项数
    int index = widget.index;
    // 当前文本控制器
    TextEditingController textctl_ext_name = widget.textctl_ext_name;
    TextEditingController textctl_ext_version = widget.textctl_ext_version;
    return Padding(
      padding: EdgeInsets.only(top: 3.0,bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '扩展${index+1}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20,),
              Text(
                '名称:',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: textctl_ext_name,
                  decoration: InputDecoration( 
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                    border: OutlineInputBorder(), // 可选：添加边框样式
                  ),
                  style: TextStyle(
                    height: 1.3
                  ),
                  onChanged: (value) {
                    // 更新扩展信息
                    widget.updateExtInfo(index, value, textctl_ext_version.text);
                  },
                ),
              ),
              const SizedBox(width: 20,),
              Text(
                '版本:',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: textctl_ext_version,
                  decoration: InputDecoration( 
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                    border: OutlineInputBorder(), // 可选：添加边框样式
                  ),
                  style: TextStyle(
                    height: 1.3
                  ),
                  onChanged: (value) async {
                    // 更新扩展信息
                    await widget.updateExtInfo(index, textctl_ext_name.text, value);
                  },
                ),
              ),
              const SizedBox(width: 15,),
            ],
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: MyButton_DeleteItem(
              onPressed:() async {
                await widget.deleteExtInfo(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
