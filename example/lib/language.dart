var language = [
  Language(),
  Language(
    language: "中文",
    address: "RTMP服务地址",
    startPreview: "开始预览",
    stopPreview: "结束预览",
    startStream: "开始推流",
    stopStream: "结束推流",
    resolution: "分辨率",
    resolutionFirst: "请选择一个分辨率",
    resolutionIsLoding: "正在加载分辨率",
    switchCamera: "切换摄像头",
    video: "视频",
    videoBitrate: "视频比特率",
    fps: "刷新率(FPS)",
    hardwareRotation: "硬件旋转",
    audio: "音频",
    audioBitrate: "音频比特率",
    sampleRate: "采样率",
    channel: "频段",
    echoCanceler: "回声消除",
    noiseSuppressor: "降噪",
    auth: "身份验证",
    username: "用户名",
    password: "密码",
    errorPreviewFirst: "错误！您必须先开始预览",
    errorResolutionFirst: "错误！您必须先选择一个分辨率",
    gotIt: "好",
  ),
];

class Language {
  String language;
  String address;
  String startPreview;
  String stopPreview;
  String startStream;
  String stopStream;
  String switchCamera;
  String video;
  String resolution;
  String resolutionIsLoding;
  String resolutionFirst;
  String videoBitrate;
  String fps;
  String hardwareRotation;
  String audio;
  String audioBitrate;
  String sampleRate;
  String channel;
  String echoCanceler;
  String noiseSuppressor;
  String auth;
  String username;
  String password;
  String errorResolutionFirst;
  String errorPreviewFirst;
  String gotIt;
  bool use = false;

  Language({
    this.language = "English",
    this.address = "RTMP Server Address",
    this.startPreview = "Start preview",
    this.stopPreview = "Stop preview",
    this.startStream = "Start publish",
    this.stopStream = "Stop publish",
    this.switchCamera = "Switch camera",
    this.video = "video",
    this.resolution = "Resolution",
    this.resolutionFirst = "Please select a resolution.",
    this.resolutionIsLoding = "Loading resolutions.",
    this.videoBitrate = "Video bitrate",
    this.fps = "FPS",
    this.hardwareRotation = "Hardware rotation",
    this.audio = "Audio",
    this.audioBitrate = "Audio bitrate",
    this.sampleRate = "Sample rate",
    this.channel = "Channel",
    this.echoCanceler = "Echo canceler",
    this.noiseSuppressor = "Noise suppressor",
    this.auth = "Auth",
    this.username = "Username",
    this.password = "Password",
    this.errorPreviewFirst = "Error! You must start preview first.",
    this.errorResolutionFirst = "Error! You must select a resolution first.",
    this.gotIt = "Got it!",
  });

  Language useThis() {
    this.use = true;
    return this;
  }
}
