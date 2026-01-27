// 关于软件页面设计

// 使用MyAbout是防止与Flutter内置的AboutDialog打架
import 'package:flutter/material.dart';
import 'package:linyaps_seal/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru/yaru.dart';

class MyAboutDialog extends StatefulWidget {
  const MyAboutDialog({super.key});

  @override
  State<MyAboutDialog> createState() => _MyAboutDialogState();
}

class _MyAboutDialogState extends State<MyAboutDialog> {

  // 按下报告问题按钮跳转的页面
  Future <void> reportIssue () async {
    await launchUrl(
      Uri.parse('https://gitee.com/LFRon/Linyaps-Seal/issues')
    );
  }

  // 按下查看源代码按钮跳转的页面
  Future <void> visitSource () async {
    await launchUrl(
      Uri.parse('https://gitee.com/LFRon/Linyaps-Seal')
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: YaruTitleBar(
        border: BorderSide.none,
        backgroundColor: Colors.transparent,
        isClosable: true,
        onClose: (_) {
          Navigator.of(context).pop();
        },
      ),
      titlePadding: EdgeInsets.all(5),
      content: SizedBox(
        width: 300,
        height: 355,
        child: Column(
          children: [
            Image.asset(
              'assets/images/linyaps-generic-app.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 10,),
            Text(
              '玲珑Seal',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(),
            Text(
              '管理玲珑应用权限',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 17,),
            Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                color: YaruColors.adwaitaBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  MyApp.cur_version,
                  style: TextStyle(
                    color: YaruColors.lubuntuBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25,),
            YaruBorderContainer(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {
                        await reportIssue();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '报告问题',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.open_in_new,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {
                        await visitSource();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '查看源代码',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              YaruIcons.pan_end,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
