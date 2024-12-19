import 'package:flutter/widgets.dart';
import 'package:glamify_app/screens/Client/home/stores_screen.dart';
import 'package:glamify_app/screens/Client/details/details_screen.dart';
import 'package:glamify_app/screens/Client/home/home_screen.dart';
import 'package:glamify_app/screens/client/reservation/reservation_screen.dart';
import 'package:glamify_app/screens/Client/profile/components/change_password.dart';
import 'package:glamify_app/screens/Client/profile/profile_screen.dart';
import 'package:glamify_app/screens/business/register_business/register_business_gallery.dart';
import 'package:glamify_app/screens/business/register_business/register_business_screen.dart';
import 'package:glamify_app/screens/business/register_business/register_business_services.dart';
import 'package:glamify_app/screens/business/register_business/register_work_schedule.dart';
import 'package:glamify_app/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:glamify_app/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:glamify_app/screens/auth/login_success/login_success_screen.dart';
import 'package:glamify_app/screens/auth/otp/email/otp_email_screen.dart';
import 'package:glamify_app/screens/auth/sign_in/sign_in_screen.dart';
import 'package:glamify_app/screens/auth/sign_up/sign_up_screen.dart';
import 'init_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpEmailScreen.routeName: (context) => const OtpEmailScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  ChangePasswordScreen.routeName: (context) => const ChangePasswordScreen(),
  RegisterBusinessScreen.routeName: (context) => const RegisterBusinessScreen(),
  RegisterWorkSchedule.routeName: (context) => const RegisterWorkSchedule(),
  RegisterBusinessGallery.routeName: (context) =>
      const RegisterBusinessGallery(),
  RegisterBusinessServices.routeName: (context) =>const RegisterBusinessServices(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),

  ReservationScreen.routeName: (context) => const ReservationScreen(),
  StoresScreen.routeName: (context) => const StoresScreen(),
};
