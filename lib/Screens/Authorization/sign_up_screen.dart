import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/role_controller.dart';
import 'package:pos_project/Controllers/session_controller.dart';
import 'package:pos_project/Screens/Home/roles_page.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../Backend/HeadersBackend/get_headers.dart';
import '../../Backend/login_api.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Models/role_model.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/reusable_btn.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../Home/select_pos_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenTypeLayout.builder(
      breakpoints:
          const ScreenBreakpoints(tablet: 600, desktop: 950, watch: 300),
      mobile: (p0) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SignForm(
                  isDesktop: false,
                )),
          ],
        ),
      ),
      tablet: (p0) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SignForm(
                  isDesktop: false,
                )),
          ],
        ),
      ),
      desktop: (p0) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height,
              child: const SignForm(
                isDesktop: true,
              )),
        ],
      ),
    ));
  }
}



class SignForm extends StatefulWidget {
  const SignForm({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  HomeController homeController=Get.find();
  String email = '';
  String password = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SessionController sessionController = Get.find();
  RoleController roleController = Get.find();
  final focus = FocusNode();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.isDesktop ? const SizedBox() : gapH32,
            Text(
                    "Welcome to Rooster POS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:widget.isDesktop ? 30:23,
                        color: Primary.black),
                  ),
            Text(
                    "Login to your account."
                    // style: TextStyle(
                    //     // fontWeight: FontWeight.bold,
                    //     // fontSize: 30,
                    //     color: Primary.black),
                  ),
            gapH56,
            SizedBox(
                width: widget.isDesktop
                    ? MediaQuery.of(context).size.width * 0.35
                    : MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "email".tr,
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 25, 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 10.0,
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'email is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                )),
            gapH16,
            SizedBox(
                width: widget.isDesktop
                    ? MediaQuery.of(context).size.width * 0.35
                    : MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  focusNode: focus,
                  cursorColor: Colors.black,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: "password".tr,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 23,
                      ),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 25, 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 10.0,
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'password is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                )),
            gapH56,
            ReusableButtonWithColor(
                    btnText: "sign_in".tr,
                    width:widget.isDesktop ?100:MediaQuery.of(context).size.width * 0.8,
                    height:widget.isDesktop ? 35:50,
                    onTapFunction: () async {
                      if (_formKey.currentState!.validate()) {
                        var res = await login(email, password);
                        if (res['success'] == true) {
                          List<Role> roles = res['data']['user']['roles']
                              .map<Role>((e) => Role.fromJson(e))
                              .toList();
                          await saveRolesLocally(roles);
                          await saveUserInfoLocally(
                            res['data']['accessToken'],
                            '${res['data']['user']['id']}',
                            res['data']['user']['email'],
                            res['data']['user']['name'],
                            '${res['data']['user']['company']['name']}',
                            '${res['data']['user']['company']['id']}',
                            res['data']['posWarehouse'] == null
                                ? ''
                                : '${res['data']['posWarehouse']['id']}',
                            res['data']['user']['posTerminal'] == null
                                ? ''
                                : '${res['data']['user']['posTerminal']['id']}',
                            res['data']['user']['posTerminal'] == null
                                ? ''
                                : '${res['data']['user']['posTerminal']['name']}',
                              res['data']['user']['company']['has_garage']==true?'1':'0'
                            //res['data']['user']['latestSession']==null || '${res['data']['user']['latestSession']}'=='[]'? '' : '${res['data']['user']['latestSession']['id']}'
                          );
                          homeController.setIsItGarage(res['data']['user']['company']['has_garage']==true);
                          // print('object');
                          if(res['data']['companySettings'].isNotEmpty){
                            // print('object');print('${res['data']['companySettings']['companySubjectToVat']}');
                            await saveCompanySettingsLocally(
                                '${res['data']['companySettings']['costCalculationType']??''}',
                                '${res['data']['companySettings']['showQuantitiesOnPos']??''}',
                                // res['data']['companySettings']['logo']??'',
                                // res['data']['companySettings']['fullCompanyName']??'',
                                // res['data']['companySettings']['email']??'',
                                // res['data']['companySettings']['vat']??'0',
                                // res['data']['companySettings']['mobileNumber'] ??'',
                                // res['data']['companySettings']['phoneNumber'] ??'',
                                // res['data']['companySettings']['trn'] ??'',
                                // res['data']['companySettings']['bankInfo'] ??'',
                                // res['data']['companySettings']['address'] ??'',
                                // res['data']['companySettings']['phoneCode'] ??'',
                                // res['data']['companySettings']['mobileCode'] ??'',
                                // res['data']['companySettings']['localPayments'] ??'',
                                res['data']['companySettings']['primaryCurrency']['name'] ??'USD',
                                '${res['data']['companySettings']['primaryCurrency']['id']??''}',
                                '${res['data']['companySettings']['primaryCurrency']['symbol']??''}',
                                // '${res['data']['companySettings']['companySubjectToVat']??'1'}',
                              homeController.companyName=='PETEXPERT'||res['data']['companySettings']['posCurrency']==null?'USD':res['data']['companySettings']['posCurrency']['name'],
                              homeController.companyName=='PETEXPERT'||res['data']['companySettings']['posCurrency']==null?'': '${res['data']['companySettings']['posCurrency']['id']??''}',
                              homeController.companyName=='PETEXPERT'||res['data']['companySettings']['posCurrency']==null?'': '${res['data']['companySettings']['posCurrency']['symbol']??''}',
                              '${res['data']['companySettings']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['companySettings']['primaryCurrency']['latest_rate']??''}',
                              homeController.companyName=='PETEXPERT'||res['data']['companySettings']['posCurrency']==null
                                  ? '${res['data']['companySettings']['primaryCurrency']['latest_rate']??''}'==''?'1':'${res['data']['companySettings']['primaryCurrency']['latest_rate']??''}'
                                  : '${res['data']['companySettings']['posCurrency']['latest_rate']??''}',
                                '${res['data']['companySettings']['showLogoOnPos']??'0'}',
                            );}
                          await saveIsAllowedToSellZeroLocally(false);
                          await saveCantSellZeroMessageLocally('');
                          // productController.setIsAllowedToSellZero(false);
                          // ignore: use_build_context_synchronously
                          var headersRes=await getAllHeaders();
                          if(headersRes['success']==true && '${headersRes['data']}'!='[]'){
                            var header = headersRes['data'][0]??[];
                            await saveHeader1Locally(
                              header['logo']??'',
                              header['fullCompanyName']??'',
                              header['email']??'',
                              '${header['vat']??'0'}',
                              header['mobileNumber']??'',
                              header['phoneNumber']??'',
                              '${header['trn']??''}',
                              header['bankInfo']??'',
                              header['address']??'',
                              header['phoneCode']??'',
                              header['mobileCode']??'',
                              header['localPayments']??'',
                              '${header['companySubjectToVat']??'1'}',
                              header['headerName']??'',
                              '${header['id']??''}',
                            );
                          }
                          if (res['data']['user']['posTerminal'] == null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const SelectPosPage();
                            }));
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const RolesPage();
                            }));
                          }
                          // ignore: use_build_context_synchronously
                          //  var currentSessionId = '';
                          //  var p = await getOpenSessionId();
                          //  if ('${p['data']}' != '[]') {
                          //    setState(() {
                          //      currentSessionId = '${p['data']['id']}';
                          //    });
                          //  }
                          //  if (currentSessionId == '') {
                          //    // ignore: use_build_context_synchronously
                          //    Navigator.pushReplacement(context,
                          //        MaterialPageRoute(
                          //            builder: (BuildContext context) {
                          //      return const SessionsOptions();
                          //    }));
                          //  } else {
                          //    // ignore: use_build_context_synchronously
                          //    Navigator.pushReplacement(context,
                          //        MaterialPageRoute(
                          //            builder: (BuildContext context) {
                          //      return const HomePage();
                          //    }));
                          // }
                          // }
                        } else {
                          // ignore: use_build_context_synchronously
                          CommonWidgets.snackBar('error', res['message']);
                        }
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
