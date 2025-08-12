import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class ReferralResultDialog extends StatefulWidget {
  final bool isSuccess;
  final String? userName; // For failed case: "Referred by user_name."

  const ReferralResultDialog({
    super.key,
    required this.isSuccess,
    this.userName,
  });

  @override
  State<ReferralResultDialog> createState() => _ReferralResultDialogState();
}

class _ReferralResultDialogState extends State<ReferralResultDialog> {
  @override
  void initState() {
    super.initState();
    print('ReferralResultDialog initState - isSuccess: ${widget.isSuccess}');
    // Auto close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        print('Auto closing result dialog');
        Get.back();
      }
    });
  }

  Widget _buildIcon() {
    print('Building icon - isSuccess: ${widget.isSuccess}');

    return SizedBox(
      width: 76.sp,
      height: 79.sp,
      child: widget.isSuccess ? iconReferralSuccess : iconReferralFail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.sp),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: EdgeInsets.all(32.sp),
          decoration: BoxDecoration(
            color: subBg01Color,
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon - SVG with fallback
              _buildIcon(),

              SizedBox(height: 24.sp),

              // Title
              StyledText(
                widget.isSuccess ? 'Success!' : 'Oops!',
                fontSize: 28,
                fontWeight: 700,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.sp),

              // Message
              StyledText(
                widget.isSuccess
                    ? 'You\'ve successfully redeemed\nthe code!'
                    : widget.userName != null
                        ? 'Referred by ${widget.userName}.'
                        : 'Invalid referral code.',
                fontSize: 16,
                fontWeight: 400,
                color: lightGrayColor,
                textAlign: TextAlign.center,
                lineHeight: 20,
              ),

              SizedBox(height: 32.sp),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show success dialog
void showReferralSuccessDialog() {
  Get.dialog(
    const ReferralResultDialog(isSuccess: true),
    barrierDismissible: true,
  );
}

// Function to show failure dialog
void showReferralFailureDialog({String? userName}) {
  Get.dialog(
    ReferralResultDialog(
      isSuccess: false,
      userName: userName,
    ),
    barrierDismissible: true,
  );
}
