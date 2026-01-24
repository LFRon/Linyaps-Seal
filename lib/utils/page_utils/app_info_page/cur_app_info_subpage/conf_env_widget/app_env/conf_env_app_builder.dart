// 单个应用环境变量ListView.builder子控件

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/buttons/button_deleteItem.dart';

class AppInfoPage_EnvWidget_App extends StatefulWidget {

  // 获取必需的Index
  int curIndex;

  // 获取必需的文本控制器
  TextEditingController textctl_env_name;
  TextEditingController textctl_env_value;

  // 获取必需的键值对
  String curKey;
  String curValue;

  // 传入必需的文本更改时自动保存函数
  Future <bool> Function (int curIndex, String newKey) updateEnvKey; 
  Future <void> Function (int curIndex, String newValue) updateEnvValue; 

  // 传入必需的删除该项时自动保存函数
  Future <void> Function (int curIndex) deleteEnvItem;

  AppInfoPage_EnvWidget_App({
    super.key,
    required this.curIndex,
    required this.curKey,
    required this.curValue,
    required this.textctl_env_name,
    required this.textctl_env_value,
    required this.updateEnvKey,
    required this.updateEnvValue,
    required this.deleteEnvItem,
  });

  @override
  State<AppInfoPage_EnvWidget_App> createState() => _AppInfoPage_EnvWidget_AppState();
}

class _AppInfoPage_EnvWidget_AppState extends State<AppInfoPage_EnvWidget_App> {

  // 该状态开关用于判断用户设置的键是否有效
  // 如果无效, 则为false
  bool is_key_valid = true;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 3.0,bottom: 3.0),
      // 外层Row用于隔开其他控件与删除按钮
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '变量名: ',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 5,),   // 设置控件间合理横向间距
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.textctl_env_name,
                  decoration: is_key_valid
                    // 键合法时的装饰
                    ? InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                      border: OutlineInputBorder(),   // 可选：添加边框样式
                    ) 
                    // 键非法时的装饰, 同时设置聚焦与非聚焦边框样式
                    // 以达到醒目效果
                    : InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow.shade700,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow.shade700,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ), 
                    ),
                  onChanged: (newKey) async {
                    bool isKeyValidGet = await widget.updateEnvKey(
                      widget.curIndex,
                      newKey,
                    );
                    if (mounted) setState(() {
                      is_key_valid = isKeyValidGet;
                    }
                    );
                  },
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 20,),
              Text(
                '值: ',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 5,),  
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.textctl_env_value,
                  decoration: is_key_valid
                    // 键合法时的装饰
                    ? InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                      border: OutlineInputBorder(),   // 可选：添加边框样式
                    ) 
                    // 键非法时的装饰, 同时设置聚焦与非聚焦边框样式
                    // 以达到醒目效果
                    : InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), // 调整内边距
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow.shade700,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow.shade700,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ), 
                    ),
                  style: TextStyle(
                    height: 1.3
                  ),
                  onChanged: (value) async {
                    await widget.updateEnvValue(widget.curIndex, value);
                  },
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (!is_key_valid) Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.yellow.shade700,
                ),
              ),
              Text(
                '发现无效设置',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.yellow.shade700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            width: 30,
            child: MyButton_DeleteItem(
              onPressed: () async {
                await widget.deleteEnvItem(widget.curIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
