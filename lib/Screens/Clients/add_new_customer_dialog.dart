import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/payment_controller.dart';
import '../../Backend/ClientsBackend/get_client_create_info.dart';
import '../../Backend/ClientsBackend/store_client.dart';
import '../../Backend/get_cities_of_a_specified_country.dart';
import '../../Backend/get_countries.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/dialog_drop_menu.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/page_title.dart';
import '../../Widgets/reusable_add_card.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_drop_down_menu.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/Sizes.dart';
import '../../const/cars_constants.dart';
import '../../const/colors.dart';
import '../../const/functions.dart';

class CreateClientDialog extends StatefulWidget {
  const CreateClientDialog({super.key});

  @override
  State<CreateClientDialog> createState() =>
      _CreateClientDialogState();
}

class _CreateClientDialogState
    extends State<CreateClientDialog> {
  TextEditingController searchController = TextEditingController();
  TextEditingController priceListController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientNumberController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController floorBldgController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController taxIdController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController internalNoteController = TextEditingController();
  TextEditingController grantedDiscountController = TextEditingController();
  final HomeController homeController = Get.find();

  String paymentTerm = '', selectedPriceListId = '', selectedCountry = '',selectedCity='';
  String selectedPhoneCode = '', selectedMobileCode = '';
  int selectedClientType = 1;
  int selectedTabIndex = 0;
  List tabsList = [
    'settings',
    'contacts_and_addresses',
    'sales',
    'accounting',
    // 'cars',
  ];
  setTabsList()async{
    var isItGarage= await getIsItGarageFromPref();
    if(isItGarage=='1'){
      tabsList.add('cars');
    }
  }
  Map data = {};
  bool isClientsInfoFetched = false;
  List<String> pricesListsNames=[];
  List<String> pricesListsCodes=[];
  List<String> pricesListsIds=[];
  getFieldsForCreateClientsFromBack() async {
    var p = await getFieldsForCreateClient();
    if ('$p' != '[]') {
      setState(() {
        data.addAll(p);
        isClientsInfoFetched = true;
        clientNumberController.text=data['clientNumber'];
      });
      for(var priceList in p['pricelists']){
        if (priceList['code'] == 'STANDARD') {
          selectedPriceListId = '${priceList['id']}';
          priceListController.text = priceList['code'];
        }
        pricesListsNames.add(priceList['title']);
        pricesListsIds.add('${priceList['id']}');
        pricesListsCodes.add('${priceList['code']}');
      }
    }
  }

  List<String> titles = ['Doctor', 'Miss', 'Mister', 'Maitre', 'Professor'];
  String selectedTitle = '';
  bool isActiveInPosChecked = false;
  bool isBlockedChecked = false;
  final _formKey = GlobalKey<FormState>();

  List<String> countriesNamesList=[];
  bool isCountriesFetched = false;
  List<String> citiesNamesList=[];
  bool isCitiesFetched = true;
  getCountriesFromBack() async {
    var p = await getCountries();
    setState(() {
      for (var c in p) {
        countriesNamesList.add('${c['country']}');
      }
      isCountriesFetched = true;
    });
  }
  getCitiesFromBack(String country) async {
    setState(() {
      isCitiesFetched =false;
      citiesNamesList=[];
    });
    var p = await getCitiesOfASpecifiedCountry(country);
    setState(() {
      for (var c in p) {
        citiesNamesList.add(c);
      }
      isCitiesFetched = true;
    });
  }

  @override
  void initState() {
    setTabsList();
    clientController.contactsList=[];
    clientController.carsList=[];
    clientController.salesPersonController.clear();
    clientController.getAllUsersSalesPersonFromBack();
    getFieldsForCreateClientsFromBack();
    getCountriesFromBack();
    super.initState();
  }
  ClientController clientController=Get.find();
  PaymentController paymentController=Get.find();

  @override
  Widget build(BuildContext context) {
    // double rowWidth=MediaQuery.of(context).size.width * 0.22;
    // double  textFieldWidth=MediaQuery.of(context).size.width * 0.15;
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.95,
        padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isClientsInfoFetched
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageTitle(text: 'create_new_client'.tr),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: Primary.primary,
                      radius: 15,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              gapH10,
              gapH32,
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: ListTile(
                      title: Text('individual'.tr,
                          style: const TextStyle(fontSize: 12)),
                      leading: Radio(
                        value: 1,
                        groupValue: selectedClientType,
                        onChanged: (value) {
                          setState(() {
                            selectedClientType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: ListTile(
                      title: Text('company'.tr,
                          style: const TextStyle(fontSize: 12)),
                      leading: Radio(
                        value: 2,
                        groupValue: selectedClientType,
                        onChanged: (value) {
                          setState(() {
                            selectedClientType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              gapH16,
              DialogTextField(
                textEditingController: clientNumberController,
                text: '${'client_code'.tr}*',
                rowWidth: MediaQuery.of(context).size.width * 0.5,
                textFieldWidth: MediaQuery.of(context).size.width * 0.4,
                validationFunc: (value) {
                  if (value.isEmpty) {
                    return 'required_field'.tr;
                  }
                  return null;
                },
              ),
              gapH16,
              DialogTextField(
                textEditingController: clientNameController,
                text: '${'client_name'.tr}*',
                rowWidth: MediaQuery.of(context).size.width * 0.5,
                textFieldWidth: MediaQuery.of(context).size.width * 0.4,
                validationFunc: (value) {
                  if (value.isEmpty) {
                    return 'required_field'.tr;
                  }
                  return null;
                },
              ),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DialogTextField(
                    textEditingController: referenceController,
                    text: 'reference'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.22,
                    textFieldWidth:
                    MediaQuery.of(context).size.width * 0.15,
                    validationFunc: (val) {},
                  ),
                  PhoneTextField(
                    textEditingController: phoneController,
                    text: 'phone'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.25,
                    textFieldWidth: MediaQuery.of(context).size.width * 0.2,
                    validationFunc: (String val) {
                      if(val.isNotEmpty && val.length<7){
                        return '7_digits'.tr;
                      }return null;
                    },
                    onCodeSelected: (value) {
                      setState(() {
                        selectedPhoneCode = value;
                      });
                    },
                    onChangedFunc: (value) {
                      setState(() {
                        // mainDescriptionController.text=value;
                      });
                    },
                  ),
                  DialogTextField(
                    textEditingController: floorBldgController,
                    text: 'floor_bldg'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.22,
                    textFieldWidth:
                    MediaQuery.of(context).size.width * 0.15,
                    validationFunc: (val) {},
                  ),
                ],
              ),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('title'.tr),
                        DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * 0.15,
                          // requestFocusOnTap: false,
                          enableSearch: true,
                          controller: searchController,
                          hintText: 'Doctor, Miss, Mister',
                          inputDecorationTheme: InputDecorationTheme(
                            // filled: true,
                            hintStyle: const TextStyle(
                                fontStyle: FontStyle.italic),
                            contentPadding:
                            const EdgeInsets.fromLTRB(20, 0, 25, 5),
                            // outlineBorder: BorderSide(color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                                  width: 2),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                          ),
                          // menuStyle: ,
                          menuHeight: 250,
                          dropdownMenuEntries: titles
                              .map<DropdownMenuEntry<String>>(
                                  (String option) {
                                return DropdownMenuEntry<String>(
                                  value: option,
                                  label: option,
                                );
                              }).toList(),
                          enableFilter: true,
                          onSelected: (String? val) {
                            setState(() {
                              selectedTitle = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  PhoneTextField(
                    textEditingController: mobileController,
                    text: 'mobile'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.25,
                    textFieldWidth: MediaQuery.of(context).size.width * 0.2,
                    validationFunc: (val) {
                      if(val.isNotEmpty && val.length<9){
                        return '7_digits'.tr;
                      }return null;
                    },
                    onCodeSelected: (value) {
                      setState(() {
                        selectedMobileCode = value;
                      });
                    },
                    onChangedFunc: (value) {
                      setState(() {
                        // mainDescriptionController.text=value;
                      });
                    },
                  ),
                  // DialogTextField(
                  //   textEditingController: mobileController,
                  //   text: 'mobile'.tr,
                  //   rowWidth:  MediaQuery.of(context).size.width * 0.22,
                  //   textFieldWidth:  MediaQuery.of(context).size.width * 0.15,
                  //   validationFunc: (){},
                  //   onChangedFunc: (value){
                  //     setState(() {
                  //       // mainDescriptionController.text=value;
                  //     });
                  //   },),
                  DialogTextField(
                    textEditingController: streetController,
                    text: 'street'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.22,
                    textFieldWidth:
                    MediaQuery.of(context).size.width * 0.15,
                    validationFunc: (val) {},
                    // onChangedFunc: (value){
                    //   setState(() {
                    //     // mainDescriptionController.text=value;
                    //   });
                    // },
                  ),
                ],
              ),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DialogTextField(
                    textEditingController: jobPositionController,
                    text: 'job_position'.tr,
                    hint: 'Sales Director,Sales...',
                    rowWidth: MediaQuery.of(context).size.width * 0.22,
                    textFieldWidth:
                    MediaQuery.of(context).size.width * 0.15,
                    validationFunc: (val) {},
                  ),
                  DialogTextField(
                    textEditingController: emailController,
                    text: 'email'.tr,
                    hint: 'example@gmail.com',
                    rowWidth: MediaQuery.of(context).size.width * 0.25,
                    textFieldWidth: MediaQuery.of(context).size.width * 0.2,
                    validationFunc: (String value) {
                      if(value.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'check_format'.tr ;
                      }
                    },
                  ),
                  // DialogTextField(
                  //   textEditingController: cityController,
                  //   text: 'city'.tr,
                  //   rowWidth: MediaQuery.of(context).size.width * 0.22,
                  //   textFieldWidth:
                  //       MediaQuery.of(context).size.width * 0.15,
                  //   validationFunc: (val) {},
                  // ),
                  isCountriesFetched
                      ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('country'.tr),
                        DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * 0.15,
                          // requestFocusOnTap: false,
                          enableSearch: true,
                          controller: countryController,
                          hintText: '',
                          inputDecorationTheme: InputDecorationTheme(
                            // filled: true,
                            hintStyle: const TextStyle(
                                fontStyle: FontStyle.italic),
                            contentPadding:
                            const EdgeInsets.fromLTRB(20, 0, 25, 5),
                            // outlineBorder: BorderSide(color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                                  width: 2),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                          ),
                          // menuStyle: ,
                          menuHeight: 250,
                          dropdownMenuEntries: countriesNamesList
                              .map<DropdownMenuEntry<String>>(
                                  (String option) {
                                return DropdownMenuEntry<String>(
                                  value: option,
                                  label: option,
                                );
                              }).toList(),
                          enableFilter: true,
                          onSelected: (String? val) {
                            setState(() {
                              selectedCountry = val!;
                              getCitiesFromBack(val);
                            });
                          },
                        ),
                      ],
                    ),
                  )
                  // DialogDropMenu(
                  //   optionsList: countriesNamesList,
                  //   controller: countryController,
                  //   isDetectedHeight: true,
                  //   text: 'country'.tr,
                  //   hint: '',
                  //   rowWidth: MediaQuery.of(context).size.width * 0.22,
                  //   textFieldWidth: MediaQuery.of(context).size.width * 0.15,
                  //   onSelected: (val) {
                  //     setState(() {
                  //       selectedCountry = val;
                  //       getCitiesFromBack(val);
                  //     });
                  //   },
                  // )
                      :SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: loading()),
                ],
              ),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DialogTextField(
                    textEditingController: taxNumberController,
                    text: 'tax_number'.tr,
                    rowWidth: MediaQuery.of(context).size.width * 0.22,
                    textFieldWidth:
                    MediaQuery.of(context).size.width * 0.15,
                    validationFunc: (String val) {
                      if( selectedClientType==2&& val.isEmpty){
                        return 'required_field'.tr;
                      }
                      return null;
                    },
                  ),
                  DialogTextField(
                    textEditingController: websiteController,
                    text: 'website'.tr,
                    hint: 'www.example.com',
                    rowWidth: MediaQuery.of(context).size.width * 0.25,
                    textFieldWidth: MediaQuery.of(context).size.width * 0.2,
                    validationFunc: (String value) {
                      // if(value.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      //     .hasMatch(value)) {
                      //   return 'check_format'.tr ;
                      // }return null;
                    },
                  ),
                  // CountryTextField(
                  //   onChangedFunc: (val){},
                  //   validationFunc:  (val){},
                  //   text: 'country'.tr,
                  //   rowWidth: MediaQuery.of(context).size.width*0.22,
                  //   textFieldWidth: MediaQuery.of(context).size.width * 0.15,
                  //   textEditingController: TextEditingController(),
                  //   onCodeSelected: (val) {
                  //     setState(() {
                  //       selectedCountry = val;
                  //     });
                  //   },),
                  isCitiesFetched
                      ?SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('city'.tr),
                        DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width * 0.15,
                          // requestFocusOnTap: false,
                          enableSearch: true,
                          controller: cityController,
                          hintText: '',
                          inputDecorationTheme: InputDecorationTheme(
                            // filled: true,
                            hintStyle: const TextStyle(
                                fontStyle: FontStyle.italic),
                            contentPadding:
                            const EdgeInsets.fromLTRB(20, 0, 25, 5),
                            // outlineBorder: BorderSide(color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                                  width: 2),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(9)),
                            ),
                          ),
                          // menuStyle: ,
                          menuHeight: 250,
                          dropdownMenuEntries: citiesNamesList
                              .map<DropdownMenuEntry<String>>(
                                  (String option) {
                                return DropdownMenuEntry<String>(
                                  value: option,
                                  label: option,
                                );
                              }).toList(),
                          enableFilter: true,
                          onSelected: (String? val) {
                            setState(() {
                              selectedCity = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                  //     ? DialogDropMenu(
                  //   optionsList: citiesNamesList,
                  //   controller: cityController,
                  //   isDetectedHeight: true,
                  //   text: 'city'.tr,
                  //   hint:selectedCountry.isEmpty? 'select the country first':'',
                  //   rowWidth: MediaQuery.of(context).size.width*0.22,
                  //   textFieldWidth: MediaQuery.of(context).size.width * 0.15,
                  //   onSelected: (val) {
                  //     setState(() {
                  //       selectedCity = val;
                  //     });
                  //   },
                  // )
                      : SizedBox(
                      width: MediaQuery.of(context).size.width*0.22,
                      child: loading()),
                ],
              ),
              gapH40,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wrap(
                      spacing: 0.0,
                      direction: Axis.horizontal,
                      children: tabsList
                          .map((element) => ReusableBuildTabChipItem(
                        index: tabsList.indexOf(element),
                        isClicked:selectedTabIndex ==tabsList.indexOf(element),
                        name: element,
                        function: (){
                          setState(() {
                            selectedTabIndex = tabsList.indexOf(element);
                          });
                        },
                        // element['id'],
                        // element['name'],
                      ))
                          .toList()),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.01,
                    vertical: 25),
                height: 600,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  color: Colors.white,
                ),
                child:
                Column(
                  children: [
                    selectedTabIndex==0
                        ? Row(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context)
                    .size
                    .width *
                    0.25,
                          child: ReusableInputNumberField(
                            controller:
                            grantedDiscountController,
                            textFieldWidth:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.15,
                            rowWidth: MediaQuery.of(context)
                                .size
                                .width *
                                0.25,
                            onChangedFunc: (val) {},
                            validationFunc: (value) {},
                            text:'granted_discount'.tr,
                          ),
                        ),
                      ],
                    ):
                    selectedTabIndex==1
                        ?ContactsAndAddressesSection()
                        :selectedTabIndex == 2
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:
                          MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            children: [
                              GetBuilder<ClientController>(
                                  builder: (cont) {
                                    return DialogDropMenu(
                                      controller: cont.salesPersonController,
                                      optionsList:
                                      clientController
                                          .salesPersonListNames,
                                      text: 'sales_person'.tr,
                                      hint: 'search'.tr,
                                      rowWidth:
                                      MediaQuery.of(context).size.width *
                                          0.3,
                                      textFieldWidth:
                                      MediaQuery.of(context).size.width *
                                          0.17,
                                      onSelected: (String? val) {
                                        setState(() {
                                          var index = clientController
                                              .salesPersonListNames
                                              .indexOf(val!);
                                          clientController.setSelectedSalesPerson
                                            (val,
                                              clientController
                                                  .salesPersonListId[index]);
                                        });
                                      },
                                    );
                                  }
                              ),
                              gapH16,
                              DialogDropMenu(
                                optionsList: [''],
                                text: '${'payment_terms'.tr}*',
                                hint: '',
                                rowWidth:
                                MediaQuery.of(context).size.width *
                                    0.3,
                                textFieldWidth:
                                MediaQuery.of(context).size.width *
                                    0.17,
                                onSelected: (val) {
                                  setState(() {
                                    paymentTerm = val;
                                  });
                                },
                              ),
                              gapH16,
                              DialogDropMenu(
                                controller: priceListController,
                                optionsList:pricesListsCodes ,
                                text: 'pricelist'.tr,
                                hint: '',
                                rowWidth:
                                MediaQuery.of(context).size.width *
                                    0.3,
                                textFieldWidth:
                                MediaQuery.of(context).size.width *
                                    0.17,
                                onSelected: (val) {
                                  var index=pricesListsCodes.indexOf(val);
                                  setState(() {
                                    selectedPriceListId = pricesListsIds[index];
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : selectedTabIndex == 3
                        ? SizedBox()
                        : CarsSection(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                priceListController.clear();
                                selectedClientType=1;
                                selectedPhoneCode = '';
                                selectedMobileCode = '';
                                paymentTerm = ''; selectedPriceListId = ''; selectedCountry = '';
                                grantedDiscountController.clear();
                                clientNameController.clear();
                                referenceController.clear();
                                internalNoteController.clear();
                                websiteController.clear();
                                phoneController.clear();
                                floorBldgController.clear();
                                titleController.clear();
                                mobileController.clear();
                                taxNumberController.clear();
                                cityController.clear();
                                countryController.clear();
                                selectedCountry='';
                                selectedCity='';
                                emailController.clear();
                                jobPositionController.clear();
                                streetController.clear();
                                isBlockedChecked=false;
                                isActiveInPosChecked=false;
                                grantedDiscountController.clear();
                              });
                            },
                            child: Text(
                              'discard'.tr,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Primary.primary),
                            )),
                        gapW24,
                        ReusableButtonWithColor(
                            btnText: 'save'.tr,
                            onTapFunction: () async {
                              if (_formKey.currentState!.validate()) {
                                var res = await storeClient(
                                    referenceController.text,
                                    isActiveInPosChecked?'1':'0',
                                    grantedDiscountController.text,
                                    isBlockedChecked?'1':'0',
                                    selectedClientType == 1
                                        ? 'individual'
                                        : 'company',
                                    clientNameController.text,
                                    clientNumberController.text,
                                    selectedCountry,
                                    selectedCity,
                                    '',
                                    '',
                                    streetController.text,
                                    floorBldgController.text,
                                    jobPositionController.text,
                                    selectedPhoneCode.isEmpty?'+961':selectedPhoneCode,
                                    phoneController.text,
                                    selectedMobileCode.isEmpty?'+961':selectedMobileCode,
                                    mobileController.text,
                                    emailController.text,
                                    titleController.text,
                                    '',
                                    taxNumberController.text,
                                    websiteController.text,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    clientController.selectedSalesPersonId.toString(),
                                    paymentTerm,
                                    selectedPriceListId,
                                    internalNoteController.text,
                                    '',
                                    clientController.contactsList);
                                if (res['success'] == true) {
                                  clientController.getAllClientsFromBack();
                                  Get.back();
                                  CommonWidgets.snackBar('Success',
                                      res['message'] );
                                  // Get.back();
                                  // homeController.selectedTab.value =
                                  // 'clients';
                                } else {
                                  CommonWidgets.snackBar(
                                      'error', res['message'] );
                                }
                              }
                            },
                            width: 100,
                            height: 35),
                      ],
                    )
                  ],
                )
                ,
              )
            ],
          ),
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

}


