// 将玲珑包信息抽象为一个标准类

// ignore_for_file: non_constant_identifier_names

// 设置一个玲珑包类别的enum枚举
enum PackageType {
  app,
  runtime,
  base,
  extension, 
}

class LinyapsPackageInfo {

  // 声明玲珑应用必须有的信息
  String id;   // 应用包名
  String kind;  // 玲珑包的类型 (是app,base还是runtime)
  String name;  // 应用名称
  String description;    // 应用介绍信息
  String arch;  // 应用架构
  String version;    // 应用版本信息

  // 声明玲珑应用可拥有的权限
  List <String>? extensions;


  String? Icon;    // 应用图标所在链接
  String? repoName;    // 应用所在源名称
  String? channel;   // 应用所在渠道
  String? module;    // 所用的玲珑模块
  String? size;    // 安装包文件大小
  String? base;   // 应用base依赖信息
  String? runtime;     // 应用Runtime依赖信息(注意:可以为没有(null))
  String? schema_version;    // 应用的玲珑schema_version信息

  // 声明应用后台接口信息
  String? zhName;    // 应用在后台的名称
  String? categoryName;    // 应用分类类名
  String? createTime;   // 上架时间
  int? installCount;    // 安装次数
  String? uninstallCount;   // 卸载次数
  String? uabUrl;   // 应用离线分发包(.uab)下载地址
  String? user;     // 用户名(未知用途)
  String? devName;    // 维护者名称

  LinyapsPackageInfo ({
    required this.kind,
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.arch,
    this.Icon,

    // 权限管理部分
    this.extensions,
    

    // this.IconUpdated,
    this.repoName,
    this.channel,
    this.module,
    this.size,
    this.base,
    this.runtime,
    this.schema_version,
    this.zhName,
    this.categoryName,
    this.createTime,
    this.installCount,
    this.uninstallCount,
    this.uabUrl,
    this.user,
    this.devName,
  });
}
