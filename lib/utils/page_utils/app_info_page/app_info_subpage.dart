// 对应应用管理子页面

// ignore_for_file: camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linyaps_seal/utils/config_classes/linyaps_package_info.dart';

class appInfoUI_AppInfoPage {

  // 声明需传入的页面上下文
  BuildContext context;

  // 声明需传入必要的应用信息
  LinyapsPackageInfo curAppInfo;

  appInfoUI_AppInfoPage ({
    required this.curAppInfo,
    required this.context,
  });

  Widget value () {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, left: 35, right: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 左侧显示应用图标
              CachedNetworkImage(
                imageUrl: curAppInfo.Icon ?? '',
                key: ValueKey(curAppInfo.name),
                height: 150,width: 150,
                placeholder: (context, loadingProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 3.0,
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) => Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/linyaps-generic-app.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    curAppInfo.name,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    '包名: ${curAppInfo.id}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '版本: ${curAppInfo.version}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '运行环境: ${curAppInfo.runtime ?? '无'}',
                    style: TextStyle(
                      fontSize: 18,
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
