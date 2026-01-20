// 总扩展信息封装

// 关闭VSCode非必要报错
// ignore_for_file: camel_case_types

class Extension {
  String name;
  String version;
  String directory;
  Extension ({
    required this.name,
    required this.version,
    required this.directory
  });
}
