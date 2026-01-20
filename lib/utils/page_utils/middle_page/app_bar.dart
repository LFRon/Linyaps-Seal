// 玲珑Seal头部导航栏组件

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types, non_constant_identifier_names, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:linyaps_seal/utils/Global_Variables/app_bar.dart';
import 'package:linyaps_seal/utils/page_utils/refresh_button.dart';
import 'package:yaru/widgets.dart';

class AppBar_MiddlePage extends StatefulWidget implements PreferredSizeWidget{

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const AppBar_MiddlePage({super.key});

  @override
  State<AppBar_MiddlePage> createState() => _AppBar_MiddlePageState();
}

class _AppBar_MiddlePageState extends State<AppBar_MiddlePage> {

  // 声明刷新应用信息按钮
  late MyButton_RefreshApps refresh_apps_button;

  @override
  void initState () {
    super.initState();

    // 初始化刷新应用按钮
    refresh_apps_button = MyButton_RefreshApps(
      text: Text(
        '刷新',
        style: TextStyle(
          fontSize: 13,
        ),
      ), 
      is_pressed: ValueNotifier<bool>(false), 
      indicator_width: 10, 
      onPressed: () async {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalAppState_AppBar>(
      builder: (appState) {
        return AppBar(
          backgroundColor: YaruMasterDetailTheme.of(context).sideBarColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 头部显示选择查看玲珑应用还是Base的复选框
              YaruPopupMenuButton(
                initialValue: appState.selectedLinyapsShowKind.value,
                child: Text(appState.linyapsKindNames[appState.selectedLinyapsShowKind.value] ?? '未知的选项'), 
                itemBuilder: (context) {
                  return appState.linyapsKindLabels.map((option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(
                        appState.linyapsKindNames[option] ?? '未知的选项',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (String value) {
                  appState.selectedLinyapsShowKind.value = value;
                  appState.update();
                },
              ),
              SizedBox(
                width: 80,
                height: 35,
                child: refresh_apps_button,
              ),
            ],
          ),
        );
      }
    );
  }
}
