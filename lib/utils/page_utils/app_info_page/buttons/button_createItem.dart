// 新建选项的按钮设计

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable, file_names

import 'package:flutter/material.dart';

class MyButton_CreateItem extends StatelessWidget {

  // 声明是否允许按下
  ValueNotifier <bool> canPress;

  // 声明需要传入的按下操作
  VoidCallback onPressed;

  MyButton_CreateItem({
    super.key,
    required this.canPress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder <bool> (
      valueListenable: canPress, 
      builder:(context, value, child) => OutlinedButton(
        // 更改其内置的边距
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: value ? onPressed : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              size: 20,
              Icons.add_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
