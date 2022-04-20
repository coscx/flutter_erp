import 'package:flt_im_plugin/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/pages/peer_chat/widget/peer_chat_item.dart';
import 'package:flutter_erp/pages/peer_chat/widget/time_util.dart';
import 'package:flutter_erp/pages/peer_chat/widget/voice.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/DyBehaviorNull.dart';
import '../../conversion/widget/colors.dart';
import '../../conversion/widget/functions.dart';

class MessageListView extends StatefulWidget {
  final List<Message> messageList;
  final OnItemClick onResendClick;
  final OnItemClick onItemLongClick;
  final OnItemClick onItemClick;
  final VoidCallback bodyClick;
  final String tfSender;
  final ScrollController scrollController;
  final Voice voice;
  const MessageListView(
      {Key? key,
      required this.messageList,
      required this.onResendClick,
      required this.onItemLongClick,
      required this.onItemClick,
      required this.bodyClick,
      required this.tfSender,
      required this.scrollController, required this.voice})
      : super(key: key);

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  Map<String, GlobalKey<PeerChatItemWidgetState>> globalKeyMap = {};
  bool isLoading = false;
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (!mounted) {
        return;
      }
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent + 100.h) {
        if (isLoading) {
          return;
        }

        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }

        Future.delayed(const Duration(milliseconds: 150), () {
          onRefresh();
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    });
    super.initState();
  }

  Future<void> onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GestureDetector(
      child: _messageListView(context),
      onTap: () {
        widget.bodyClick();
      },
    ));
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
              String uuid = widget.messageList[index].content!['uUID'];
              if (index == widget.messageList.length - 1) {
                GlobalKey<PeerChatItemWidgetState> key = GlobalKey();
                globalKeyMap[uuid] = key;
                return Column(
                  children: <Widget>[
                    Visibility(
                      visible: !isLoading,
                      child:
                          _loadMoreWidget(widget.messageList.length % 20 == 0),
                    ),
                    _messageListViewItem(
                        key,
                        widget.messageList,
                        index,
                        widget.tfSender,
                        widget.onResendClick,
                        widget.onItemLongClick,
                        widget.onItemClick),
                  ],
                );
              } else {
                GlobalKey<PeerChatItemWidgetState> key = GlobalKey();
                globalKeyMap[uuid] = key;
                return Column(
                  children: <Widget>[
                    _messageListViewItem(
                        key,
                        widget.messageList,
                        index,
                        widget.tfSender,
                        widget.onResendClick,
                        widget.onItemLongClick,
                        widget.onItemClick),
                  ],
                );
              }
            },
            reverse: true,
            shrinkWrap: true,
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.messageList.length));
  }

  Widget _messageListViewItem(
      Key key,
      List<Message> messageList,
      int index,
      String tfSender,
      OnItemClick? onResendClick,
      OnItemClick? onItemLongClick,
      OnItemClick? onItemClick) {
    //list最后一条消息（时间上是最老的），是没有下一条了
    Message? _nextEntity =
        (index == messageList.length - 1) ? null : messageList[index + 1];
    Message _entity = messageList[index];
    return buildChatListItem(key, _nextEntity, _entity, tfSender,
        onResend: (reSendEntity) => onResendClick!(reSendEntity),
        onItemLongClick: (entity) {
          // _deletePeerMessage(context, entity);
        },
        onItemClick: (onClickEntity) {
          Message entity = _entity;
          if (entity.type == MessageType.MESSAGE_AUDIO) {
            //点击了语音
            if (_entity.playing == 1) {
              //正在播放，就停止播放
              widget.voice.stopPlayer();
              _entity.playing = 0;
              setState(() {});
            } else {
              for (Message other in widget.messageList) {
                other.playing = 0;
                //停止其他正在播放的
              }
              _entity.playing = 1;
              widget.voice.startPlayer(_entity.content!['url']);
              Future.delayed(
                  Duration(milliseconds: _entity.content!['duration'] * 1000),
                  () async {
                _entity.playing = 0;
                setState(() {});
                await widget.voice.stopPlayer();
              });
              setState(() {});
            }
          }
          onItemClick!(onClickEntity);
        });
  }

  Widget buildChatListItem(
      Key key, Message? nextEntity, Message entity, String tfSender,
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
                    style: const TextStyle(color: ColorT.transparent_80),
                  ))
              : const SizedBox(height: 0),
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
}
