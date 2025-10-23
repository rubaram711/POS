import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/payment_controller.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/page_title.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import 'add_new_customer_dialog.dart';
import 'customer_cars_dialog.dart';

TextEditingController searchInCustomersController = TextEditingController();

class CustomersDialog extends StatefulWidget {
  const CustomersDialog({super.key});

  @override
  State<CustomersDialog> createState() =>
      _CustomersDialogState();
}

class _CustomersDialogState
    extends State<CustomersDialog> {
  ClientController clientController = Get.find();
  ProductController productController = Get.find();
  HomeController homeController = Get.find();

  setTabsList() async{
    var isItGarageVar= await getIsItGarageFromPref();
    if(isItGarageVar=='1'){
      homeController.isItGarage=true;
    }
  }

  String searchValue = '';
  Timer? searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    setState(() {
      searchValue = value;
      clientController.isClientsFetched = false;
      clientController.customersList = [];
    });
    await clientController.getAllClientsFromBack();
  }

  @override
  void initState() {
    searchInCustomersController.text='';
    clientController.getAllClientsFromBack();
    setTabsList();
    // paymentController.setSelectedCustomerId('-1');
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
          child: cont.isClientsFetched
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PageTitle(text: 'customers'.tr),
                            gapW10,
                            ReusableButtonWithColor(
                              btnText: 'add'.tr,
                              onTapFunction: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertDialog(
                                          backgroundColor: Colors.white,
                                          // contentPadding: EdgeInsets.all(0),
                                          // titlePadding: EdgeInsets.all(0),
                                          // actionsPadding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9)),
                                          ),
                                          elevation: 0,
                                          content: CreateClientDialog(),
                                        )
                                );
                              },
                              width:homeController.isTablet? MediaQuery.of(context).size.width * 0.1 : MediaQuery.of(context).size.width * 0.05,
                              height: 45,
                              radius: 9,
                            ),
                          ],
                        ),
                        DialogTextFieldWithoutText(
                          hint: 'search'.tr,
                          textEditingController: searchInCustomersController,
                          textFieldWidth:homeController.isTablet? MediaQuery.of(context).size.width * 0.25 :MediaQuery.of(context).size.width * 0.15,
                          validationFunc: (value) {},
                          onIconClickedFunc: () {},
                          onCloseIconClickedFunc: () {
                            searchInCustomersController.clear();
                            clientController.getAllClientsFromBack();
                          },
                          onChangedFunc: (val) async {
                            _onChangeHandler(val);
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
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Text('name'.tr),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Text('address'.tr),
                          ),
                          SizedBox(
                            width:homeController.isTablet? MediaQuery.of(context).size.width * 0.3:MediaQuery.of(context).size.width * 0.4,
                            child: Text('contact'.tr),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.separated(
                        itemCount: cont.customersList.length,
                        itemBuilder: (context, index) => CustomerCard(
                          customer: cont.customersList[index],
                          onCustomerTapped: (){},
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
                          onTap:cont.selectedCustomerId!='-1'? () {
                            if(!homeController.isItGarage || '${cont.selectedCustomerObject['cars']??''}'=='[]') {
                              cont.setSelectedCustomerIdWithOk();
                              productController.setSelectedDiscountTypeId('-1');
                              Get.back();
                            }else {
                              cont.setSelectedCustomerCarsList(cont.selectedCustomerObject['cars']??const []);
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(9)),
                                    ),
                                    elevation: 0,
                                    content: CustomersCarsDialog(),
                                  ));
                            } }:null,
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
                                homeController.isItGarage && cont.selectedCustomerObject.isNotEmpty && '${cont.selectedCustomerObject['cars']??''}'!='[]'?'select_car'.tr:'ok'.tr,
                                style: TextStyle(fontSize: 14, color: Primary.p0),
                              ),
                            ),
                          ),
                        ),
                        gapW16,
                        ReusableButtonWithColor(
                            radius: 9,
                            btnText: 'discard'.tr,
                            onTapFunction: () {
                              cont.setSelectedCustomerId('-1');
                              cont.setSelectedCustomerObject({});
                              productController.setTotalDiscountAsPercent(0);
                              productController.calculateSummary();
                              cont.setSelectedCustomerIdWithOk();
                                searchInCustomersController.clear();
                                clientController.getAllClientsFromBack();
                                productController.setSelectedDiscountTypeId('0');
                            },
                            width: 100,
                            height: 35),
                        gapW16,
                        ReusableButtonWithColor(
                            radius: 9,
                            btnText: 'close'.tr,
                            onTapFunction: () {
                              // if(paymentController.selectedCustomerIdWithOk=='-1') {
                              //   paymentController.setSelectedCustomerId('-1');
                              // }
                              searchInCustomersController.clear();
                              clientController.getAllClientsFromBack();
                              Get.back();
                            },
                            width: 100,
                            height: 35),
                      ],
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      }
    );
  }
}

class CustomerCard extends StatefulWidget {
  const CustomerCard({super.key, required this.customer, required this.onCustomerTapped});
  final Map customer;
  final Function onCustomerTapped;
  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  bool isHovered=false;
  HomeController homeController=Get.find();
  PaymentController paymentController=Get.find();
  ProductController productController=Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (cont) {
        return InkWell(
          onTap: (){
            cont.setSelectedCustomerId('${widget.customer['id']}');
            cont.setSelectedCustomerObject(widget.customer);
            productController.setTotalDiscountAsPercent(double.parse('${widget.customer['grantedDiscount']??widget.customer['granted_discount']??'0'}'));
            productController.calculateSummary();
            // paymentController.setSelectedCustomerCarsList(widget.customer['cars']);
            widget.onCustomerTapped();
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

            color:cont.selectedCustomerId== '${widget.customer['id']}' ? Primary.primary.withAlpha((0.2 * 255).toInt()) :isHovered? Primary.primary.withAlpha((0.2 * 255).toInt()) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                      widget.customer['name']??'',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(
                        widget.customer['country']!=null && widget.customer['city']!=null
                            ? '${widget.customer['country']??''}-${widget.customer['city']??''}'
                            : widget.customer['country']!=null  && widget.customer['city']==null
                                ?'${widget.customer['country']??''}'
                                :''),
                  ),
                  SizedBox(
                    width:homeController.isTablet? MediaQuery.of(context).size.width * 0.3: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      children: [
                        widget.customer['mobileNumber']!=null
                            ? Row(
                          children: [
                            const Icon(Icons.phone,size: 15,),
                            gapW8,
                            Text('(${widget.customer['mobileCode']})-${widget.customer['mobileNumber']}'
                            ),
                          ],
                        ):const SizedBox(),
                          widget.customer['email']!=null? Row(
                          children: [
                            const Icon(Icons.send,size: 15,),
                            gapW8,
                            Text(widget.customer['email']??''),
                          ],
                        ):const SizedBox(),
                      ],
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

