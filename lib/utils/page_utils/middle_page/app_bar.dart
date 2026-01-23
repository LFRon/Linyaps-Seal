// 玲珑Seal头部导航栏组件

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names, curly_braces_in_flow_control_structures, must_be_immutable

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/page_utils/about_button.dart';
import 'package:yaru/widgets.dart';

class AppBar_MiddlePage extends StatefulWidget implements PreferredSizeWidget {

  // 获取必需的按下应用触发器
  Function() onPressed;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  AppBar_MiddlePage({
    super.key,
    required this.onPressed,
  });

  @override
  State<AppBar_MiddlePage> createState() => _AppBar_MiddlePageState();
}

class _AppBar_MiddlePageState extends State<AppBar_MiddlePage> {

  // 声明刷新应用信息按钮
  late MyButton_About about_button;

  @override
  void initState () {
    super.initState();

    // 初始化刷新应用按钮
    about_button = MyButton_About(
      text: Text(
        '关于',
        style: TextStyle(
          fontSize: 13,
        ),
      ), 
      is_pressed: ValueNotifier<bool>(false), 
      indicator_width: 10, 
      onPressed: () {
        widget.onPressed();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: YaruMasterDetailTheme.of(context).sideBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 头部显示选择查看玲珑应用还是Base的复选框
          Text(
            '玲珑应用',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            width: 80,
            height: 35,
            child: about_button,
          ),
        ],
      ),
    );
  }
}
