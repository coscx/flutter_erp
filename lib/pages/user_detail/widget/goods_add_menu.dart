import 'package:flutter/material.dart';
import 'package:flutter_erp/common/entities/detail/user_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_dialog.dart';

class GoodsAddMenu extends StatefulWidget {
  final Info args;

  const GoodsAddMenu({
    required this.args,
  });

  @override
  _GoodsAddMenuState createState() => _GoodsAddMenuState();
}

class _GoodsAddMenuState extends State<GoodsAddMenu>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.white;
    const Color iconColor = Colors.black;

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 24.w),
          child: Image.asset(
            'assets/images/jt.png',
            width: 32.w,
            height: 16.h,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 240.w,
          height: 70.h,
          child: TextButton.icon(
            onPressed: () async {

              // var actionList =
              //     await IssuesApi.claimCustomer(widget.args['uuid']);
              // if (actionList['code'] == 200) {
              //   showToast(context, '认领成功', true);
              //
              //   Map<String, dynamic> photo = Map();
              //   photo['uuid'] = widget.args['uuid'];
              //   BlocProvider.of<DetailBloc>(context)
              //       .add(FetchWidgetDetailNoFresh(photo));
              // } else {
              //   showToastRed(context, actionList['message'], true);
              // }
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.assignment_ind_outlined,
              color: Colors.black,
            ),
            label: const Text('认领用户'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2?.color,
              onSurface: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
        //Container(width: 120.0, height: 0.6, color: Colors.black),
        SizedBox(
          width: 240.w,
          height: 70.h,
          child: TextButton.icon(
            onPressed: () {

              if (widget.args.roleId == 0) {
                showToastRed(context, "暂无权限", true);
                Navigator.of(context).pop();
                return;
              }
              if (widget.args.status < 0) {
                showToastRed(context, "当前用户状态需认领后再划分", true);
                Navigator.of(context).pop();
                return;
              }
              if (widget.args.status == 5) {
                if (widget.args.roleId!= 1) {
                  showToastRed(context, "暂无划分权限", true);
                  Navigator.of(context).pop();
                  return;
                }
              }

              if (widget.args.roleId > 3) {
                showToastRed(context, "暂无权限", true);
                Navigator.of(context).pop();
                return;
              }
              Navigator.of(context).pop();
              // Navigator.pushNamed(context, UnitRouter.erp_user,
              //         arguments: widget.args['uuid'])
              //     .then((value) {
              //   print(value);
              // });
            },
            icon: const Icon(
              Icons.add_to_drive,
              color: Colors.black,
            ),
            label: const Text('划分用户'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2?.color,
              onSurface: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0)),
              ),
            ),
          ),
        ),
        //Container(width: 120.0, height: 0.6, color: Colors.black),
        SizedBox(
          width: 240.w,
          height: 70.h,
          child: TextButton.icon(
            onPressed: () {

              Navigator.of(context).pop();
              if (widget.args.status != 0 &&
                  widget.args.status != 1 &&
                  widget.args.status!= 30) {
                showToastRed(context, "当前用户状态不可购买会员套餐", true);
                return;
              }
              // Navigator.pushNamed(context, UnitRouter.buy_vip,
              //         arguments: widget.args)
              //     .then((value) {
              //   print(value);
              // });
            },
            icon: const Icon(
              Icons.monetization_on,
              color: Colors.black,
            ),
            label: const Text('购买会员'),
            style: TextButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2?.color,
              onSurface: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.12),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation!,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation?.value,
          alignment: Alignment.topRight,
          child: child,
        );
      },
      child: body,
    );
  }
}
