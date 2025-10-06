// import 'package:country_currency_pickers/country.dart';
// import 'package:country_currency_pickers/country_picker_dropdown.dart';
// import 'package:country_currency_pickers/utils/utils.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../Backend/ClientsBackend/get_client_create_info.dart';
// import '../../Backend/ClientsBackend/store_client.dart';
// import '../../Backend/get_cities_of_a_specified_country.dart';
// import '../../Backend/get_countries.dart';
// import '../../Controllers/client_controller.dart';
// import '../../Controllers/home_controller.dart';
// import '../../Widgets/custom_snak_bar.dart';
// import '../../Widgets/loading.dart';
// import '../../Widgets/page_title.dart';
// import '../../Widgets/reusable_btn.dart';
// import '../../const/Sizes.dart';
// import '../../const/colors.dart';

// class CreateCustomerDialogContent extends StatefulWidget {
//   const CreateCustomerDialogContent({super.key});
//
//   @override
//   State<CreateCustomerDialogContent> createState() =>
//       _CreateCustomerDialogContentState();
// }
//
// class _CreateCustomerDialogContentState
//     extends State<CreateCustomerDialogContent> {
//   TextEditingController searchController = TextEditingController();
//   TextEditingController clientNameController = TextEditingController();
//   TextEditingController referenceController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController floorBldgController = TextEditingController();
//   TextEditingController titleController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController streetController = TextEditingController();
//   TextEditingController jobPositionController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController taxIdController = TextEditingController();
//   TextEditingController websiteController = TextEditingController();
//   TextEditingController internalNoteController = TextEditingController();
//   TextEditingController grantedDiscountController = TextEditingController();
//   final HomeController homeController = Get.find();
//   final ClientController clientController = Get.find();
//   String paymentTerm = '', priceListSelected = '', selectedCountry = '',selectedCity='';
//   String selectedPhoneCode = '', selectedMobileCode = '';
//   int selectedClientType = 1;
//   int selectedTabIndex = 0;
//   List tabsList = [
//     'contacts_addresses',
//     'sales',
//     'internal_note',
//     'settings',
//   ];
//   Map data = {};
//   bool isClientsInfoFetched = false;
//
//   getFieldsForCreateClientsFromBack() async {
//     var p = await getFieldsForCreateClient();
//     if ('$p' != '[]') {
//       setState(() {
//         data.addAll(p);
//         isClientsInfoFetched = true;
//       });
//     }
//   }
//
//   List<String> titles = ['Doctor', 'Miss', 'Mister', 'Maitre', 'Professor'];
//   String selectedTitle = '';
//   bool isActiveInPosChecked = false;
//   bool isBlockedChecked = false;
//   final _formKey = GlobalKey<FormState>();
//
//   List<String> countriesNamesList=[];
//   bool isCountriesFetched = false;
//   List<String> citiesNamesList=[];
//   bool isCitiesFetched = true;
//   getCountriesFromBack() async {
//     var p = await getCountries();
//     setState(() {
//       for (var c in p) {
//         countriesNamesList.add('${c['country']}');
//       }
//       isCountriesFetched = true;
//     });
//   }
//   getCitiesFromBack(String country) async {
//     setState(() {
//       isCitiesFetched =false;
//       citiesNamesList=[];
//     });
//     var p = await getCitiesOfASpecifiedCountry(country);
//     setState(() {
//       for (var c in p) {
//         citiesNamesList.add(c);
//       }
//       isCitiesFetched = true;
//     });
//   }
//
//   @override
//   void initState() {
//     getFieldsForCreateClientsFromBack();
//     getCountriesFromBack();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double rowWidth=homeController.isTablet? MediaQuery.of(context).size.width * 0.35 :MediaQuery.of(context).size.width * 0.22;
//     double  textFieldWidth=homeController.isTablet? MediaQuery.of(context).size.width * 0.25: MediaQuery.of(context).size.width * 0.15;
//     return Form(
//       key: _formKey,
//       child: Container(
//         color: Colors.white,
//         width: MediaQuery.of(context).size.width * 0.95,
//         height: MediaQuery.of(context).size.height * 0.95,
//         padding:  EdgeInsets.symmetric(horizontal:homeController.isTablet?0: 10, vertical:homeController.isTablet? 0 : 10),
//         child: isClientsInfoFetched
//             ? Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       PageTitle(text: 'create_new_client'.tr),
//                       InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: Primary.primary,
//                           radius: 15,
//                           child: const Icon(
//                             Icons.close_rounded,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   gapH10,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.20,
//                         child: ListTile(
//                           title: Text('individual'.tr,
//                               style: const TextStyle(fontSize: 14)),
//                           leading: Radio(
//                             value: 1,
//                             groupValue: selectedClientType,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedClientType = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.20,
//                         child: ListTile(
//                           title: Text('company'.tr,
//                               style: const TextStyle(fontSize: 14)),
//                           leading: Radio(
//                             value: 2,
//                             groupValue: selectedClientType,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedClientType = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     height: MediaQuery.of(context).size.height * 0.65,
//                     child: GridView.count(
//                       childAspectRatio:
//                           (Sizes.deviceWidth * 0.5 / Sizes.deviceHeight * 8.0),
//                       crossAxisCount:homeController.isTablet? 2: 3,
//                       primary: false,
//                       padding:  EdgeInsets.all(homeController.isTablet?0:20),
//                       crossAxisSpacing: 30,
//                       mainAxisSpacing: 10,
//                       children: [
//
//                         // gapH32,
//                         // const AddPhotoCircle(),
//                         // gapH16,
//                         // gapH16,
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.start,
//                         //   children: [
//                         //     SizedBox(
//                         //       width: MediaQuery.of(context).size.width * 0.12,
//                         //       child: ListTile(
//                         //         title: Text('individual'.tr,
//                         //             style: const TextStyle(fontSize: 14)),
//                         //         leading: Radio(
//                         //           value: 1,
//                         //           groupValue: selectedClientType,
//                         //           onChanged: (value) {
//                         //             setState(() {
//                         //               selectedClientType = value!;
//                         //             });
//                         //           },
//                         //         ),
//                         //       ),
//                         //     ),
//                         //     SizedBox(
//                         //       width: MediaQuery.of(context).size.width * 0.12,
//                         //       child: ListTile(
//                         //         title: Text('company'.tr,
//                         //             style: const TextStyle(fontSize: 14)),
//                         //         leading: Radio(
//                         //           value: 2,
//                         //           groupValue: selectedClientType,
//                         //           onChanged: (value) {
//                         //             setState(() {
//                         //               selectedClientType = value!;
//                         //             });
//                         //           },
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                         // gapH8,
//                         // gapH8,
//                         Text(
//                           '${data['clientNumber'] ?? ''}',
//                           style: const TextStyle(
//                               fontSize: 36, fontWeight: FontWeight.bold),
//                         ),
//                         gapH8,
//                         homeController.isTablet?ReusableDialogTextField(
//                           textEditingController: clientNameController,
//                           text: '${'client_name'.tr}*',
//                           rowWidth: rowWidth,
//                           textFieldWidth: textFieldWidth,
//                           validationFunc: (String val) {
//                             if(val.isEmpty){
//                               return 'required_field'.tr;
//                             }return null;
//                           },
//                         ):gapH8,
//                         homeController.isTablet?gapH8:
//                         ReusableDialogTextField(
//                           textEditingController: clientNameController,
//                           text: '${'client_name'.tr}*',
//                           rowWidth: rowWidth,
//                           textFieldWidth: textFieldWidth,
//                           validationFunc: (String val) {
//                             if(val.isEmpty){
//                               return 'required_field'.tr;
//                             }return null;
//                           },
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: referenceController,
//                           text: 'reference'.tr,
//                           rowWidth: rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {},
//                         ),
//                         PhoneTextField(
//                           textEditingController: phoneController,
//                           text: 'phone'.tr,
//                           rowWidth: rowWidth,//MediaQuery.of(context).size.width * 0.25,
//                           textFieldWidth:textFieldWidth,
//                              // MediaQuery.of(context).size.width * 0.2,
//                           validationFunc: (val) {
//                             if(val.isNotEmpty && val.length<7){
//                               return '7_digits'.tr;
//                             }return null;
//                           },
//                           onCodeSelected: (value) {
//                             setState(() {
//                               selectedPhoneCode = value;
//                             });
//                           },
//                           onChangedFunc: (value) {
//                             setState(() {
//                               // mainDescriptionController.text=value;
//                             });
//                           },
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: floorBldgController,
//                           text: 'floor_bldg'.tr,
//                           rowWidth: rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {},
//                         ),
//                         SizedBox(
//                           width: rowWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('title'.tr),
//                               DropdownMenu<String>(
//                                 width: textFieldWidth,
//                                 // requestFocusOnTap: false,
//                                 enableSearch: true,
//                                 controller: searchController,
//                                 hintText: 'Doctor, Miss, Mister',
//                                 inputDecorationTheme: InputDecorationTheme(
//                                   // filled: true,
//                                   hintStyle: const TextStyle(
//                                       fontStyle: FontStyle.italic),
//                                   contentPadding:
//                                       const EdgeInsets.fromLTRB(20, 0, 25, 5),
//                                   // outlineBorder: BorderSide(color: Colors.black,),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.2 * 255).toInt()),
//                                         width: 1),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.4 * 255).toInt()),
//                                         width: 2),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                 ),
//                                 // menuStyle: ,
//                                 menuHeight: 250,
//                                 dropdownMenuEntries: titles
//                                     .map<DropdownMenuEntry<String>>(
//                                         (String option) {
//                                   return DropdownMenuEntry<String>(
//                                     value: option,
//                                     label: option,
//                                   );
//                                 }).toList(),
//                                 enableFilter: true,
//                                 onSelected: (String? val) {
//                                   setState(() {
//                                     selectedTitle = val!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         PhoneTextField(
//                           textEditingController: mobileController,
//                           text: 'mobile'.tr,
//                           rowWidth:rowWidth,// MediaQuery.of(context).size.width * 0.25,
//                           textFieldWidth:textFieldWidth,
//                             //  MediaQuery.of(context).size.width * 0.2,
//                           validationFunc: (val) {
//                             if(val.isNotEmpty && val.length<7){
//                               return '7_digits'.tr;
//                             }return null;
//                           },
//                           onCodeSelected: (value) {
//                             setState(() {
//                               selectedMobileCode = value;
//                             });
//                           },
//                           onChangedFunc: (value) {
//                             setState(() {
//                               // mainDescriptionController.text=value;
//                             });
//                           },
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: streetController,
//                           text: 'street'.tr,
//                           rowWidth: rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {},
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: jobPositionController,
//                           text: 'job_position'.tr,
//                           hint: 'Sales Director,Sales...',
//                           rowWidth: rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {},
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: emailController,
//                           text: 'email'.tr,
//                           hint: 'example@gmail.com',
//                           rowWidth:rowWidth,// MediaQuery.of(context).size.width * 0.25,
//                           textFieldWidth:textFieldWidth,
//                              // MediaQuery.of(context).size.width * 0.2,
//                           validationFunc: (String value) {
//                             if (value.isNotEmpty &&
//                                 !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                     .hasMatch(value)) {
//                               return 'check_format'.tr;
//                             }
//                           },
//                         ),
//                         // ReusableDialogTextField(
//                         //   textEditingController: cityController,
//                         //   text: 'city'.tr,
//                         //   rowWidth: rowWidth,
//                         //   textFieldWidth:
//                         //       textFieldWidth,
//                         //   validationFunc: (val) {},
//                         // ),
//                         isCountriesFetched
//                         ? SizedBox(
//                           width: rowWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('country'.tr),
//                               DropdownMenu<String>(
//                                 width: textFieldWidth,
//                                 // requestFocusOnTap: false,
//                                 enableSearch: true,
//                                 controller: countryController,
//                                 hintText: '',
//                                 inputDecorationTheme: InputDecorationTheme(
//                                   // filled: true,
//                                   hintStyle: const TextStyle(
//                                       fontStyle: FontStyle.italic),
//                                   contentPadding:
//                                   const EdgeInsets.fromLTRB(20, 0, 25, 5),
//                                   // outlineBorder: BorderSide(color: Colors.black,),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.2 * 255).toInt()),
//                                         width: 1),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.4 * 255).toInt()),
//                                         width: 2),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                 ),
//                                 // menuStyle: ,
//                                 menuHeight: 250,
//                                 dropdownMenuEntries: countriesNamesList
//                                     .map<DropdownMenuEntry<String>>(
//                                         (String option) {
//                                       return DropdownMenuEntry<String>(
//                                         value: option,
//                                         label: option,
//                                       );
//                                     }).toList(),
//                                 enableFilter: true,
//                                 onSelected: (String? val) {
//                                   setState(() {
//                                     selectedCountry = val!;
//                                     getCitiesFromBack(val);
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         )
//                         //     ? DialogDropMenu(
//                         //   optionsList: countriesNamesList,
//                         //   controller: countryController,
//                         //   isSearchEnabled:true,
//                         //   isDetectedHeight: true,
//                         //   text: 'country'.tr,
//                         //   hint: '',
//                         //   rowWidth: rowWidth,
//                         //   textFieldWidth: textFieldWidth,
//                         //   onSelected: (val) {
//                         //     setState(() {
//                         //       selectedCountry = val;
//                         //       getCitiesFromBack(val);
//                         //     });
//                         //   },
//                         // )
//                             :SizedBox(
//                             width: rowWidth,
//                             child: loading()),
//                         ReusableDialogTextField(
//                           textEditingController: taxIdController,
//                           text: 'tax_number'.tr,
//                           rowWidth: rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {
//                             if( selectedClientType==2&& val.isEmpty){
//                               return 'required_field'.tr;
//                             }
//                             return null;
//                           },
//                         ),
//                         ReusableDialogTextField(
//                           textEditingController: websiteController,
//                           text: 'website'.tr,
//                           hint: 'www.example.com',
//                           rowWidth:rowWidth,// MediaQuery.of(context).size.width * 0.25,
//                           textFieldWidth:textFieldWidth,
//                              // MediaQuery.of(context).size.width * 0.2,
//                           validationFunc: (String value) {
//                             if (value.isNotEmpty &&
//                                 !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                     .hasMatch(value)) {
//                               return 'check_format'.tr;
//                             }
//                             return null;
//                           },
//                         ),
//                         // DialogDropMenu(
//                         //   optionsList: const ['item 1', 'item 2', 'item 3'],
//                         //   text: 'country'.tr,
//                         //   hint: '',
//                         //   rowWidth: rowWidth,
//                         //   textFieldWidth:
//                         //       textFieldWidth,
//                         //   onSelected: (val) {
//                         //     setState(() {
//                         //       selectedCountry = val;
//                         //     });
//                         //   },
//                         // ),
//                         isCitiesFetched
//                         ?SizedBox(
//                           width: rowWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('city'.tr),
//                               DropdownMenu<String>(
//                                 width: textFieldWidth,
//                                 // requestFocusOnTap: false,
//                                 enableSearch: true,
//                                 controller: cityController,
//                                 hintText: '',
//                                 inputDecorationTheme: InputDecorationTheme(
//                                   // filled: true,
//                                   hintStyle: const TextStyle(
//                                       fontStyle: FontStyle.italic),
//                                   contentPadding:
//                                   const EdgeInsets.fromLTRB(20, 0, 25, 5),
//                                   // outlineBorder: BorderSide(color: Colors.black,),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.2 * 255).toInt()),
//                                         width: 1),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.4 * 255).toInt()),
//                                         width: 2),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(9)),
//                                   ),
//                                 ),
//                                 // menuStyle: ,
//                                 menuHeight: 250,
//                                 dropdownMenuEntries: citiesNamesList
//                                     .map<DropdownMenuEntry<String>>(
//                                         (String option) {
//                                       return DropdownMenuEntry<String>(
//                                         value: option,
//                                         label: option,
//                                       );
//                                     }).toList(),
//                                 enableFilter: true,
//                                 onSelected: (String? val) {
//                                   setState(() {
//                                     selectedCity = val!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         )
//                         //     ? DialogDropMenu(
//                         //   optionsList: citiesNamesList,
//                         //   controller: cityController,
//                         //   isDetectedHeight: true,
//                         //   isSearchEnabled:true,
//                         //   text: 'city'.tr,
//                         //   hint:selectedCountry.isEmpty? 'select the country first':'',
//                         //   rowWidth: MediaQuery.of(context).size.width*0.22,
//                         //   textFieldWidth: textFieldWidth,
//                         //   onSelected: (val) {
//                         //     setState(() {
//                         //       selectedCity = val;
//                         //     });
//                         //   },
//                         // )
//                             : SizedBox(
//                             width: MediaQuery.of(context).size.width*0.22,
//                             child: loading()),
//                         ReusableDialogTextField(
//                           textEditingController:
//                           internalNoteController,
//                           text:
//                           'internal_note'.tr,
//                           rowWidth:
//                          rowWidth,
//                           textFieldWidth:
//                           textFieldWidth,
//                           validationFunc: (val) {},
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                                 'granted_discount'.tr,
//                               style: TextStyle(
//                                 fontSize: homeController.isTablet?13:14
//                               ),
//                             ),
//                             SizedBox(
//                               width:   textFieldWidth,
//                               child: TextFormField(
//                                 // textAlign: TextAlign.center,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 10),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
//                                     borderRadius:
//                                     const BorderRadius.all(Radius.circular(9)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
//                                     borderRadius:
//                                     const BorderRadius.all(Radius.circular(9)),
//                                   ),
//                                   errorStyle: const TextStyle(
//                                     fontSize: 10.0,
//                                   ),
//                                   focusedErrorBorder: const OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(Radius.circular(9)),
//                                     borderSide: BorderSide(width: 1, color: Colors.red),
//                                   ),
//                                 ),
//                                 controller: grantedDiscountController,
//                                 keyboardType: const TextInputType.numberWithOptions(
//                                   decimal: false,
//                                   signed: true,
//                                 ),
//                                 inputFormatters: <TextInputFormatter>[
//                                   FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
//                                   // WhitelistingTextInputFormatter.digitsOnly
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
//                         // ReusableInputNumberField(
//                         //   controller:
//                         //   grantedDiscountController,
//                         //   textFieldWidth:
//                         //   MediaQuery.of(context)
//                         //       .size
//                         //       .width *
//                         //       0.15,
//                         //   rowWidth:
//                         //   MediaQuery.of(context)
//                         //       .size
//                         //       .width,
//                         //   onChangedFunc: (val) {},
//                         //   validationFunc: (value) {},
//                         //   text:
//                         //   'granted_discount'.tr,
//                         // ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       ReusableButtonWithColor(
//                           radius: 9,
//                           btnText: 'save'.tr,
//                           onTapFunction: () async {
//                             if (_formKey.currentState!.validate()) {
//                               var res = await storeClient(
//                                   referenceController.text,
//                                  '1',
//                                   grantedDiscountController.text,
//                                   isBlockedChecked?'1':'0',
//                                   selectedClientType == 1
//                                       ? 'individual'
//                                       : 'company',
//                                   clientNameController.text,
//                                   data['quotationNumber'] ?? '',
//                                   selectedCountry,
//                                   cityController.text,
//                                   '',
//                                   '',
//                                   streetController.text,
//                                   floorBldgController.text,
//                                   jobPositionController.text,
//                                   selectedPhoneCode,
//                                   phoneController.text,
//                                   selectedMobileCode,
//                                   mobileController.text,
//                                   emailController.text,
//                                   titleController.text,
//                                   '',
//                                   taxIdController.text,
//                                   websiteController.text,
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   '',
//                                   paymentTerm,
//                                   priceListSelected,
//                                   internalNoteController.text,
//                                   '',
//                                 [],
//                               );
//                               if (res['success'] == true) {
//                                 clientController.getAllClientsFromBack();
//                                 Get.back();
//                                 CommonWidgets.snackBar('Success',
//                                     res['message']);
//                               } else {
//                                 CommonWidgets.snackBar(
//                                     'error',  res['message']);
//                               }
//                             }
//                           },
//                           width: 100,
//                           height: 35),
//                       gapW24,
//                       TextButton(
//                           onPressed: () {
//                             setState(() {
//                               selectedClientType=1;
//                               selectedPhoneCode = '';
//                               selectedMobileCode = '';
//                               paymentTerm = ''; priceListSelected = ''; selectedCountry = '';
//                               searchController.clear();
//                               clientNameController.clear();
//                               referenceController.clear();
//                               phoneController.clear();
//                               floorBldgController.clear();
//                               titleController.clear();
//                               mobileController.clear();
//                               streetController.clear();
//                               jobPositionController.clear();
//                               emailController.clear();
//                               cityController.clear();
//                               taxIdController.clear();
//                               websiteController.clear();
//                               internalNoteController.clear();
//                               grantedDiscountController.clear();
//                               isBlockedChecked=false;
//                               isActiveInPosChecked=false;
//                               grantedDiscountController.clear();
//                             });
//                           },
//                           child: Text(
//                             'discard'.tr,
//                             style: TextStyle(
//                                 decoration: TextDecoration.underline,
//                                 color: Primary.primary),
//                           )),
//                     ],
//                   )
//                 ],
//               )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
//
// }

// class AddPhotoCircle extends StatefulWidget {
//   const AddPhotoCircle({super.key});
//
//   @override
//   State<AddPhotoCircle> createState() => _AddPhotoCircleState();
// }
//
// class _AddPhotoCircleState extends State<AddPhotoCircle> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: CircleAvatar(
//         radius: 60,
//         backgroundColor: Primary.p20,
//         child: DottedBorder(
//             borderType: BorderType.Circle,
//             color: Primary.primary,
//             dashPattern: const [5, 10],
//             child: Container(
//                 height: 80,
//                 width: 80,
//                 decoration: const BoxDecoration(shape: BoxShape.circle),
//                 child: Center(
//                   child: Text(
//                     String.fromCharCode(Icons.add_rounded.codePoint),
//                     style: TextStyle(
//                       inherit: false,
//                       color: Primary.primary,
//                       fontSize: 25,
//                       fontWeight: FontWeight.w800,
//                       fontFamily: Icons.space_dashboard_outlined.fontFamily,
//                     ),
//                   ),
//                 ) // Icon(Icons.add,color: Primary.primary,),
//                 )),
//       ),
//     );
//   }
// }






