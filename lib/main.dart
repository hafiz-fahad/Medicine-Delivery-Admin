import 'package:al_asr_admin/screens/create_admin_screen.dart';
import 'package:al_asr_admin/screens/employee_admin.dart';
import 'package:flutter/material.dart';
import 'package:al_asr_admin/providers/app_states.dart';
import 'package:al_asr_admin/providers/products_provider.dart';
import 'package:al_asr_admin/providers/user_provider.dart';
import 'package:al_asr_admin/screens/admin.dart';
import 'package:al_asr_admin/screens/dashboard.dart';
import 'package:al_asr_admin/providers/products_provider.dart';
import 'package:al_asr_admin/screens/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:al_asr_admin/providers/app_states.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: AppState()),
      ChangeNotifierProvider.value(value: ProductProvider()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      SplashScreen(
          seconds: 6,
          navigateAfterSeconds: new ScreensController(),
          // navigateAfterSeconds: new CreateAdminScreen(),
          image: new Image.asset('icons/LoginLogo.png'),
          backgroundColor: Color(0xff252525),
          photoSize: 80.0,
          loadingText: Text("\t\t\tPowered By \n Meds @ Home",
            style: TextStyle(
                color: Colors.grey.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.bold
            ),
          ),
          loaderColor: Color(0xff252525)
      ),
    ),
  ));
}


class ScreensController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    print("STATUSSSSSSSS   ${user.status.toString()}");

    switch(box.read('session').toString()){
//      case Status.Uninitialized:
//        return Login();
      case 'inActive':
      return Login();
      case 'AdminActive':
        return Admin();
      case 'EmployeeActive':
        return EmployeeAdmin();
      default: return Login();
    }
//     switch(user.status){
// //      case Status.Uninitialized:
// //        return Login();
//       case Status.Unauthenticated:
//       case Status.Authenticating:
//         return Login();
//       case Status.AuthenticatedAdmin:
//         return Admin();
//       case Status.AuthenticatedEmployee:
//         return EmployeeAdmin();
//       default: return Login();
//     }
  }
}




