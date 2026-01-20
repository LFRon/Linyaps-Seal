// 各个应用详情页面

// 关闭VSCode非必要报错
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/app_info_subpage.dart';
import 'package:linyaps_seal/utils/page_utils/app_info_page/global_app_info_subpage/global_app_info_sub_main.dart';

class AppInfoPage extends StatefulWidget {

  // 获取应用必需的id信息
  // 如果curAppInfo传参为空, 那么默认为全部应用设置
  LinyapsPackageInfo? curAppInfo;

  AppInfoPage({
    super.key,
    required this.curAppInfo,
  });

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.curAppInfo == null
        // 如果curAppInfo传入的为空, 则进入全局应用控制页面
        ? globalAppUI_AppInfoPage()
        : appInfoUI_AppInfoPage(context: context, curAppInfo: widget.curAppInfo!).value()
    );
  }
}
