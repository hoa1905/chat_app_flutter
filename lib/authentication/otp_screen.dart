import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? otpCode;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the arguments from the login screen
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final verificationId = args[Constants.verificationId] as String;
    final phoneNumber = args[Constants.phoneNumber] as String;

    final authProvider = context.watch<AuthenticationProvider>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Xác thực OTP',
                style: GoogleFonts.openSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Vui lòng nhập mã OTP vừa gửi đến số điện thoại ',
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: phoneNumber,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 68,
                child: Pinput(
                  length: 6,
                  controller: controller,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {
                    setState(() {
                      otpCode = pin;
                    });
                    // verify otp code
                    verifyOTPCode(
                      verificationId: verificationId,
                      otpCode: otpCode!,
                    );
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
              authProvider.isSuccessful
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : const SizedBox.shrink(),
              authProvider.isLoading
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {},
                      child: Text(
                        'Gửi lại mã',
                        style: GoogleFonts.openSans(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }

  void verifyOTPCode({
    required String verificationId,
    required String otpCode,
  }) async {
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.verifyOTPCode(
      verificationId: verificationId,
      otpCode: otpCode,
      context: context,
      onSuccess: () async {
        // 1. check if user exist in firestore
        bool userExists = await authProvider.checkUserExists();

        if (userExists) {
          // 2. if user exist

          // * get user information from firestore
          await authProvider.getUserDataFromFireStore();

          // * save user information to provider and shared preferences
          await authProvider.saveUserDataToSharedPreferences();

          // * navigate to home screen
          navigate(userExists: true);
        } else {
          // 3. if user not exist, navigate to user information screen
          navigate(userExists: false);
        }
      },
    );
  }

  void navigate({required bool userExists}) {
    if (userExists) {
      // navigate to home screen and remove all previous screens
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constants.homeScreen,
        (route) => false,
      );
    } else {
      // navigate to user information screen
      Navigator.pushNamed(
        context,
        Constants.userInformationScreen,
      );
    }
  }
}
