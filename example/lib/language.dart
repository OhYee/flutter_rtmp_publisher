var language = [
  Language(),
  Language(
    language: "中文",
    address: "RTMP服务地址",
    startPreview: "开始预览",
    stopPreview: "结束预览",
    startStream: "开始推流",
    stopStream: "结束推流",
  ),
];

class Language {
  String language;
  String address;
  String startPreview;
  String stopPreview;
  String startStream;
  String stopStream;
  bool use = false;

  Language({
    this.language = "English",
    this.address = "RTMP Server Address",
    this.startPreview = "Start preview",
    this.stopPreview = "Stop preview",
    this.startStream = "Start publish",
    this.stopStream = "Stop publish",
  });

  Language useThis() {
    this.use = true;
    return this;
  }
}
