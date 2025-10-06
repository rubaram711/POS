import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/orders/delete_order.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/orders_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/reusable_text_field.dart';
import 'dart:async';

class OrdersDialog extends StatefulWidget {
  const OrdersDialog({super.key});

  @override
  State<OrdersDialog> createState() =>
      _OrdersDialogState();
}

class _OrdersDialogState
    extends State<OrdersDialog> {
  final TextEditingController filterController = TextEditingController();

  final OrdersController ordersController = Get.find();
  final HomeController homeController = Get.find();

  bool isArrowBackClickedInGeneral = false;
  bool isArrowForwardClickedInGeneral = false;
  int startInTransactions = 1;
  bool isArrowBackClickedInTransactions = false;
  bool isArrowForwardClickedInTransactions = false;

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
      ordersController.setIsRetrieveOrdersFetched(false);
      ordersController.setRetrieveOrders([]);
    });
    await ordersController.getAllOrdersForRetrieveFromBack();
  }

  @override
  void initState() {
    ordersController.searchControllerInRetrieve.clear();
    ordersController.getAllOrdersForRetrieveFromBack();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<OrdersController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DialogTitle(text: 'orders'.tr),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ReusableSearchTextField(
                hint: '${"search".tr}...',
                textEditingController: controller.searchControllerInRetrieve,
                onChangedFunc: (val) {
                  controller.searchControllerInRetrieve.text=val;
                  _onChangeHandler(val);
                },
                validationFunc: (val) {},
              ),
            ),
            gapH10,

            // Expanded(
            //     child:controller.isRetrieveOrdersFetched? ListView.builder(
            //         itemCount: controller.retrieveOrders.length,
            //         itemBuilder: (context, index) =>
            //        DiscountTypeCard(
            //           info: controller.retrieveOrders[index],
            //         )):loading()),
            Expanded(
                child:controller.isRetrieveOrdersFetched?
                GridView.count(
                  crossAxisCount: homeController.isTablet ? 3 : 4,
                  // padding: EdgeInsets.symmetric(vertical: 70),
                  // crossAxisSpacing: 30,
                  mainAxisSpacing: 15,
                  childAspectRatio: homeController.isTablet
                      ? (Sizes.deviceWidth * 0.3 / Sizes.deviceHeight * 3.0)
                      : (Sizes.deviceWidth *
                      0.25 /
                      Sizes.deviceHeight *
                      3.0),
                  children:
                  List.generate(controller.retrieveOrders.length, (index) {
                    return  OrderCard(
                                  info: controller.retrieveOrders[index],
                                );
                  }),
                ):loading()),
          ],
        );
      }),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.info});
  final Map info;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final HomeController homeController = Get.find();
  final OrdersController ordersController = Get.find();
  final ProductController productController = Get.find();
  final PaymentController paymentController = Get.find();
  final ClientController clientController = Get.find();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (val) {
          setState(() {
            isHovered = val;
          });
        },
        onTap: () async{
           ordersController.setSelectedOrderId('${widget.info['id']}');
           ordersController.setSelectedOrder(widget.info);
           paymentController. setInvoiceNumber(widget.info['orderNumber']);
           productController.setSelectedOrderInfo(widget.info,false);
           clientController.setSelectedClientOrderInfo(widget.info);
           productController.setIsRetrieveOrderSelected(true);
          // Get.back();
          Navigator.pop(context);
          homeController.selectedTab.value = homeController.isSessionToday ? 'Home' : 'payment';
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              // width: MediaQuery.of(context).size.width * 0.1,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              // padding: const EdgeInsets.symmetric( horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                  color: isHovered ? Primary.primary : Colors.grey)),
              // child: Center(
              //   child: Text(
              //     widget.info['orderNumber'],
              //     style: TextStyle(
              //         color: isHovered ? Colors.white : Colors.black,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
              // width: MediaQuery.of(context).size.width * 0.1,
              // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.symmetric( vertical: 10,horizontal: 8),
              // height: 60,
              decoration: BoxDecoration(
                  borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9)
                  ),
                  color: isHovered ? Primary.primary : Colors.grey[500]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.info['note']??'',
                      style: TextStyle(
                          color: isHovered ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: ()async{
                        var res =await deleteOrder('${widget.info['id']}');
                        var p = json.decode(res.body);
                        if (res.statusCode == 200) {
                          CommonWidgets.snackBar(
                            'Success',
                            p['message'],
                          );
                          ordersController.getAllOrdersForRetrieveFromBack();
                        } else {
                          CommonWidgets.snackBar(
                            'error',
                            p['message'],
                          );
                        }
                      },
                      child: Icon(Icons.delete_outline,color: isHovered ? Colors.white : Colors.black,),
                    )
                  ],
                ),
              ),
                  gapH10,
                  RowInRetrieveCard(icon: Icons.date_range, text: widget.info['date']??''),
                  RowInRetrieveCard(icon: Icons.tag, text: widget.info['orderNumber']??''),
                  RowInRetrieveCard(icon: Icons.person, text: widget.info['cashier']??''),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric( horizontal: 10,vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: isHovered ? Primary.primary : Colors.grey)),
                child: Center(
                  child: Text(
                    widget.info['openedAt'],
                    style: TextStyle(
                        color: isHovered ? Primary.primary : Colors.black,
                        ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}


class RowInRetrieveCard extends StatelessWidget {
  const RowInRetrieveCard({super.key, required this.icon, required this.text});
final IconData icon;
final String text;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Row(
        children: [
          Icon(icon,color: Colors.black45,),
          gapW6,
          Text(text)
        ],
      ),
    ) ;
  }
}
