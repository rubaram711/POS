import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Screens/Home/roles_page.dart';
import 'package:pos_project/Screens/Home/select_pos_page.dart';
import 'package:pos_project/translation/localization/locale_service.dart';
import 'package:pos_project/translation/localization/localization.dart';
import 'Backend/Sessions/get_open_session_id.dart';
import 'Binding/binding.dart';
import 'Locale_Memory/save_user_info_locally.dart';
import 'Screens/Authorization/sign_up_screen.dart';
import 'Screens/Home/home_page.dart';
import 'Screens/Sessions/sessions_options.dart';

var id='';
var roleId='';
var posTerminalId='';
var currentSessionId='';
getInfoFromPref() async{
  id=await getIdFromPref();
  if(id!='') {
    roleId=await getRoleIdFromPref();
    posTerminalId=await getPosTerminalIdFromPref();

    var p=await getOpenSessionId();
    if('$p'!='[]') {
        currentSessionId = '${p['data']['session']['id']}';
    }
  }
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale? savedLocale = await LocaleService.getSavedLocale();
  await getInfoFromPref();
  runApp(  MyApp(savedLocale: savedLocale));
  // runApp(
  //     DevicePreview(
  //       // enabled: !kReleaseMode,
  //       builder: (context) => const MyApp(), // Wrap your app
  //     ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.savedLocale});
  final Locale? savedLocale;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBinding(),
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      translations: AppLocalization(),
      locale: savedLocale ?? const Locale('en'),
      fallbackLocale: const Locale('en'),
      home:id==''
      ?const SignInScreen()
      :posTerminalId==''?
          const SelectPosPage()
          :roleId=='' //currentSessionId==''
          ?  const RolesPage()//SessionsOptions()
          : currentSessionId==''?const SessionsOptions():const HomePage(),
    );
  }
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

//roba-admin@email.com

//flutter build web --web-renderer canvaskit