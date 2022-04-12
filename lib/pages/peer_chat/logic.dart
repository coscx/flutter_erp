import 'dart:async';
import 'dart:io';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_erp/pages/peer_chat/widget/peer_chat_item.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:frefresh/frefresh.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../conversion/widget/colors.dart';
import '../conversion/widget/object_util.dart';
import 'state.dart';
import 'package:vibration/vibration.dart';
class PeerChatLogic extends GetxController {
  final PeerChatState state = PeerChatState();
  bool isBlackName = false;
  List<String> popString = <String>[];
  bool isShowSend = false; //是否显示发送按钮
  bool isShowVoice = false; //是否显示语音输入栏
  bool isShowFace = false; //是否显示表情栏
  bool isShowTools = false; //是否显示工具栏
  var voiceText = '按住 说话';
  var voiceBackground = ObjectUtil.getThemeLightColor();
  Color headsetColor = ColorT.gray_33;
  Color highlightColor = ColorT.gray_66;
  List<Widget> guideFaceList =  [];
  List<Widget> guideFigureList =  [];
  List<Widget> guideToolsList =  [];
  bool isFaceFirstList = true;
  bool alive = false;
  String audioIconPath = '';
  String voiceFilePath = '';
  String tfSender = "0";
  FltImPlugin im = FltImPlugin();
  late FRefreshController controller3;
  bool isLoading = false;
  late Permission permission;
  late Timer timer;
  int voiceCount = 0;
  late StreamSubscription? recorderSubscription;
  late StreamSubscription? playerSubscription;
  late FlutterSoundRecorder flutterSound;
  TextEditingController controller =  TextEditingController();
  ScrollController scrollController =  ScrollController();
  FocusNode textFieldNode = FocusNode();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  double progress = 0;
  Map<String, GlobalKey<PeerChatItemWidgetState>> globalKeyMap = {};

  startRecord() async {
    Vibration.vibrate(duration: 50);

      voiceText = '松开 结束';
      voiceBackground = ColorT.divider;
      stopRecorder();

    try {
      requestPermiss(permission);
      print('===>  获取了权限');
      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      voiceFilePath = '${tempDir.path}/s-$time${ext[Codec.aacADTS.index]}';
      print('===>  准备开始录音');
      await recorderModule.startRecorder(
        toFile: voiceFilePath,
        codec: Codec.aacADTS,
        bitRate: 8000,
        sampleRate: 8000,
      );

      /// 监听录音
      recorderSubscription = recorderModule.onProgress?.listen((e) {
        if (e != null && e.duration != null) {
          var volume = e.decibels;

            if (volume! <= 0) {
              audioIconPath = '';
            } else if (volume > 0 && volume< 30) {
              audioIconPath = 'audioplayer1';
            } else if (volume < 50) {
              audioIconPath = 'audioplayer2';
            } else if (volume < 100) {
              audioIconPath = 'audioplayer3';
            }

        }
      });
    } catch (err) {

        stopRecorder();
        cancelRecorderSubscriptions();

    }
  }

  void requestPermiss(Permission permission) async {
    //多个权限申请
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.speech,
    ].request();
    print(statuses);
  }
  /// 开始播放
  Future<void> startPlayer(String path) async {
    try {
      var p = await fileExists(path);
      if (p != "") {
        await playerModule.startPlayer(
            fromURI: p,
            codec: Codec.aacADTS,
            whenFinished: () {
              print('==> 结束播放');
              stopPlayer();

            });
      } else {
        throw RecordingPermissionException("未找到文件路径");
      }

      cancelPlayerSubscriptions();
      playerSubscription = playerModule.onProgress?.listen((e) {
        if (e != null) {
          //print("${e.duration} -- ${e.position} -- ${e.duration.inMilliseconds} -- ${e.position.inMilliseconds}");
          // setState(() {
          //   progress = e.position.inMilliseconds / e.duration.inMilliseconds;
          // });

        }
      });

      print('===> 开始播放');
    } catch (err) {
      print('==> 错误: $err');
    }
 
  }

  /// 结束播放
  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      print('===> 结束播放');
      cancelPlayerSubscriptions();
    } catch (err) {
      print('==> 错误: $err');
    }
  }

  /// 暂停/继续播放
  void pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();

      print('===> 暂停播放');
    } else {
      playerModule.resumePlayer();

      print('===> 继续播放');
    }
    
  }
  /// 取消录音监听
  /// 结束录音
  stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      print('stopRecorder');
      cancelRecorderSubscriptions();
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  /// 取消录音监听
  void cancelRecorderSubscriptions() {
    if (recorderSubscription != null) {
      recorderSubscription?.cancel();
      recorderSubscription = null;
    }
  }

  /// 取消播放监听
  void cancelPlayerSubscriptions() {
    if (playerSubscription != null) {
      playerSubscription?.cancel();
      playerSubscription = null;
    }
  }

  /// 释放录音和播放
  Future<void> releaseFlauto() async {
    try {
      await playerModule.closePlayer();
      await recorderModule.closeRecorder();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }
  void hideKeyBoard() {
    textFieldNode.unfocus();
  }
  void listOnTap() {
    if(isShowVoice == true ||isShowFace == true||isShowTools == true){
    
        isShowVoice = false;
        isShowFace = false;
        isShowTools = false;
   
    }
  }
  void inputLeftOnTap() {
    if (isShowVoice) {
      isShowVoice = false;
    } else {
      isShowVoice = true;
      isShowFace = false;
      isShowTools = false;
    }
  }
  void inputRightFaceOnTap() {
    if (isShowFace) {
      isShowFace = false;
    } else {
      isShowFace = true;
      isShowVoice = false;
      isShowTools = false;
    }
  }
  void inputRightSendOnTap() {
    if (isShowTools) {
      isShowTools = false;
    } else {
      isShowTools = true;
      isShowFace = false;
      isShowVoice = false;
    }
  }
  /// 判断文件是否存在
  Future<String> fileExists(String paths) async {
    if (paths.startsWith("http://localhost")) {
      //File f =   await _getLocalFile(path.basename(paths));
      return voiceFilePath;
    } else if (paths.startsWith("http")) {
      return paths;
    }

    return paths;
  }
  
  
  
}
