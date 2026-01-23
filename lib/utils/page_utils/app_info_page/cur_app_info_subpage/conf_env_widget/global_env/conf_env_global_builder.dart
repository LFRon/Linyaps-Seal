// 应用内全局变量ListView.builder子控件

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class AppInfoPage_EnvWidget_Global extends StatefulWidget {

  // 获取当前需要的Index列表构建项数
  int curIndex;

  // 获取当前变量信息的键
  String curKey;

  // 获取当前变量信息的值
  String curValue;

  AppInfoPage_EnvWidget_Global({
    super.key,
    required this.curIndex,
    required this.curKey,
    required this.curValue,
  });

  @override
  State<AppInfoPage_EnvWidget_Global> createState() => _AppInfoPage_EnvWidget_GlobalState();
}

class _AppInfoPage_EnvWidget_GlobalState extends State<AppInfoPage_EnvWidget_Global> {
  @override
  Widget build(BuildContext context) {

    // 传入父控件index
    int curIndex = widget.curIndex;

    return Padding(
      padding: const EdgeInsets.only(top: 3.0,bottom: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    '变量${curIndex+1}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Text(
                    '变量名: ${widget.curKey}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    '值: ${widget.curValue}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
