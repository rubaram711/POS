import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/client_controller.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/page_title.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';

TextEditingController searchInCarsController = TextEditingController();

class CustomersCarsDialog extends StatefulWidget {
  const CustomersCarsDialog({super.key});

  @override
  State<CustomersCarsDialog> createState() =>
      _CustomersCarsDialogState();
}

class _CustomersCarsDialogState
    extends State<CustomersCarsDialog> {
  ProductController productController = Get.find();
  HomeController homeController = Get.find();
  ClientController clientController = Get.find();



  String searchValue = '';
  Timer? searchOnStoppedTyping;

  List copyFromCarsList=[];
  void _filterCars(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();
      List filteredCars = copyFromCarsList.where((car) {
        return (car["plate_number"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["model_name"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["brand_name"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["color_name"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["chassis_number"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["comment"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["car_fax"] ?? "").toString().toLowerCase().contains(lowerQuery) ||
            (car["year"] ?? "").toString().contains(lowerQuery) ||
            (car["odometer"] ?? "").toString().contains(lowerQuery) ||
            (car["tech_name"] ?? "").toString().contains(lowerQuery) ||
            (car["rating"] ?? "").toString().contains(lowerQuery);
      }).toList();
      clientController.setSelectedCustomerCarsList(filteredCars);
    });
  }

  @override
  void initState() {
    copyFromCarsList=clientController.carsListForSelectedCustomer;
    searchInCarsController.text='';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
        builder: (cont) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.95,
            padding:   EdgeInsets.symmetric(horizontal: 10, vertical:homeController.isTablet? 0 : 10),
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageTitle(text: '${cont.selectedCustomerObject['name']} ${'cars'.tr}'),
                    DialogTextFieldWithoutText(
                      hint: 'search'.tr,
                      textEditingController: searchInCarsController,
                      textFieldWidth:homeController.isTablet? MediaQuery.of(context).size.width * 0.25 :MediaQuery.of(context).size.width * 0.15,
                      validationFunc: (value) {},
                      onIconClickedFunc: () {},
                      onCloseIconClickedFunc: () {
                        searchInCarsController.clear();
                        clientController.setSelectedCustomerCarsList(copyFromCarsList);
                      },
                      onChangedFunc: (val) async {
                        _filterCars(val);
                      },
                      radius: 20,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('registration'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('chassis_no'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('car_fax'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('model'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('brand'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('color'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('rating'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('odometer'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child: Text('technician'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: Text('year'.tr),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.separated(
                    itemCount: cont.carsListForSelectedCustomer.length,
                    itemBuilder: (context, index) => CarCard(
                      info: cont.carsListForSelectedCustomer[index],
                      onCarTapped: (){
                        print('6666 ${cont.carsListForSelectedCustomer[index]}');
                        cont.setSelectedCustomerCarBeforeOk(cont.carsListForSelectedCustomer[index]);
                      },
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap:cont.selectedCarBeforeOK.isNotEmpty? () {
                          cont.setSelectedCustomerIdWithOk();
                          cont.setSelectedCustomerCar(cont.selectedCarBeforeOK);
                          productController.setSelectedDiscountTypeId('-1');
                          Get.back();
                          Get.back();
                      }:null,
                      child: Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color:cont.selectedCustomerId=='-1'
                              ? Primary.primary.withAlpha((0.7 * 255).toInt()): Primary.primary,
                          border: Border.all(
                            color:cont.selectedCustomerId=='-1'
                                ? Primary.primary.withAlpha((0.7 * 255).toInt())
                                : Primary.p0,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            'ok'.tr,
                            style: TextStyle(fontSize: 14, color: Primary.p0),
                          ),
                        ),
                      ),
                    ),
                    // gapW16,
                    // ReusableButtonWithColor(
                    //     radius: 9,
                    //     btnText: 'discard'.tr,
                    //     onTapFunction: () {
                    //       productController.setSelectedCustomerId('-1');
                    //       productController.setSelectedCustomerObject({});
                    //       productController.setSelectedCustomerIdWithOk();
                    //       searchInCarsController.clear();
                    //       paymentController.getAllClientsFromBack();
                    //       productController.setSelectedDiscountTypeId('0');
                    //     },
                    //     width: 100,
                    //     height: 35),
                    gapW16,
                    ReusableButtonWithColor(
                        radius: 9,
                        btnText: 'close'.tr,
                        onTapFunction: () {
                          searchInCarsController.clear();
                          Get.back();
                        },
                        width: 100,
                        height: 35),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}

class CarCard extends StatefulWidget {
  const CarCard({super.key, required this.info, required this.onCarTapped});
  final Map info;
  final Function onCarTapped;
  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  bool isHovered=false;
  HomeController homeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
        builder: (cont) {
          return InkWell(
            onTap: (){
              widget.onCarTapped();
            },
            onHover: (val) {
              if (val) {
                setState(() {
                  isHovered = true;
                });
              } else {
                setState(() {
                  isHovered = false;
                });
              }
            },
            child: Container(
              color:'${cont.selectedCarBeforeOK.isNotEmpty?cont.selectedCarBeforeOK['id']:''}'== '${widget.info['id']}' ? Primary.primary.withAlpha((0.2 * 255).toInt()) :isHovered? Primary.primary.withAlpha((0.2 * 255).toInt()) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        '${widget.info['plate_number']??''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        '${widget.info['chassis_number']??''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        '${widget.info['car_fax']??''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        widget.info['model_name']??'',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        widget.info['brand_name']??'',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        widget.info['color_name']??'',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        widget.info['rating']??'',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        '${widget.info['odometer']??''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Text(
                        widget.info['tech_name']??'',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Text(
                        '${widget.info['year']??''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

