import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teentalktalk/ui/screens/scrap/scrap.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';

void modalScrap(
  BuildContext context,
) {
  showDialog(
    useRootNavigator: true,
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black12,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SizedBox(
        height: 190.h,
        width: 300.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   '청소년 톡talk',
                //   style: TextStyle(
                //       color: Colors.green,
                //       fontFamily: 'CookieRun',
                //       fontWeight: FontWeight.w500),
                // ),
                InkWell(
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: ThemeColors.basic,
                  ),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
            // SizedBox(height: 10.0.h),
            Container(
                padding: EdgeInsets.all(10.h),
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: ThemeColors.primary,
                  size: 75,
                )),
            const TextCustom(
              text: '스크랩이 완료되었습니다!',
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 20.0.h),
            InkWell(
              onTap: () {
                // print('hh');
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScrapPage(),
                    ));
                // Navigator.pop(context);
              },
              child: Container(
                width: 200.w,
                alignment: Alignment.center,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: ThemeColors.primary,
                    borderRadius: BorderRadius.circular(20.0)),
                child: const TextCustom(
                  text: '내 스크랩 모아보기',
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
