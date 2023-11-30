import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:teentalktalk/domain/models/response/response_event.dart';
import 'package:teentalktalk/domain/models/response/response_event.dart';
import 'package:teentalktalk/domain/services/code_service.dart';
import 'package:teentalktalk/ui/helpers/helpers.dart';
import 'package:teentalktalk/ui/screens/user/myTalkTalk_page.dart';
import 'package:teentalktalk/ui/screens/user/my_fig_history_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

void modalEventParticipation(
    BuildContext context, String message, String? link) {
  showDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SizedBox(
        height: 220.h,
        width: 300.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: ThemeColors.basic,
                    ),
                    onTap: () => Navigator.pop(context))
              ],
            ),
            // SizedBox(height: 10.0.h),
            Text(
              message,
              style: TextStyle(
                  color: ThemeColors.primary,
                  fontFamily: 'CookieRun',
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5.0.h),
            // TextCustom(
            //   text: message,
            //   fontWeight: FontWeight.bold,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.h),
                  child: Image.asset(
                    'images/aco4.png',
                    width: 100.w,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30.h),
                  child: TextCustom(
                    text: '만족도조사까지\n참여해야\n상품을 받을 수 있어요!',
                    fontSize: 12.sp,
                    maxLines: 3,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                launchUrl(
                  Uri.parse(link ?? ''),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Container(
                width: 200.w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: ThemeColors.fig_green,
                    borderRadius: BorderRadius.circular(20.0)),
                child: const TextCustom(
                  text: '만족도조사 하러가기',
                  color: ThemeColors.basic,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
