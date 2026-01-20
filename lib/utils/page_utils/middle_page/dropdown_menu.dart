//设计获奖地域等级下拉选框

//忽略VSCode命名报警问题
// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_field, prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class DropDownMenu_ShowAppKinds extends StatefulWidget {
  final Function(String) onChanged;   // 设置回调函数用于选项变化时更新传入的全局变量
  final Function(String) onInit;   // 设置回调函数启动时给new_region_level赋全局变量
  double height;
  double width;

  DropDownMenu_ShowAppKinds({
    super.key,
    required this.onChanged,
    required this.onInit,
    required this.height,
    required this.width,
  });
  @override
  State<DropDownMenu_ShowAppKinds> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DropDownMenu_ShowAppKinds> {
  
  final List<String> data = ['app', 'base'];
  late String _selectedRegionLevel;   // 专门用于存储下面被选中的变量,之所以要这么设置是防止对话框一结束就导致变量重置,所以搞一个页面生命周期内的变量防止这样的情况发生              
  // 声明获取屏幕长宽的变量
  late double height;
  late double width;
  // 覆写类的构造函数
  @override
  void initState () {
    super.initState();
    height = widget.height;
    width = widget.width;
    setState(() {      // StatefulWidget里要赋初值的话必须用setState更新状态!
      _selectedRegionLevel=data[0];
    });
    widget.onInit(data.first);
  }

  @override
  Widget build(BuildContext context) {
    return Row(   // 设置列式布局方便居中对齐
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          menuWidth: height*0.18,
          alignment: AlignmentDirectional.bottomCenter,   // 设置选中的选项文字显示在中间
          value: _selectedRegionLevel,
          items: [
            DropdownMenuItem(
              value: 'app',
              child: Center(child: Text("玲珑应用")),
            ),
            DropdownMenuItem(
              value: 'base',
              child: Center(child: Text("玲珑基础环境")),
            ),
          ], 
          onChanged: (newValue){
            // 如果用户没有做选择直接选择默认选项
            if (newValue!.isEmpty) {
              newValue=data.first;
            }
            setState(() {
              _selectedRegionLevel=newValue!;
            });
            widget.onChanged(newValue);   // 更新外部变量
          },
        ),
      ],
    );
  }

}