class DialogTextField extends StatelessWidget {
  const DialogTextField({
    super.key,
    this.onChangedFunc,
    required this.validationFunc,
    required this.text,
    required this.rowWidth,
    required this.textFieldWidth,
    required this.textEditingController,
    this.hint = '',
    this.isPassword = false,
    this.globalKey,
    this.read = false,
  });
  final Function(String)? onChangedFunc;
  final Function validationFunc;
  final String text;
  final String hint;
  final double rowWidth;
  final double textFieldWidth;
  final TextEditingController textEditingController;
  final bool isPassword;
  final GlobalKey? globalKey;
  final bool read;

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return SizedBox(
      width: rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: rowWidth - textFieldWidth, child: Text(text)),
          SizedBox(
            width: textFieldWidth,
            child: TextFormField(
              key: globalKey,
              readOnly: read,
              cursorColor: Colors.black,
              obscureText: isPassword,
              controller: textEditingController,
              decoration: InputDecoration(
                // isDense: true,
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding:
                homeController.isMobile.value
                    ? const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 10.0,
                )
                    : const EdgeInsets.fromLTRB(20, 15, 25, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                errorStyle: const TextStyle(fontSize: 10.0, color: Colors.red),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
              ),
              validator: (value) {
                return validationFunc(value);
              },
              onChanged: (value) => onChangedFunc!(value),
            ),
          ),
        ],
      ),
    );
  }
}



