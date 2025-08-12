import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/referral_result_dialog.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class RedeemReferralDialog extends StatefulWidget {
  const RedeemReferralDialog({super.key});

  @override
  State<RedeemReferralDialog> createState() => _RedeemReferralDialogState();
}

class _RedeemReferralDialogState extends State<RedeemReferralDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final code = _codeController.text.trim();

    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate empty code
    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the code';
      });
      return;
    }

    // Validate code length (must be exactly 5 characters)
    if (code.length != 5) {
      setState(() {
        _errorMessage = 'Invalid code';
      });
      return;
    }

    // Validate code format (alphanumeric)
    if (!RegExp(r'^[a-zA-Z0-9]{5}$').hasMatch(code)) {
      setState(() {
        _errorMessage = 'Invalid code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Close current dialog first
    Get.back();

    // Add small delay to ensure dialog is closed
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate checking referral code
    // For demo purposes, let's make some codes successful and others fail
    print('Checking code: $code');
    if (_isValidReferralCode(code)) {
      print('Code is valid - showing success dialog');
      // Show success dialog
      showReferralSuccessDialog();
    } else {
      print('Code is invalid - showing failure dialog');
      // Show failure dialog with mock user name
      showReferralFailureDialog(userName: 'user_name');
    }
  }

  void _onCancel() {
    Get.back();
  }

  // Simulate checking if referral code is valid
  // For demo: codes starting with 'A' or 'B' are valid, others are invalid
  bool _isValidReferralCode(String code) {
    return code.toUpperCase().startsWith('A') ||
        code.toUpperCase().startsWith('B');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.sp),
      child: Container(
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
          color: subBg01Color,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Center(
              child: StyledText(
                'Redeem Referral Code',
                fontSize: 20,
                fontWeight: 700,
                lineHeight: 24,
                color: Color(0xFFFFFFFF),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16.sp),

            // Subtitle
            const Center(
              child: StyledText(
                'Enter the code you received\nfrom your friend',
                fontSize: 14,
                fontWeight: 400,
                lineHeight: 18,
                color: Color(0xFFFFFFFF),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 32.sp),

            // Input field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: popupBgColor,
                    borderRadius: BorderRadius.circular(12.sp),
                    border: Border.all(
                      color: _errorMessage != null
                          ? const Color(0xFFFF4D4D) // Red border when error
                          : deepGrayColor.withOpacity(0.3),
                      width: _errorMessage != null ? 2.sp : 1.sp,
                    ),
                  ),
                  child: TextField(
                    controller: _codeController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter code',
                      hintStyle: TextStyle(
                        color: deepGrayColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Pretendard',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 16.sp,
                      ),
                    ),
                    textAlign: TextAlign.left,
                    enabled: !_isLoading,
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                        });
                      }
                    },
                  ),
                ),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.sp, left: 4.sp),
                    child: StyledText(
                      _errorMessage!,
                      fontSize: 14,
                      fontWeight: 400,
                      color: const Color(0xFFFF4D4D), // Red color for error
                    ),
                  ),
              ],
            ),

            SizedBox(height: 24.sp),

            // Submit button
            GazagoButton(
              buttonText: 'Submit',
              buttonColor: const Color(0xFF4B90E2),
              textColor: const Color(0xFFFFFFFF),
              borderColor: const Color(0xFF4B90E2),
              fontSize: 16,
              fontWeight: 700,
              onTap: _onSubmit,
              disableButton: _isLoading,
            ),

            SizedBox(height: 12.sp),

            // Cancel button
            GazagoButton(
              buttonText: 'Cancel',
              buttonColor: const Color(0xFF4D4D4D),
              textColor: const Color(0xFFFFFFFF),
              borderColor: const Color(0xFF4D4D4D),
              fontSize: 16,
              fontWeight: 400,
              onTap: _onCancel,
              disableButton: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the dialog
void showRedeemReferralDialog() {
  Get.dialog(
    const RedeemReferralDialog(),
    barrierDismissible: false,
  );
}
