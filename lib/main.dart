import 'package:flutter/material.dart';
import 'package:Medsway.pk_Admin/providers/app_states.dart';
import 'package:Medsway.pk_Admin/providers/products_provider.dart';
import 'package:Medsway.pk_Admin/providers/user_provider.dart';
import 'package:Medsway.pk_Admin/screens/admin.dart';
import 'package:Medsway.pk_Admin/screens/dashboard.dart';
import 'package:Medsway.pk_Admin/providers/products_provider.dart';
import 'package:Medsway.pk_Admin/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:Medsway.pk_Admin/providers/app_states.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: AppState()),
      ChangeNotifierProvider.value(value: ProductProvider()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset('icons/LoginLogo.png'),
        nextScreen: ScreensController(),
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.leftToRight,
        backgroundColor: Color(0xff252525),
        curve: Curves.bounceInOut,
      ),
    ),
  ));
}


class ScreensController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
//      case Status.Uninitialized:
//        return Login();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return Admin();
      default: return Login();
    }
  }
}




