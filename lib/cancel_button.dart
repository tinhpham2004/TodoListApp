import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list_app/values/colors.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 150.w,
        height: 70.h,
        decoration: BoxDecoration(
            color: AppColors.disabledBackground,
            borderRadius: BorderRadius.circular(40.sp)),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}