class ContactsAndAddressesSection extends StatefulWidget {
  const ContactsAndAddressesSection({super.key});

  @override
  State<ContactsAndAddressesSection> createState() =>
      _ContactsAndAddressesSectionState();
}

class _ContactsAndAddressesSectionState
    extends State<ContactsAndAddressesSection> {
  ClientController clientController = Get.find();
  addNewContact() {
    Map contact = {
      'type': '1',
      'name': '',
      'title': '',
      'jobPosition': '',
      'deliveryAddress': '',
      'phoneCode': '+961',
      'phoneNumber': '',
      'extension': '',
      'mobileCode': '+961',
      'mobileNumber': '',
      'email': '',
      'note': '',
      'internalNote': '',
    };
    clientController.addToContactsList(contact);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (cont) {
        return Column(
          children: [
            SizedBox(
              height: cont.contactsList.isEmpty ? 20 : 420,
              child: ListView.builder(
                itemCount: cont.contactsList.length,
                itemBuilder:
                    (context, index) => ReusableContactSection(index: index),
              ),
            ),
            gapH16,
            ReusableAddCard(
              text: 'add_new_contact'.tr,
              onTap: () {
                addNewContact();
              },
            ),
          ],
        );
      },
    );
  }
}

class ReusableContactSection extends StatefulWidget {
  const ReusableContactSection({super.key, required this.index});
  final int index;
  @override
  State<ReusableContactSection> createState() => _ReusableContactSectionState();
}

