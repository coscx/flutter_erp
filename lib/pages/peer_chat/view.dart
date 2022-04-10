import 'dart:async';
import 'dart:io';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/common/widgets/app.dart';
import 'package:flutter_erp/pages/peer_chat/widget/common_util.dart';
import 'package:flutter_erp/pages/peer_chat/widget/file_util.dart';
import 'package:flutter_erp/pages/peer_chat/widget/image_util.dart';
import 'package:flutter_erp/pages/peer_chat/widget/more_widgets.dart';
import 'package:flutter_erp/pages/peer_chat/widget/peer_chat_item.dart';
import 'package:flutter_erp/pages/peer_chat/widget/popupwindow_widget.dart';
import 'package:flutter_erp/pages/peer_chat/widget/time_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/widgets/DyBehaviorNull.dart';
import '../../common/widgets/delete_category_dialog.dart';
import '../conversion/widget/colors.dart';
import '../conversion/widget/dialog_util.dart';
import '../conversion/widget/functions.dart';
import '../conversion/widget/object_util.dart';
import 'logic.dart';

class PeerChatPage extends StatelessWidget {
  final logic = Get.find<PeerChatLogic>();
  final state = Get.find<PeerChatLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: transparentAppBar(), body: _body(context));
  }

  _body(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: GestureDetector(
        child: _messageListView(context),
        onTap: () {
          logic.hideKeyBoard();
          logic.listOnTap();
        },
      )),
      Divider(height: 1.h),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Container(
          height: 88.h,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: logic.isShowVoice
                      ? const Icon(Icons.keyboard)
                      : const Icon(Icons.play_circle_outline),
                  iconSize: 55.sp,
                  onPressed: () {
                    logic.hideKeyBoard();
                    logic.inputLeftOnTap();
                  }),
              Flexible(child: _enterWidget()),
              IconButton(
                  icon: logic.isShowFace
                      ? const Icon(Icons.keyboard)
                      : const Icon(Icons.sentiment_very_satisfied),
                  iconSize: 55.sp,
                  onPressed: () {
                    logic.hideKeyBoard();
                    logic.inputRightFaceOnTap();
                  }),
              logic.isShowSend
                  ? GestureDetector(
                      onTap: () {
                        if (logic.controller.text.isEmpty) {
                          return;
                        }
                        _buildTextMessage(logic.controller.text);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 90.w,
                        height: 32.h,
                        margin: EdgeInsets.only(right: 8.w),
                        child: Text(
                          '发送',
                          style: TextStyle(fontSize: 28.sp, color: Colors.red),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.w)),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 55.sp,
                      onPressed: () {
                        logic.hideKeyBoard();
                        logic.inputRightSendOnTap();
                      }),
            ],
          ),
        ),
      ),
      (logic.isShowTools || logic.isShowFace || logic.isShowVoice)
          ? Container(
              height: 418.h,
              child: _bottomWidget(context),
            )
          : const SizedBox(
              height: 0,
            )
    ]);
  }

  _messageListView(BuildContext context) {
    return Container(
        color: ColorT.gray_f0,
        child: Column(
          //如果只有一条数据，listView的高度由内容决定了，所以要加列，让listView看起来是满屏的
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 0, bottom: 0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              ],
            ),
            Flexible(
                //外层是Column，所以在Column和ListView之间需要有个灵活变动的控件
                child: _buildContent(context))
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return ScrollConfiguration(
        behavior: DyBehaviorNull(),
        child: ListView.builder(
            padding:
                EdgeInsets.only(left: 10.w, right: 10.w, top: 0, bottom: 0),
            itemBuilder: (BuildContext context, int index) {
              String uuid = state.messageList[index].content['uUID'];
              if (index == state.messageList.length - 1) {
                GlobalKey<PeerChatItemWidgetState> key = GlobalKey();
                logic.globalKeyMap[uuid] = key;
                return Column(
                  children: <Widget>[
                    Visibility(
                      visible: !logic.isLoading,
                      child:
                          _loadMoreWidget(state.messageList.length % 20 == 0),
                    ),
                    _messageListViewItem(
                        key, state.messageList, index, logic.tfSender),
                  ],
                );
              } else {
                GlobalKey<PeerChatItemWidgetState> key = GlobalKey();
                logic.globalKeyMap[uuid] = key;
                return Column(
                  children: <Widget>[
                    _messageListViewItem(
                        key, state.messageList, index, logic.tfSender),
                  ],
                );
              }
            },
            //倒置过来的ListView，这样数据多的时候也会显示“底部”（其实是顶部），
            //因为正常的listView数据多的时候，没有办法显示在顶部最后一条
            reverse: true,
            //如果只有一条数据，因为倒置了，数据会显示在最下面，上面有一块空白，
            //所以应该让listView高度由内容决定
            shrinkWrap: true,
            controller: logic.scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: state.messageList.length));
  }

  //加载中的圈圈
  Widget _loadMoreWidget(bool haveMore) {
    if (haveMore) {
      return Container();
    } else {
      //当没有更多数据可以加载的时候，
      return Center(
        child: Text(
          "没有更多数据了",
          style: TextStyle(color: Colors.black54, fontSize: 26.sp),
        ),
      );
    }
  }

  Widget _messageListViewItem(
      Key key, List<Message> messageList, int index, String tfSender) {
    //list最后一条消息（时间上是最老的），是没有下一条了
    Message _nextEntity =
        (index == messageList.length - 1) ? messageList[0] : messageList[index + 1];
    Message _entity = messageList[index];
    return buildChatListItem(key, _nextEntity, _entity, tfSender,
        onResend: (reSendEntity) {
              _onResend(reSendEntity as Message);
         },

        onItemLongClick: (entity) {
      DialogUtil.buildToast('长按了消息');
     // _deletePeerMessage(context, entity);
    }, onItemClick: (onClickEntity) async {
      Message entity = onClickEntity as Message;
      if (entity.type == MessageType.MESSAGE_AUDIO) {
        //点击了语音
        if (_entity.playing == 1) {
          //正在播放，就停止播放
          await logic.stopPlayer();
          _entity.playing = 0;
        } else {
            for (Message other in messageList) {
              other.playing = 0;
              //停止其他正在播放的
            }
          _entity.playing = 1;
          await logic.startPlayer(_entity.content['url']);
          Future.delayed(
              Duration(milliseconds: _entity.content['duration'] * 1000),
              () async {
            if (logic.alive) {

                _entity.playing = 0;

              await logic.stopPlayer();
            }
          });
        }
      }
    });
  }

  _deletePeerMessage(BuildContext context, Message entity) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
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

  Widget buildChatListItem(
      Key key, Message nextEntity, Message entity, String tfSender,
      {OnItemClick? onResend,
        OnItemClick? onItemClick,
        OnItemClick? onItemLongClick}) {
    bool _isShowTime = true;
    var showTime; //最终显示的时间
    if (null == nextEntity) {
      //_isShowTime = true;
    } else {
      //如果当前消息的时间和上条消息的时间相差，大于3分钟，则要显示当前消息的时间，否则不显示
      if ((entity.timestamp * 1000 - nextEntity.timestamp * 1000).abs() >
          3 * 60 * 1000) {
        _isShowTime = true;
      } else {
        _isShowTime = false;
      }
    }
    showTime = TimeUtil.chatTimeFormat(entity.timestamp);

    return Container(
      child: Column(
        children: <Widget>[
          _isShowTime
              ? Center(
              heightFactor: 2,
              child: Text(
                showTime,
                style: TextStyle(color: ColorT.transparent_80),
              ))
              : SizedBox(height: 0),
          PeerChatItemWidget(
              entity: entity,
              onResend: onResend!,
              onItemClick: onItemClick!,
              onItemLongClick: onItemLongClick!,
              tfSender: tfSender)
        ],
      ),
    );
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
              focusNode: logic.textFieldNode,
              textInputAction: TextInputAction.send,
              controller: logic.controller,
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
                    logic.isShowSend = true;
                  } else {
                    logic.isShowSend = false;
                  }

              },
              onEditingComplete: () {
                if (logic.controller.text.isEmpty) {
                  return;
                }
                _buildTextMessage(logic.controller.text);
              })),
    );
  }
  _buildTextMessage(String content) {

    logic.controller.clear();
    logic.isShowSend = false;
  }
  _bottomWidget(BuildContext context) {
    late Widget widget;
    if (logic.isShowTools) {
      widget = _toolsWidget(context);
    } else if (logic.isShowFace) {
      widget = _faceWidget();
    } else if (logic.isShowVoice) {
      widget = _voiceWidget();
    }
    return widget;
  }
  _toolsWidget(BuildContext context) {
    if (logic.guideToolsList.isNotEmpty) {
      logic.guideToolsList.clear();
    }
    List<Widget> _widgets =[];
    _widgets.add(MoreWidgets.buildIcon(Icons.insert_photo, '相册', o: (res) => ImageUtil.getGalleryImage().then((imageFile) {
      //相册取图片
      _willBuildImageMessage(imageFile);
    })));
    _widgets.add(MoreWidgets.buildIcon(Icons.camera_alt, '拍摄', o: (res) => PopupWindowUtil.showCameraChosen(context, onCallBack: (type, file) async {
      if (type == 1) {
        //相机取图片
        _willBuildImageMessage(file as File);
      } else if (type == 2) {
        //相机拍视频
        _buildVideoMessage(file as Map<String,dynamic>);
      }
    })));
    // _widgets.add(MoreWidgets.buildIcon(Icons.videocam, '在线通话',
    //     o: (res) => showDialog(
    //         barrierDismissible: true, //是否点击空白区域关闭对话框,默认为true，可以关闭
    //         context: context,
    //         builder: (BuildContext context) {
    //           var list = [];
    //           list.add('语音聊天');
    //           list.add('视频聊天');
    //           return BottomSheetWidget(
    //             list: list,
    //             onItemClickListener: (index) async {
    //               if (index == 0) {
    //                 im.voiceCall(widget.model.cid);
    //                 Navigator.pop(context);
    //               }
    //               if (index == 1) {
    //                 FltImPlugin im = FltImPlugin();
    //                 im.videoCall(widget.model.cid);
    //                 Navigator.pop(context);
    //               }
    //             },
    //           );
    //         })));
    // _widgets.add(MoreWidgets.buildIcon(Icons.location_on, '位置'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.view_agenda, '红包'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.swap_horiz, '转账'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.mic, '语音输入'));
    // _widgets.add(MoreWidgets.buildIcon(Icons.favorite, '我的收藏'));
    logic.guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: EdgeInsets.all(10.w), children: _widgets));
    List<Widget> _widgets1 = [];
    // _widgets1.add(MoreWidgets.buildIcon(Icons.person, '名片'));
    // _widgets1.add(MoreWidgets.buildIcon(Icons.folder, '文件'));
    logic.guideToolsList.add(GridView.count(
        crossAxisCount: 4, padding: const EdgeInsets.all(0.0), children: _widgets1));
    // return Swiper(
    //     autoStart: false,
    //     circular: false,
    //     indicator: CircleSwiperIndicator(
    //         radius: 3.0,
    //         padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
    //         itemColor: ColorT.gray_99,
    //         itemActiveColor: ObjectUtil.getThemeSwatchColor()),
    //     children: logic.guideToolsList);
  }
  _faceWidget() {
    _initFaceList();
    return Column(
      children: <Widget>[
        Flexible(
            child: Stack(
              children: <Widget>[
                // Offstage(
                //   offstage: logic.isFaceFirstList,
                //   child: Swiper(
                //       autoStart: false,
                //       circular: false,
                //       indicator: CircleSwiperIndicator(
                //           radius: 3.0,
                //           padding: EdgeInsets.only(top: 10.w),
                //           itemColor: ColorT.gray_99,
                //           itemActiveColor: ObjectUtil.getThemeSwatchColor()),
                //       children: logic.guideFigureList),
                // ),
                // Offstage(
                //   offstage: !logic.isFaceFirstList,
                //   child: EmojiPicker(
                //     rows: 3,
                //     columns: 7,
                //     //recommendKeywords: ["racing", "horse"],
                //     numRecommended: 10,
                //     onEmojiSelected: (emoji, category) {
                //       logic.controller.text =logic.controller.text + emoji.emoji;
                //       logic.controller.selection = TextSelection.fromPosition(
                //           TextPosition(offset: logic.controller.text.length));
                //
                //       if (logic.isShowSend == false) {
                //
                //           if (logic.controller.text.isNotEmpty) {
                //             logic.isShowSend = true;
                //           } else {
                //             logic.isShowSend = false;
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
        new Divider(height: 2.h),
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
                          color: logic.isFaceFirstList
                              ? ObjectUtil.getThemeSwatchColor()
                              :logic.headsetColor,
                          size: 48.sp,
                        ),
                        onTap: () {

                            logic.isFaceFirstList = true;

                        },
                      ))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: 20.w),
                      child: InkWell(
                        child: Icon(
                          Icons.favorite_border,
                          color: logic.isFaceFirstList
                              ? logic.headsetColor
                              : ObjectUtil.getThemeSwatchColor(),
                          size: 48.sp,
                        ),
                        onTap: () {

                            logic.isFaceFirstList = false;

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
                  color:logic.headsetColor,
                  size: 80.sp,
                ))),
        Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 10.h),
                        child: logic.audioIconPath == ''
                            ? SizedBox(
                          width: 60.w,
                          height: 60.h,
                        )
                            : Image.asset(
                          FileUtil.getImagePath(logic.audioIconPath,
                              dir: 'icon', format: 'png'),
                          width: 60.w,
                          height: 60.h,
                          color: ObjectUtil.getThemeSwatchColor(),
                        )),
                    Text(logic.voiceCount.toString() + "S")
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(10.w),
                    child: GestureDetector(
                      onScaleStart: (res) async {
                        if (logic.timer != null) {
                          logic.timer.cancel();
                          logic.timer =
                              Timer.periodic(Duration(milliseconds: 1000), (t) {
                                //print(voiceCount);

                                  logic.voiceCount = logic.voiceCount + 1;

                              });
                        } else {
                          logic.timer =
                              Timer.periodic(Duration(milliseconds: 1000), (t) {
                                //print(voiceCount);

                                  logic.voiceCount = logic.voiceCount + 1;

                              });
                        }

                        if (logic.recorderModule.isRecording) {
                          await logic.stopRecorder();
                        }
                        logic.startRecord();
                      },
                      onScaleEnd: (res) async {
                        if (logic.headsetColor == ObjectUtil.getThemeLightColor()) {
                          DialogUtil.buildToast('试听功能暂未实现');
                          if (logic.recorderModule.isRecording) {
                            logic.stopRecorder();
                          }
                        } else if (logic.highlightColor ==
                            ObjectUtil.getThemeLightColor()) {
                          File file = File(logic.voiceFilePath);
                          file.delete();
                          if (logic.recorderModule.isRecording) {
                            logic.stopRecorder();
                          }
                        } else {
                          if (logic.recorderModule.isRecording) {
                            logic.stopRecorder();
                            var length =
                            await CommonUtil.getDuration(logic.voiceFilePath);
                            File file = File(logic.voiceFilePath);
                            if (length * 1000 < 1000) {
                              //小于1s不发送
                              file.delete();
                              DialogUtil.buildToast('你说话时间太短啦~');
                            } else {
                              Future.delayed(const Duration(milliseconds: 500),
                                      () {
                                    //发送语音
                                    _buildVoiceMessage(file, length.floor());
                                  });
                            }
                            logic.voiceCount = 0;
                            logic.timer.cancel();
                          }
                        }

                          logic.audioIconPath = '';
                          logic.voiceText = '按住 说话';
                          logic.voiceBackground = ObjectUtil.getThemeLightColor();
                          logic.headsetColor = ColorT.gray_99;
                          logic.highlightColor = ColorT.gray_99;

                      },
                      onScaleUpdate: (res) {
                        if (res.focalPoint.dy > 550.h &&
                            res.focalPoint.dy < 620.h) {
                          if (res.focalPoint.dx > 10.w &&
                              res.focalPoint.dx < 80.w) {

                              logic.voiceText = '松开 试听';
                              logic.headsetColor = ObjectUtil.getThemeLightColor();

                          } else if (res.focalPoint.dx > 330.w &&
                              res.focalPoint.dx < 400.w) {

                              logic.voiceText = '松开 删除';
                              logic.highlightColor = ObjectUtil.getThemeLightColor();

                          } else {

                            logic.voiceText = '松开 结束';
                            logic.headsetColor = ColorT.gray_99;
                            logic.highlightColor = ColorT.gray_99;

                          }
                        } else {

                            logic.voiceText = '松开 结束';
                            logic.headsetColor = ColorT.gray_99;
                            logic.highlightColor = ColorT.gray_99;

                        }
                      },
                      child: new CircleAvatar(
                        child: new Text(
                          logic.voiceText,
                          style: new TextStyle(
                              fontSize: 30.sp, color: ColorT.gray_33),
                        ),
                        radius: 120.w,
                        backgroundColor: logic.voiceBackground,
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
                  color: logic.highlightColor,
                  size: 80.sp,
                ))),
      ],
    );
  }
  _gridView(int crossAxisCount, List<String> list) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.all(0.0),
        children: list.map((String name) {
          return IconButton(
              onPressed: () {
                if (name.contains('face_delete')) {
                  DialogUtil.buildToast('暂时不会把自定义表情显示在TextField，谁会的教我~');
                } else {
                  //表情因为取的是assets里的图，所以当初文本发送
                  _buildTextMessage(name);
                }
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
    logic.isShowTools = false;
    logic.controller.clear();
  }

  _buildVoiceMessage(File file, int length) {

    logic.controller.clear();
  }

  _buildVideoMessage(Map file) {

    logic.controller.clear();

  }

  void updateData(Message entity) {

  }
  _initFaceList() {
    if (logic.guideFaceList.isNotEmpty) {
      logic.guideFaceList.clear();
    }
    if (logic.guideFigureList.isNotEmpty) {
      logic.guideFigureList.clear();
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
        logic.guideFaceList.add(_gridView(7, _faceList));
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
        logic.guideFigureList.add(_gridView(5, _figureList));
        _figureList.clear();
      }
    }
  }

}
