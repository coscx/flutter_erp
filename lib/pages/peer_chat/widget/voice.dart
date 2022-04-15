import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

import '../../../common/utils/permission.dart';

 class Voice {
   StreamSubscription? recorderSubscription;
   StreamSubscription? playerSubscription;
    FlutterSoundRecorder? flutterSound;
   late  FlutterSoundRecorder recorderModule ;
   late  FlutterSoundPlayer playerModule ;
   Future<void> init() async {
    requestPermiss();
     recorderModule = FlutterSoundRecorder();
     playerModule = FlutterSoundPlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 30));
    await recorderModule.openRecorder();
    await recorderModule
        .setSubscriptionDuration(const Duration(milliseconds: 30));
    if (Platform.isAndroid) {
      // copyAssets();
    }
  }

  void requestPermiss() async {
    checkPermission();
  }

  getPermission() {
    requestPermissions();
  }
      startRecord(Function(String p1,String p2) callBack) async {
    Vibration.vibrate(duration: 50);
    stopRecorder();

    try {
      requestPermiss();
      print('===>  获取了权限');
      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var voiceFilePath = '${tempDir.path}/s-$time${ext[Codec.aacADTS.index]}';
      print('===>  准备开始录音');
      await recorderModule.startRecorder(
        toFile: voiceFilePath,
        codec: Codec.aacADTS,
        bitRate: 8000,
        sampleRate: 8000,
      );
      String audioIconPath ="";
      /// 监听录音
      recorderSubscription = recorderModule.onProgress?.listen((e) {
        var volume = e.decibels;

        if (volume! <= 0) {
          audioIconPath = '';
        } else if (volume > 0 && volume < 30) {
          audioIconPath = 'audio_player_1';
        } else if (volume < 50) {
          audioIconPath = 'audio_player_2';
        } else if (volume < 100) {
          audioIconPath = 'audio_player_3';
        }

        callBack(voiceFilePath,audioIconPath);

      });
    } catch (err) {
      stopRecorder();
      cancelRecorderSubscriptions();
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
  /// 开始播放
   Future<void> startPlayer(String path,) async {
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
      playerSubscription = playerModule.onProgress?.listen((e) {});

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
  /// 判断文件是否存在
   Future<String> fileExists(String paths) async {
    if (paths.startsWith("http://localhost")) {
      //File f =   await _getLocalFile(path.basename(paths));
      return "";
    } else if (paths.startsWith("http")) {
      return paths;
    }

    return paths;
  }
}