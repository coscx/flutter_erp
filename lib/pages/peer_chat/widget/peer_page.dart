import 'package:flt_im_plugin/conversion.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_erp/pages/peer_chat/widget/chat_input_view.dart';
import 'package:flutter_erp/pages/peer_chat/widget/event_bus.dart';
import 'package:flutter_erp/pages/peer_chat/widget/voice.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'message_list_view.dart';

class PeerPage extends StatefulWidget {

  final List<Message> messageList;
  final Conversion model;
  final String memId;

  const PeerPage({
    required this.messageList,
    Key? key,
    required this.model,
    required this.memId,
  }) : super(key: key);

  @override
  _PeerPageState createState() => _PeerPageState();

}

class _PeerPageState extends State<PeerPage> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Voice.init();
    super.initState();
  }
  @override
  void dispose() {
   Voice.stopPlayer();
   Voice.stopRecorder();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              titleSpacing: 220.w,
              leadingWidth: 100.w,
              title: Row(
                children: [
                  Text(widget.model.cid,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              //leading:const Text('Demo',style: TextStyle(color: Colors.black, fontSize: 15)),
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              actions: <Widget>[
                Container(
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      //Navigator.pushNamed(context, UnitRouter.search);
                    },
                  ),
                ),
                SizedBox(width: 20.w),
              ],

              //bottom: bar(),
            ),
            body: Column(children: <Widget>[
              MessageListView(
                  messageList: widget.messageList,
                  onResendClick: (reSendEntity) {},
                  onItemClick: _onItemClick,
                  onItemLongClick: (entity) {},
                  bodyClick: () {
                    debugPrint("bodyClick");
                    //hideKeyBoard();
                    EventBusUtil.fire(PeerRecAckEvent(""));
                  },
                  tfSender: '',
                  scrollController: scrollController),
              Divider(height: 1.h),
              ChatInputView(
                model: widget.model,
                memId: widget.memId,
                scrollController: scrollController,
              )
            ])));
  }

  _onItemClick(_entity) {}
}