class _ReusableContactSectionState extends State<ReusableContactSection> {
  ClientController clientController = Get.find();
  String selectedContactsPhoneCode = '', selectedContactsMobileCode = '';
  int selectedContactAndAddressType = 1;
  String selectedContactsTitle = '';
  List<String> titles = ['Doctor', 'Miss', 'Mister', 'Maitre', 'Professor'];

  TextEditingController contactsNameController = TextEditingController();
  TextEditingController contactsPhoneController = TextEditingController();
  TextEditingController contactsTitleController = TextEditingController();
  TextEditingController contactsMobileController = TextEditingController();
  TextEditingController contactsJobPositionController = TextEditingController();
  TextEditingController contactsAddressController = TextEditingController();
  TextEditingController contactsEmailController = TextEditingController();
  TextEditingController contactsNoteController = TextEditingController();
  TextEditingController contactsExtController = TextEditingController();
  @override
  void initState() {
    // selectedContactAndAddressType=int.parse('${clientController.contactsList[widget.index]['type']??1}');
    selectedContactsPhoneCode =
        clientController.contactsList[widget.index]['phoneCode'] ?? '+961';
    selectedContactsMobileCode =
        clientController.contactsList[widget.index]['mobileCode'] ?? '+961';
    contactsNameController.text =
    clientController.contactsList[widget.index]['name'];
    contactsTitleController.text =
    clientController.contactsList[widget.index]['title'];
    selectedContactsTitle =
    clientController.contactsList[widget.index]['title'];
    contactsPhoneController.text =
    clientController.contactsList[widget.index]['phoneNumber'];
    contactsMobileController.text =
    clientController.contactsList[widget.index]['mobileNumber'];
    contactsJobPositionController.text =
    clientController.contactsList[widget.index]['jobPosition'];
    contactsAddressController.text =
    clientController.contactsList[widget.index]['deliveryAddress'];
    contactsEmailController.text =
    clientController.contactsList[widget.index]['email'];
    contactsNoteController.text =
    clientController.contactsList[widget.index]['internalNote'];
    contactsExtController.text =
    clientController.contactsList[widget.index]['extension'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (cont) {
        return Container(
          margin: const EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Primary.primary.withAlpha((0.2 * 255).toInt()),
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.15,
              //       child: ListTile(
              //         title: Text(
              //           'contact'.tr,
              //           style: const TextStyle(fontSize: 12),
              //         ),
              //         leading: Radio(
              //           value: 1,
              //           groupValue: selectedContactAndAddressType,
              //           onChanged: (value) {
              //             setState(() {
              //               selectedContactAndAddressType = value!;
              //             });
              //             cont.updateContactType(widget.index,'${value!}');
              //           },
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.15,
              //       child: ListTile(
              //         title: Text(
              //           'delivery_address'.tr,
              //           style: const TextStyle(fontSize: 12),
              //         ),
              //         leading: Radio(
              //           value: 2,
              //           groupValue: selectedContactAndAddressType,
              //           onChanged: (value) {
              //             setState(() {
              //               selectedContactAndAddressType = value!;
              //             });
              //             cont.updateContactType(widget.index,'${value!}');
              //           },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // gapH10,
              Text(
                'Contact Selection used to add the contact information of personnel within the company (e.g., CEO, CFO, ...).',
              ),
              gapH28,
              GetBuilder<HomeController>(
                  builder: (homeCont) {

                    double miniRowWidth=homeCont.isTablet? MediaQuery.of(context).size.width * 0.19:MediaQuery.of(context).size.width * 0.25;
                    double smallRowWidth=homeCont.isTablet? MediaQuery.of(context).size.width * 0.22:MediaQuery.of(context).size.width * 0.27;
                    double smallTextFieldWidth=homeCont.isTablet?
                    MediaQuery.of(context).size.width * 0.15
                        : MediaQuery.of(context).size.width * 0.19;
                    double middleRowWidth=homeCont.isTablet? MediaQuery.of(context).size.width * 0.25:MediaQuery.of(context).size.width * 0.29;
                    double middleTextFieldWidth=homeCont.isTablet?
                    MediaQuery.of(context).size.width * 0.2
                        : MediaQuery.of(context).size.width * 0.25;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DialogTextField(
                              textEditingController: contactsNameController,
                              text: 'name'.tr,
                              rowWidth:smallRowWidth,
                              textFieldWidth:smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateContactName(widget.index, val);
                              },
                            ),
                            PhoneTextField(
                              textEditingController: contactsPhoneController,
                              text: 'phone'.tr,
                              // initialValue: selectedContactsPhoneCode,
                              rowWidth:middleRowWidth,
                              textFieldWidth:middleTextFieldWidth,
                              validationFunc: (String val) {
                                if (val.isNotEmpty && val.length < 7) {
                                  return '7_digits'.tr;
                                }
                                return null;
                              },
                              onCodeSelected: (value) {
                                cont.updateContactPhoneCode(widget.index, '$value');
                                setState(() {
                                  selectedContactsPhoneCode = value;
                                });
                              },
                              onChangedFunc: (value) {
                                cont.updateContactPhoneNumber(widget.index, '$value');
                              },
                            ),
                            DialogTextField(
                              textEditingController: contactsExtController,
                              text: 'ext'.tr,
                              rowWidth: miniRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateContactExtension(widget.index, val);
                              },
                            ),
                          ],
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: smallRowWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('title'.tr),
                                  DropdownMenu<String>(
                                    width: smallTextFieldWidth,
                                    // requestFocusOnTap: false,
                                    enableSearch: true,
                                    controller: contactsTitleController,
                                    hintText: 'Doctor, Miss, Mister',
                                    inputDecorationTheme: InputDecorationTheme(
                                      // filled: true,
                                      hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        25,
                                        5,
                                      ),
                                      // outlineBorder: BorderSide(color: Colors.black,),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.2 * 255).toInt(),
                                          ),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.4 * 255).toInt(),
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                    ),
                                    // menuStyle: ,
                                    menuHeight: 250,
                                    dropdownMenuEntries:
                                    titles.map<DropdownMenuEntry<String>>((
                                        String option,
                                        ) {
                                      return DropdownMenuEntry<String>(
                                        value: option,
                                        label: option,
                                      );
                                    }).toList(),
                                    enableFilter: true,
                                    onSelected: (String? val) {
                                      setState(() {
                                        selectedContactsTitle = val!;
                                      });
                                      cont.updateContactTitle(widget.index, val!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            PhoneTextField(
                              textEditingController: contactsMobileController,
                              text: 'mobile'.tr,
                              // initialValue: selectedContactsMobileCode,
                              rowWidth:middleRowWidth,
                              textFieldWidth:middleTextFieldWidth,
                              validationFunc: (val) {
                                if (val.isNotEmpty && val.length < 9) {
                                  return '7_digits'.tr;
                                }
                                return null;
                              },
                              onCodeSelected: (value) {
                                setState(() {
                                  selectedContactsMobileCode = value;
                                });
                                cont.updateContactMobileCode(widget.index, '${value!}');
                              },
                              onChangedFunc: (value) {
                                cont.updateContactMobileNumber(widget.index, '${value!}');
                              },
                            ),
                            DialogTextField(
                              textEditingController: contactsAddressController,
                              text: 'address'.tr,
                              rowWidth: miniRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateContactDeliveryAddress(widget.index, val);
                              },
                            ),
                          ],
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DialogTextField(
                              textEditingController: contactsJobPositionController,
                              text: 'job_position'.tr,
                              hint: 'Sales Director,Sales...',
                              rowWidth:smallRowWidth,
                              textFieldWidth:smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateContactJobPosition(widget.index, val);
                              },
                            ),
                            DialogTextField(
                              textEditingController: contactsEmailController,
                              text: 'email'.tr,
                              hint: 'example@gmail.com',
                              rowWidth:middleRowWidth,
                              textFieldWidth:middleTextFieldWidth,
                              validationFunc: (String value) {
                                if (value.isNotEmpty &&
                                    !RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                    ).hasMatch(value)) {
                                  return 'check_format'.tr;
                                }
                              },
                              onChangedFunc: (val) {
                                cont.updateContactEmail(widget.index, val);
                              },
                            ),
                            SizedBox(width: miniRowWidth),
                          ],
                        ),
                      ],
                    );
                  }
              ),
              gapH48,
              TextField(
                controller: contactsNoteController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'note.....',
                  hintStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      width: 1,
                      color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                    ),
                  ),
                ),
                onChanged: (val) {
                  cont.updateContactNote(widget.index, val);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}



