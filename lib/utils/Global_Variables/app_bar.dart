// 应用全局变量管理-下拉选框

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'package:get/get.dart';

class GlobalAppState_AppBar extends GetxController {

  // 用户需要查看的AppBar下拉框选项
  final RxList <String> linyapsKindLabels = [
    'app',
    'base'
  ].obs;
  final RxMap <String, String> linyapsKindNames = {
    'app': '玲珑应用',
    'base': '基础环境'
  }.obs;
  RxString selectedLinyapsShowKind = 'app'.obs;    // 声明查看应用还是Base权限的复选框选项

}
