import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'doodle.dart';

class TimeLinePage extends StatefulWidget {
  @override
  createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage>
    with SingleTickerProviderStateMixin {
  final PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int pageIx = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
      timelineModel(TimelinePosition.Center),
      timelineModel(TimelinePosition.Right)
    ];

    return Scaffold(
      appBar: AppBar(title: Text('TimeLine')),
      body: PageView(
          onPageChanged: (i) => setState(() => pageIx = i),
          controller: pageController,
          children: pages),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: doodles.length,
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          color: doodle.color.withOpacity(doodle.opacity),
          margin: EdgeInsets.symmetric(vertical: 16.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.w)),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Stack(children: [
            Container(

           decoration: doodle.current ==1 ? BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2.w,
                ),
              ):null,
              width: ScreenUtil().screenWidth,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8.h),
                      Text(doodle.name,
                          style: textTheme.subtitle1,
                          textAlign: TextAlign.left),
                      SizedBox(height: 8.h),
                      Text(doodle.status, style: textTheme.caption),
                      SizedBox(height: 8.h),
                      Container(
                          padding: EdgeInsets.all(12.w),
                          color: Color(0xFFF4F5F8),
                          child: Text(doodle.content,
                              style: textTheme.subtitle1,
                              textAlign: TextAlign.left)),
                      SizedBox(height: 8.h),
                      Text(doodle.time, style: textTheme.caption),
                      SizedBox(height: 8.h),
                    ],
                  )),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: doodle.flag != ""
                    ? Container(
                        width: 120.w,
                        child: Image.asset(doodle.flag),
                      )
                    : Container())
          ]),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
