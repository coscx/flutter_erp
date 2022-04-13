import 'dart:async';
import 'dart:io';

import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/pages/peer_chat/widget/popupwindow_widget.dart';
import 'package:flutter_erp/pages/peer_chat/widget/voice.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:frefresh/frefresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';

import '../../../common/utils/permission.dart';
import '../../../common/widgets/delete_category_dialog.dart';
import '../../../common/widgets/more_widgets.dart';
import '../../conversion/widget/colors.dart';
import '../../conversion/widget/dialog_util.dart';
import '../../conversion/widget/object_util.dart';
import '../../user_detail/widget/bottom_dialog.dart';
import 'common_util.dart';
import 'event_bus.dart';
import 'file_util.dart';
import 'image_util.dart';

abstract class CounterController {
  Function increment();
  Function decrement();
}
class ChatInputView extends StatefulWidget {
  final Conversion model;
  final String memId;
  final ScrollController scrollController;
  const ChatInputView({Key? key, required this.model, required this.memId, required this.scrollController}) : super(key: key);
  @override
  _ChatInputViewState createState() => _ChatInputViewState();
}

class _ChatInputViewState extends State<ChatInputView> {
  FlutterSoundRecorder? recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer? playerModule = FlutterSoundPlayer();
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
  List<Widget> guideFaceList = [];
  List<Widget> guideFigureList = [];
  List<Widget> guideToolsList = [];
  bool isFaceFirstList = true;
  bool alive = false;
  String audioIconPath = '';
  String voiceFilePath = '';
  String tfSender = "0";
  FltImPlugin im = FltImPlugin();
  FRefreshController? controller3;
  Timer? timer;
  int voiceCount = 0;
  TextEditingController controller = TextEditingController();
  FocusNode textFieldNode = FocusNode();
  double progress = 0;
  StreamSubscription<PeerRecAckEvent>? peerAckSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alive = true;
    tfSender = widget.model.memId;
    controller3 = FRefreshController();
    textFieldNode.addListener(focusNodeListener); // 初始化一个listener
    getLocalMessage();
    initData();
    checkBlackList();
    recorderModule = Voice.recorderModule;
    playerModule = Voice.playerModule;
    peerAckSubscription = EventBusUtil.listen((event) {
      if (event is PeerRecAckEvent) {
        if (!mounted) return;
        print("event.uuid");
        listOnTap();
        hideKeyBoard();
        setState(() {

        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Container(
            height: 88.h,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: isShowVoice
                        ? const Icon(Icons.keyboard)
                        : const Icon(Icons.play_circle_outline),
                    iconSize: 55.sp,
                    onPressed: () {
                      hideKeyBoard();
                      inputLeftOnTap();
                      setState(() {});
                    }),
                Flexible(child: _enterWidget()),
                IconButton(
                    icon: isShowFace
                        ? const Icon(Icons.keyboard)
                        : const Icon(Icons.sentiment_very_satisfied),
                    iconSize: 55.sp,
                    onPressed: () {
                      hideKeyBoard();
                      inputRightFaceOnTap();
                      setState(() {});
                    }),
                isShowSend
                    ? GestureDetector(
                  onTap: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    _buildTextMessage(controller.text);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 90.w,
                    height: 32.h,
                    margin: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '发送',
                      style:
                      TextStyle(fontSize: 28.sp, color: Colors.red),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.w)),
                    ),
                  ),
                )
                    : IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 55.sp,
                    onPressed: () {
                      hideKeyBoard();
                      inputRightSendOnTap();
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
        (isShowTools || isShowFace || isShowVoice)
            ? Container(
          height: 418.h,
          child: _bottomWidget(context),
        )
            : const SizedBox(
          height: 0,
        )
      ],
    );
  }



  _deletePeerMessage(BuildContext context, Message entity) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Container(
                width: 50.w,
                child: DeleteCategoryDialog(
                  title: '撤回消息',
                  content: '是否确定继续执行?',
                  onSubmit: () {
                    FltImPlugin im = FltImPlugin();
                    if (Platform.isAndroid == true) {
                      //im.deletePeerMessage(id:entity.content['uUID']);

                    } else {
                      im.deletePeerMessage(id: entity.content['uuid']);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ));
  }

/*输入框*/
  _enterWidget() {
    return Material(
      borderRadius: BorderRadius.circular(12.w),
      shadowColor: ObjectUtil.getThemeLightColor(),
      color: ColorT.gray_f0,
      elevation: 0,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6.w)),
          constraints: BoxConstraints(minHeight: 60.h, maxHeight: 250.h),
          child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: textFieldNode,
              textInputAction: TextInputAction.send,
              controller: controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(150), //长度限制11
              ],
              //只能输入整数
              style: TextStyle(color: Colors.black, fontSize: 32.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.w),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
              ),
              onChanged: (str) {
                if (str.isNotEmpty) {
                  isShowSend = true;
                } else {
                  isShowSend = false;
                }
                setState(() {});
              },
              onEditingComplete: () {
                if (controller.text.isEmpty) {
                  return;
                }
                _buildTextMessage(controller.text);
              })),
    );
  }

  _buildTextMessage(String content) {
    controller.clear();
    isShowSend = false;
  }

  _bottomWidget(BuildContext context) {
    late Widget widget;
    if (isShowTools) {
      widget = _toolsWidget(context);
    } else if (isShowFace) {
      widget = _faceWidget();
    } else if (isShowVoice) {
      widget = _voiceWidget();
    }
    return widget;
  }

  _toolsWidget(BuildContext context) {
    if (guideToolsList.isNotEmpty) {
      guideToolsList.clear();
    }
    List<Widget> _widgets = [];
    _widgets.add(MoreWidgets.buildIcon(Icons.insert_photo, '相册',
        o: (res) => ImageUtil.getGalleryImage().then((imageFile) {
              //相册取图片
              _willBuildImageMessage(imageFile);
            })));
    _widgets.add(MoreWidgets.buildIcon(Icons.camera_alt, '拍摄',
        o: (res) => PopupWindowUtil.showCameraChosen(context,
                onCallBack: (type, file) async {
              if (type == 1) {
                //相机取图片
                _willBuildImageMessage(file as File);
              } else if (type == 2) {
                //相机拍视频
                _buildVideoMessage(file as Map<String, dynamic>);
              }
            })));
    _widgets.add(MoreWidgets.buildIcon(Icons.videocam, '在线通话',
        o: (res) => showDialog(
            barrierDismissible: true, //是否点击空白区域关闭对话框,默认为true，可以关闭
            context: context,
            builder: (BuildContext context) {
              var list = [];
              list.add('语音聊天');
              list.add('视频聊天');
              return BottomSheetWidget(
                list: list,
                onItemClickListener: (index) async {
                  if (index == 0) {
                    im.voiceCall(widget.model.cid);
                    Navigator.pop(context);
                  }
                  if (index == 1) {
                    FltImPlugin im = FltImPlugin();
                    im.videoCall(widget.model.cid);
                    Navigator.pop(context);
                  }
                },
              );
            })));
    // _widgets.add(MoreWidgets.buildIcon(Icons.location_on, '位置'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.view_agenda, '红包'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.swap_horiz, '转账'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.mic, '语音输入'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.favorite, '我的收藏'));
    guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(10.w), children: _widgets));
    List<Widget> _widgets1 = [];
    // _widgets1.add(MoreWidgets.buildIcon(Icons.person, '名片'));
    // _widgets1.add(MoreWidgets.buildIcon(Icons.folder, '文件'));
    guideToolsList.add(GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(0.0),
        children: _widgets1));
    // return Swiper(
    //     autoStart: false,
    //     circular: false,
    //     indicator: CircleSwiperIndicator(
    //         radius: 3.0,
    //         padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
    //         itemColor: ColorT.gray_99,
    //         itemActiveColor: ObjectUtil.getThemeSwatchColor()),
    //     children: guideToolsList);
  }

  _faceWidget() {
    _initFaceList();
    return Column(
      children: <Widget>[
        Flexible(
            child: Stack(
          children: <Widget>[
            // Offstage(
            //   offstage: isFaceFirstList,
            //   child: Swiper(
            //       autoStart: false,
            //       circular: false,
            //       indicator: CircleSwiperIndicator(
            //           radius: 3.0,
            //           padding: EdgeInsets.only(top: 10.w),
            //           itemColor: ColorT.gray_99,
            //           itemActiveColor: ObjectUtil.getThemeSwatchColor()),
            //       children: guideFigureList),
            // ),
            // Offstage(
            //   offstage: !isFaceFirstList,
            //   child: EmojiPicker(
            //     rows: 3,
            //     columns: 7,
            //     //recommendKeywords: ["racing", "horse"],
            //     numRecommended: 10,
            //     onEmojiSelected: (emoji, category) {
            //       controller.text =controller.text + emoji.emoji;
            //       controller.selection = TextSelection.fromPosition(
            //           TextPosition(offset: controller.text.length));
            //
            //       if (isShowSend == false) {
            //
            //           if (controller.text.isNotEmpty) {
            //             isShowSend = true;
            //           } else {
            //             isShowSend = false;
            //           }
            //
            //       }
            //     },
            //   ),
            // )
          ],
        )),
        SizedBox(
          height: 4.h,
        ),
        Divider(height: 2.h),
        Container(
          height: 48.h,
          child: Row(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: InkWell(
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          color: isFaceFirstList
                              ? ObjectUtil.getThemeSwatchColor()
                              : headsetColor,
                          size: 48.sp,
                        ),
                        onTap: () {
                          isFaceFirstList = true;
                        },
                      ))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: InkWell(
                        child: Icon(
                          Icons.favorite_border,
                          color: isFaceFirstList
                              ? headsetColor
                              : ObjectUtil.getThemeSwatchColor(),
                          size: 48.sp,
                        ),
                        onTap: () {
                          isFaceFirstList = false;
                        },
                      ))),
            ],
          ),
        )
      ],
    );
  }

  _voiceWidget() {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: EdgeInsets.all(20.w),
                child: Icon(
                  Icons.headset,
                  color: headsetColor,
                  size: 80.sp,
                ))),
        Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 10.h),
                        child: audioIconPath == ''
                            ? SizedBox(
                                width: 60.w,
                                height: 60.h,
                              )
                            : Image.asset(
                                FileUtil.getImagePath(audioIconPath,
                                    dir: 'icon', format: 'png'),
                                width: 60.w,
                                height: 60.h,
                                color: ObjectUtil.getThemeSwatchColor(),
                              )),
                    Container(
                        padding: EdgeInsets.only(right: 50.h),
                        child: Text(voiceCount.toString() + "S"))
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(10.w),
                    child: GestureDetector(
                      onScaleStart: (res) async {
                        if (timer != null) {
                          timer?.cancel();
                          timer = Timer.periodic(
                              const Duration(milliseconds: 1000), (t) {
                            //print(voiceCount);

                            voiceCount = voiceCount + 1;
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        } else {
                          timer = Timer.periodic(
                              const Duration(milliseconds: 1000), (t) {
                            //print(voiceCount);

                            voiceCount = voiceCount + 1;
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        }

                        if (recorderModule!.isRecording) {
                          await stopRecorder();
                        }
                        startRecord();
                      },
                      onScaleEnd: (res) async {
                        if (headsetColor == ObjectUtil.getThemeLightColor()) {
                          DialogUtil.buildToast('试听功能暂未实现');
                          if (recorderModule!.isRecording) {
                            stopRecorder();
                          }
                        } else if (highlightColor ==
                            ObjectUtil.getThemeLightColor()) {
                          File file = File(voiceFilePath);
                          file.delete();
                          if (recorderModule!.isRecording) {
                            stopRecorder();
                          }
                        } else {
                          if (recorderModule!.isRecording) {
                            stopRecorder();
                            if (voiceCount < 1) {
                              DialogUtil.buildToast('你说话..时间太短啦~');

                            }else{
                              var length =
                              await CommonUtil.getDuration(voiceFilePath);
                              File file = File(voiceFilePath);
                              if (length * 1000 < 1000) {
                                //小于1s不发送
                                file.delete();
                                DialogUtil.buildToast('你说话..时间太短啦~');
                              } else {
                                Future.delayed(const Duration(milliseconds: 500),
                                        () {
                                      //发送语音
                                      _buildVoiceMessage(file, length.floor());
                                    });
                              }
                              voiceCount = 0;
                              timer?.cancel();
                            }

                          }
                        }

                        audioIconPath = '';
                        voiceText = '按住 说话';
                        voiceBackground = ObjectUtil.getThemeLightColor();
                        headsetColor = ColorT.gray_99;
                        highlightColor = ColorT.gray_99;
                        voiceCount = 0;
                        timer?.cancel();
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      onScaleUpdate: (res) {
                        if (res.focalPoint.dy > 550.h &&
                            res.focalPoint.dy < 620.h) {
                          if (res.focalPoint.dx > 10.w &&
                              res.focalPoint.dx < 80.w) {
                            voiceText = '松开 试听';
                            headsetColor = ObjectUtil.getThemeLightColor();
                          } else if (res.focalPoint.dx > 330.w &&
                              res.focalPoint.dx < 400.w) {
                            voiceText = '松开 删除';
                            highlightColor = ObjectUtil.getThemeLightColor();
                          } else {
                            voiceText = '松开 结束';
                            headsetColor = ColorT.gray_99;
                            highlightColor = ColorT.gray_99;
                          }
                        } else {
                          voiceText = '松开 结束';
                          headsetColor = ColorT.gray_99;
                          highlightColor = ColorT.gray_99;
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: CircleAvatar(
                        child: Text(
                          voiceText,
                          style:
                              TextStyle(fontSize: 30.sp, color: ColorT.gray_33),
                        ),
                        radius: 120.w,
                        backgroundColor: voiceBackground,
                      ),
                    ))
              ],
            )),
        Align(
            alignment: Alignment.centerRight,
            child: Container(
                padding: EdgeInsets.all(20.w),
                child: Icon(
                  Icons.highlight_off,
                  color: highlightColor,
                  size: 80.sp,
                ))),
      ],
    );
  }

  _gridView(int crossAxisCount, List<String> list) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(0.0),
        children: list.map((String name) {
          return IconButton(
              onPressed: () {
                if (name.contains('face_delete')) {
                  DialogUtil.buildToast('暂时不会把自定义表情显示在TextField，谁会的教我~');
                } else {
                  //表情因为取的是assets里的图，所以当初文本发送
                  _buildTextMessage(name);
                }
                setState(() {});
              },
              icon: Image.asset(name,
                  width: crossAxisCount == 5 ? 60.w : 32.w,
                  height: crossAxisCount == 5 ? 60.h : 32.h));
        }).toList());
  }

  //重发
  _onResend(Message entity) {}

  _willBuildImageMessage(File imageFile) {
    if (imageFile.path.isEmpty) {
      return;
    }
    _buildImageMessage(imageFile, false);
    return;
  }

  _buildImageMessage(File file, bool sendOriginalImage) {
    file.readAsBytes().then((content) => {});
    isShowTools = false;
    controller.clear();
  }

  _buildVoiceMessage(File file, int length) {
    controller.clear();
  }

  _buildVideoMessage(Map file) {
    controller.clear();
  }

  void updateData(Message entity) {}

  _initFaceList() {
    if (guideFaceList.isNotEmpty) {
      guideFaceList.clear();
    }
    if (guideFigureList.isNotEmpty) {
      guideFigureList.clear();
    }
    //添加表情图
    List<String> _faceList = [];
    String faceDeletePath =
        FileUtil.getImagePath('face_delete', dir: 'face', format: 'png');
    String facePath;
    for (int i = 0; i < 100; i++) {
      if (i < 90) {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'gif');
      } else {
        facePath =
            FileUtil.getImagePath(i.toString(), dir: 'face', format: 'png');
      }
      _faceList.add(facePath);
      if (i == 19 || i == 39 || i == 59 || i == 79 || i == 99) {
        _faceList.add(faceDeletePath);
        guideFaceList.add(_gridView(7, _faceList));
        _faceList.clear();
      }
    }
    //添加斗图
    List<String> _figureList = [];
    for (int i = 0; i < 96; i++) {
      if (i == 70 || i == 74) {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'png');
        _figureList.add(facePath);
      } else {
        String facePath =
            FileUtil.getImagePath(i.toString(), dir: 'figure', format: 'gif');
        _figureList.add(facePath);
      }
      if (i == 9 ||
          i == 19 ||
          i == 29 ||
          i == 39 ||
          i == 49 ||
          i == 59 ||
          i == 69 ||
          i == 79 ||
          i == 89 ||
          i == 95) {
        guideFigureList.add(_gridView(5, _figureList));
        _figureList.clear();
      }
    }
  }



  void hideKeyBoard() {
    textFieldNode.unfocus();
  }

  void listOnTap() {
    if (isShowVoice == true || isShowFace == true || isShowTools == true) {
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







  Future<void> focusNodeListener() async {
    if (textFieldNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 5), () {
        setState(() {
          isShowTools = false;
          isShowFace = false;
          isShowVoice = false;
          try {
            if (mounted) widget.scrollController.position.jumpTo(0);
          } catch (e) {}
        });
      });
    }
  }

  startRecord() async {
    voiceText = '松开 结束';
    voiceBackground = ColorT.divider;
    Voice.startRecord((p1,p2){
       voiceFilePath =p1;
       audioIconPath =p2;
    });
    setState(() {});
  }
  stopRecorder(){
    Voice.stopRecorder();
  }
  getLocalMessage() async {}

  initData() {
    popString.add('清空记录');
    popString.add('删除好友');
    popString.add('加入黑名单');
  }

  checkBlackList() {}

}
