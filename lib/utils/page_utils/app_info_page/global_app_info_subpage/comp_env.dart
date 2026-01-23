// 全局配置下的全局变量子控件

// 关闭VSCode非必要扩展
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';

class GlobalAppUI_Env extends StatefulWidget {

  // 获取必要的index信息
  int index;

  // 获取必要的键
  String name;

  // 获取必要的值
  String value;

  // 获取必要的当前文本控制器
  TextEditingController textctl_name;
  TextEditingController textctl_value;

  // 获取必要的更新键回调函数
  Future <void> Function(int index, String newKey) updateKey;
  // 获取必要的更新值回调函数
  Future <void> Function(int index, String newValue) updateValue;
  // 获取必要的删除值回调函数
  Future <void> Function(int index) deleteKey;

  GlobalAppUI_Env({
    super.key,
    required this.index,
    required this.name,
    required this.value,
    required this.textctl_name,
    required this.textctl_value,
    required this.updateKey,
    required this.updateValue,
    required this.deleteKey,
  });

  @override
  State<GlobalAppUI_Env> createState() => _GlobalAppUI_EnvState();
}

class _GlobalAppUI_EnvState extends State<GlobalAppUI_Env> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsetsGeometry.only(left: 12.0, right: 12.0, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '变量名称:',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.textctl_name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                    border: OutlineInputBorder(),   // 可选：添加边框样式
                  ),
                  style: TextStyle(
                    height: 1.3
                  ),
                  onChanged: (key) async {
                    await widget.updateKey(widget.index, key);
                  },
                ),
              ),
              const SizedBox(width: 10,),
              Text(
                '变量值:',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.textctl_value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                    border: OutlineInputBorder(),   // 可选：添加边框样式
                  ),
                  style: TextStyle(
                    height: 1.3
                  ),
                  onChanged: (newValue) async {
                    await widget.updateValue(widget.index, newValue);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: MyButton_DeleteItem(
              onPressed: () async {
                await widget.deleteKey(widget.index);
              }
            ),
          ),
        ],
      ),
    );
  }
}
