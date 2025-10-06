import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/home_controller.dart';
import '../../../Widgets/table_item.dart';
import '../../../Widgets/table_title.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/page_title.dart';

List transactionQuantitiesList=[
  {'transaction':'Physical on hand','quantities':''},
  {'transaction':'Quantity owned','quantities':''},
  {'transaction':'Ordered not invoiced','quantities':'0 Pcs'}
  ,{'transaction':'delivered not invoiced','quantities':'0 Pcs'}
  ,{'transaction':'Physical on hand','quantities':'0 Pcs'}
  ,{'transaction':'Ordered not delivered','quantities':'0 Pcs'}
  ,{'transaction':'Ordered not delivered','quantities':'0 Pcs'}
  ,{'transaction':'received not purchased','quantities':'0 Pcs'}
  ,{'transaction':'purchased not received','quantities':'0 Pcs'}
 , {'transaction':'ordered not purchased','quantities':'0 Pcs'}
  ,{'transaction':'shipped in not received','quantities':'0 Pcs'}
  ,{'transaction':'requisitions not transferred','quantities':'0 Pcs'}
  ,{'transaction':'Quantity to order hand','quantities':'0 Pcs'}
  ,{'transaction':'Global minimum quantity','quantities':'0 Pcs'}
  ,{'transaction':'Global maximum quantity','quantities':'0 Pcs'}
];


TextEditingController quantityController = TextEditingController();
final _formKey=GlobalKey<FormState>();

class QuantitiesDialog extends StatefulWidget {
  const QuantitiesDialog({super.key, required this.warehousesList, required this.transactionQuantitiesList0, required this.product});
  final List warehousesList;
  final String transactionQuantitiesList0;
  final Map product;
  @override
  State<QuantitiesDialog> createState() => _QuantitiesDialogState();
}

class _QuantitiesDialogState extends State<QuantitiesDialog> {
  ProductController productController = Get.find();
  @override
  void initState() {
    // print('objecttt ${widget.product}');
    transactionQuantitiesList[0]['quantities'] =widget.transactionQuantitiesList0;
    transactionQuantitiesList[1]['quantities'] =widget.transactionQuantitiesList0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        builder: (cont) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Form(
            key:_formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageTitle(
                        text:'quantities'.tr),
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
                gapH28,
                Row(
                  children: [
                    const Text('Item Code :  ',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('${widget.product['mainCode']}')
                  ],
                ),
                gapH10,
                Row(
                  children: [
                    const Text('Description :  ',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('${widget.product['mainDescription']}')
                  ],
                ),
                gapH10,
                Row(
                  children: [
                    const Text('barcodes :  ',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(widget.product['barcode'].map((obj) => obj["code"]).join("  ,  "))
                  ],
                ),
                gapH28,
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('transactional_quantity'.tr,style: TextStyle(fontWeight: FontWeight.bold,color:TypographyColor.titleTable),),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: Primary.primary,
                                borderRadius: const BorderRadius.all(Radius.circular(6))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TableTitle(
                                  text: 'transaction'.tr,
                                  width: MediaQuery.of(context).size.width * 0.13,
                                ),
                                TableTitle(
                                  text: 'quantity'.tr,
                                  width: MediaQuery.of(context).size.width * 0.07,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              itemCount: transactionQuantitiesList.length, //products is data from back res
                              itemBuilder: (context, index) => TransactionalQuantitiesRowInTable(
                                isDesktop: true,
                                data: transactionQuantitiesList[index],
                                index: index,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('warehouses'.tr,style: TextStyle(fontWeight: FontWeight.bold,color:TypographyColor.titleTable),),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(  vertical: 15),
                              decoration: BoxDecoration(
                                  color: Primary.primary,
                                  borderRadius: const BorderRadius.all(Radius.circular(6))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TableTitle(
                                    text: 'code'.tr,
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  TableTitle(
                                    text: 'name'.tr,
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  TableTitle(
                                    text: '${'quantity'.tr} (in piece)',
                                    width: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                itemCount: widget.warehousesList.length, //products is data from back res
                                itemBuilder: (context, index) => WarehousesAsRowInTable(
                                  data: widget.warehousesList[index],
                                  index: index,
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class TransactionalQuantitiesRowInTable extends StatelessWidget {
  const TransactionalQuantitiesRowInTable({super.key, required this.data, required this.index, required this.isDesktop});
  final Map data;
  final int index;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(  vertical: 10),
      decoration: BoxDecoration(
          color: (index % 2 == 0) ? Primary.p10 : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width:isDesktop? MediaQuery.of(context).size.width * 0.13:MediaQuery.of(context).size.width * 0.4,
            child: Text('   ${data['transaction'] ?? ''}',
                style: TextStyle(
                  fontSize: isDesktop ? 14 : 12,
                  color: TypographyColor.textTable,
                )),
          ),
          TableItem(
            text: '${data['quantities'] ?? ''}',
            width: isDesktop?MediaQuery.of(context).size.width * 0.07:MediaQuery.of(context).size.width * 0.3,
          ),
        ],
      ),
    );
  }
}

class WarehousesAsRowInTable extends StatefulWidget {
  const WarehousesAsRowInTable({super.key, required this.data, required this.index});
  final Map data;
  final int index;

  @override
  State<WarehousesAsRowInTable> createState() => _WarehousesAsRowInTableState();
}

class _WarehousesAsRowInTableState extends State<WarehousesAsRowInTable> {
  bool isWarehousesChecked=false;
  HomeController homeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(  vertical: 10),
      decoration: BoxDecoration(
          color: (widget.index % 2 == 0) ? Primary.p10 : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TableItem(
            text: '${widget.data['warehouse_number'] ?? ''}',
            width:homeController.isMobile.value?MediaQuery.of(context).size.width * 0.15: MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${widget.data['name'] ?? ''}',
            width:homeController.isMobile.value?MediaQuery.of(context).size.width * 0.2:  MediaQuery.of(context).size.width * 0.1,
          ),
          TableItem(
            text: '${widget.data['qty_on_hand'] ?? ''}',
            width:homeController.isMobile.value?MediaQuery.of(context).size.width * 0.25:  MediaQuery.of(context).size.width * 0.1,
          ),
        ],
      ),
    );
  }
}





