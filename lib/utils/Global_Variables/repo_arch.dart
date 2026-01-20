// 应用全局变量管理

// 关闭VSCode非必要报错
// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, camel_case_types

import 'dart:io';
import 'package:get/get.dart';

class GlobalAppState_Arch extends GetxController {

  // 系统架构和商店返回的架构信息
  RxString os_arch = ''.obs;
  RxString repo_arch = ''.obs;

  /*--         系统架构获取部分        --*/

  // 用于返回按照"uname -m"标准命令输出的架构信息
  Future <void> getUnameArch () async {
    ProcessResult arch_result;
    arch_result = await Process.run('uname', ['-m']);
    // 更新操作系统架构信息
    String get_arch = arch_result.stdout.toString().trim();
    os_arch.value = get_arch;
    update();
    return;
  }

  // 用于返回按照玲珑商店架构要求的架构信息
  Future <void> getLinyapsStoreApiArch () async {
    ProcessResult arch_result;
    arch_result = await Process.run('uname', ['-m']);
    // 更新操作系统架构信息
    String os_arch = arch_result.stdout.toString().trim();
    String get_arch = '';
    if (os_arch == 'aarch64') get_arch = 'arm64';
    else get_arch = os_arch;
    // 更新变量信息
    repo_arch.value = get_arch;
    update();
    return;
  }
  
}