class CarsSection extends StatefulWidget {
  const CarsSection({super.key});

  @override
  State<CarsSection> createState() =>
      _CarsSectionState();
}

class _CarsSectionState
    extends State<CarsSection> {
  ClientController clientController = Get.find();
  addNewCar() {
    Map car = {
      'odometer': '',
      'registration': '',//unique
      'year': '',
      'color': '',
      'model': '',
      'brand': '',
      'chassis_no': '',//number
      'rating': '',
      'comment': '',
      'car_fax': '',
      'technician':''
    };
    clientController.addToCarsList(car);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (cont) {
        return Column(
          children: [
            SizedBox(
              height: cont.carsList.isEmpty ? 20 : 360,
              child: ListView.builder(
                itemCount: cont.carsList.length,
                itemBuilder:
                    (context, index) => ReusableCarSection(index: index),
              ),
            ),
            gapH16,
            ReusableAddCard(
              text: 'add_new_car'.tr,
              onTap: () {
                addNewCar();
                // print('addCar');
                // print(cont.carsList);
              },
            ),
          ],
        );
      },
    );
  }
}

class ReusableCarSection extends StatefulWidget {
  const ReusableCarSection({super.key, required this.index});
  final int index;
  @override
  State<ReusableCarSection> createState() => _ReusableCarSectionState();
}

