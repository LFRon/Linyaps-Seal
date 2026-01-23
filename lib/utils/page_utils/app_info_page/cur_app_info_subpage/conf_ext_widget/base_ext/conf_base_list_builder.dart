// 单个应用中其对应扩展列表的子元素
// 这是应用Base会加载的扩展

// 忽略VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/config_classes/ext_defs/linyaps_extension.dart';

class AppInfoPage_ExtWidget_Base extends StatefulWidget {

  // 传入当前index是第几项
  int index;

  // 传入必需的当前扩展名称
  Extension cur_base_ext;

  AppInfoPage_ExtWidget_Base({
    super.key,
    required this.cur_base_ext,
    required this.index,
  });

  @override
  State<AppInfoPage_ExtWidget_Base> createState() => _AppInfoPage_ExtWidget_BaseState();
}

class _AppInfoPage_ExtWidget_BaseState extends State<AppInfoPage_ExtWidget_Base> {
  @override
  Widget build(BuildContext context) {
    Extension cur_base_ext = widget.cur_base_ext;
    int builder_index = widget.index+1;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0,bottom: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    '扩展$builder_index',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Text(
                    '名称: ${cur_base_ext.name}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    '版本: ${cur_base_ext.version}',
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
