// 删除选项的按钮设计

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:yaru/theme.dart';

class MyButton_DeleteItem extends StatelessWidget {

  // 声明需要传入的按下操作
  VoidCallback onPressed;

  MyButton_DeleteItem({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: YaruColors.adwaitaRed,
        padding: EdgeInsets.zero,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 20,
            Icons.delete_outline
          ),
        ],
      ),
    );
  }
}