class _ReusableCarSectionState extends State<ReusableCarSection> {
  ClientController clientController = Get.find();
  String selectedYear = '', selectedModel = '', selectedColor = '',selectedBrand = '', selectedRating = '',selectedTechnician = '';
  List<String> years = [];
  TextEditingController faxController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  TextEditingController technicianController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController chassisNoController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  @override
  void initState() {
    years = generateYears();
    technicianController.text =
    clientController.carsList[widget.index]['technician'];
    odometerController.text =
    clientController.carsList[widget.index]['odometer'];
    colorController.text =
    clientController.carsList[widget.index]['color'];
    chassisNoController.text =
    clientController.carsList[widget.index]['chassis_no'];
    registrationController.text =
    clientController.carsList[widget.index]['registration'];
    brandController.text =
    clientController.carsList[widget.index]['brand'];
    commentController.text =
    clientController.carsList[widget.index]['comment'];
    modelController.text =
    clientController.carsList[widget.index]['model'];
    yearController.text =
    clientController.carsList[widget.index]['year'];
    ratingController.text =
    clientController.carsList[widget.index]['rating'];
    faxController.text =
    clientController.carsList[widget.index]['car_fax'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (cont) {
        return Container(
          margin: const EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Primary.primary.withAlpha((0.2 * 255).toInt()),
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // gapH28,
              GetBuilder<HomeController>(
                  builder: (homeCont) {
                    double smallRowWidth=homeCont.isTablet? MediaQuery.of(context).size.width * 0.22:MediaQuery.of(context).size.width * 0.27;
                    double smallTextFieldWidth=homeCont.isTablet?
                    MediaQuery.of(context).size.width * 0.15
                        : MediaQuery.of(context).size.width * 0.19;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DialogTextField(
                              textEditingController: registrationController,
                              text: 'registration'.tr,
                              rowWidth: smallRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateCarRegistration(widget.index, val);
                              },
                            ),
                            DialogTextField(
                              textEditingController: chassisNoController,
                              text: 'chassis_no'.tr,
                              hint: '',
                              rowWidth:smallRowWidth,
                              textFieldWidth:smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateCarChassisNo(widget.index, val);
                              },
                            ),
                            DialogTextField(
                              textEditingController: faxController,
                              text: 'car_fax'.tr,
                              rowWidth:smallRowWidth,
                              textFieldWidth:smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateCarFax(widget.index, val);
                              },
                            ),
                          ],
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableDropDownMenuWithSearch(
                              list: carBrands,
                              text: 'brand'.tr,
                              hint: '${'search'.tr}...',
                              controller: brandController,
                              onSelected: (String? val) {
                                setState(() {
                                  selectedBrand=val!;
                                });
                                cont.updateCarBrand(widget.index, val!);
                              },
                              validationFunc: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'select_option'.tr;
                                }
                                return null;
                              },
                              rowWidth: smallRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              clickableOptionText:
                              'create_new_brand'.tr,
                              isThereClickableOption: false,
                              onTappedClickableOption: () {
                                // showDialog<String>(
                                //   context: context,
                                //   builder:
                                //       (
                                //       BuildContext context,
                                //       ) => const AlertDialog(
                                //     backgroundColor: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius:
                                //       BorderRadius.all(
                                //         Radius.circular(9),
                                //       ),
                                //     ),
                                //     elevation: 0,
                                //     content: CreateBrandDialog(),
                                //   ),
                                // );
                              },
                            ),
                            ReusableDropDownMenuWithSearch(
                              list: carModels,
                              text: 'model'.tr,
                              hint: '${'search'.tr}...',
                              controller: modelController,
                              onSelected: (String? val) {
                                setState(() {
                                  selectedModel=val!;
                                });
                                cont.updateCarModel(widget.index, val!);
                              },
                              validationFunc: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'select_option'.tr;
                                }
                                return null;
                              },
                              rowWidth: smallRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              clickableOptionText:
                              'create_new_model'.tr,
                              isThereClickableOption: false,
                              onTappedClickableOption: () {
                                // showDialog<String>(
                                //   context: context,
                                //   builder:
                                //       (
                                //       BuildContext context,
                                //       ) => const AlertDialog(
                                //     backgroundColor: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius:
                                //       BorderRadius.all(
                                //         Radius.circular(9),
                                //       ),
                                //     ),
                                //     elevation: 0,
                                //     content: CreateModelDialog(),
                                //   ),
                                // );
                              },
                            ),
                            SizedBox(
                              width: smallRowWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('year'.tr),
                                  DropdownMenu<String>(
                                    width: smallTextFieldWidth,
                                    enableSearch: true,
                                    controller: yearController,
                                    hintText: '${'search'.tr}...',
                                    inputDecorationTheme: InputDecorationTheme(
                                      hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        25,
                                        5,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.2 * 255).toInt(),
                                          ),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.4 * 255).toInt(),
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                    ),
                                    menuHeight: 250,
                                    dropdownMenuEntries:
                                    years.map<DropdownMenuEntry<String>>((
                                        String option,
                                        ) {
                                      return DropdownMenuEntry<String>(
                                        value: option,
                                        label: option,
                                      );
                                    }).toList(),
                                    enableFilter: true,
                                    onSelected: (String? val) {
                                      setState(() {
                                        selectedYear = val!;
                                      });
                                      cont.updateCarYear(widget.index, val!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableDropDownMenuWithSearch(
                              list: carColors,
                              text: 'color'.tr,
                              hint: '${'search'.tr}...',
                              controller: colorController,
                              onSelected: (String? val) {
                                setState(() {
                                  selectedColor=val!;
                                });
                                cont.updateCarColor(widget.index, val!);
                              },
                              validationFunc: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'select_option'.tr;
                                }
                                return null;
                              },
                              rowWidth: smallRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              clickableOptionText:
                              'create_new_color'.tr,
                              isThereClickableOption: false,
                              onTappedClickableOption: () {
                                // showDialog<String>(
                                //   context: context,
                                //   builder:
                                //       (
                                //       BuildContext context,
                                //       ) => const AlertDialog(
                                //     backgroundColor: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius:
                                //       BorderRadius.all(
                                //         Radius.circular(9),
                                //       ),
                                //     ),
                                //     elevation: 0,
                                //     content: CreateColorDialog(),
                                //   ),
                                // );
                              },
                            ),
                            SizedBox(
                              width: smallRowWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('rating'.tr),
                                  DropdownMenu<String>(
                                    width: smallTextFieldWidth,
                                    enableSearch: true,
                                    controller: ratingController,
                                    hintText: '${'search'.tr}...',
                                    inputDecorationTheme: InputDecorationTheme(
                                      hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        25,
                                        5,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.2 * 255).toInt(),
                                          ),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Primary.primary.withAlpha(
                                            (0.4 * 255).toInt(),
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                    ),
                                    menuHeight: 250,
                                    dropdownMenuEntries:
                                    carRatings.map<DropdownMenuEntry<String>>((
                                        String option,
                                        ) {
                                      return DropdownMenuEntry<String>(
                                        value: option,
                                        label: option,
                                      );
                                    }).toList(),
                                    enableFilter: true,
                                    onSelected: (String? val) {
                                      setState(() {
                                        selectedRating = val!;
                                      });
                                      cont.updateCarRating(widget.index, val!);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            DialogTextField(
                              textEditingController: odometerController,
                              text: 'odometer'.tr,
                              rowWidth:smallRowWidth,
                              textFieldWidth:smallTextFieldWidth,
                              validationFunc: (val) {},
                              onChangedFunc: (val) {
                                cont.updateCarOdometer(widget.index, val);
                              },
                            ),

                          ],
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableDropDownMenuWithSearch(
                              list: carTechnician,
                              text: 'technician'.tr,
                              hint: '${'search'.tr}...',
                              controller: technicianController,
                              onSelected: (String? val) {
                                setState(() {
                                  selectedTechnician=val!;
                                });
                                cont.updateCarTechnician(widget.index, val!);
                              },
                              validationFunc: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'select_option'.tr;
                                }
                                return null;
                              },
                              rowWidth: smallRowWidth,
                              textFieldWidth: smallTextFieldWidth,
                              clickableOptionText:
                              'add_new_technician'.tr,
                              isThereClickableOption: false,
                              onTappedClickableOption: () {
                                // showDialog<String>(
                                //     context: context,
                                //     builder: (BuildContext context) => AlertDialog(
                                //       backgroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //         BorderRadius.all(Radius.circular(9)),
                                //       ),
                                //       elevation: 0,
                                //       content:AddGarageAttributeDialog(text: 'technician',),
                                //       // content:widget.idDesktop? const CreateCategoryDialogContent(): const MobileCreateCategoryDialogContent(),
                                //     ));
                              },
                            ),
                            SizedBox(
                              width: smallRowWidth,
                            ),
                            SizedBox(
                              width: smallRowWidth,
                            ),
                          ],
                        ),
                        gapH10,
                      ],
                    );
                  }
              ),
              gapH10,
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'comment.....',
                  hintStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                      width: 1,
                      color: Primary.primary.withAlpha((0.4 * 255).toInt()),
                    ),
                  ),
                ),
                onChanged: (val) {
                  cont.updateContactNote(widget.index, val);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}




