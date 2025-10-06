import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Widgets/table_title.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/page_title.dart';
import '../Home/quantities_dialog.dart';


TextEditingController quantityController = TextEditingController();

class MobileQuantitiesDialog extends StatefulWidget {
  const MobileQuantitiesDialog({super.key, required this.warehousesList, required this.transactionQuantitiesList0, required this.product});
  final List warehousesList;
  final String transactionQuantitiesList0;
  final Map product;
  @override
  State<MobileQuantitiesDialog> createState() => _MobileQuantitiesDialogState();
}

class _MobileQuantitiesDialogState extends State<MobileQuantitiesDialog> {
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
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PageTitle(
                          text:widget.product['item_name']),
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
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: (widget.product['images'] != null &&
                          widget.product['images'].isNotEmpty)
                          ? widget.product['images']
                      [0] // Safely access first image
                          : 'https://theravenstyle.com/rooster-backend/public/storage/WhatsApp%20Image%202024-03-03%20at%2011.41.15%20AM.jpeg',
                      height: Sizes.deviceHeight * 0.35,
                      width: Sizes.deviceWidth,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => loading(),
                      // errorWidget: (context, url, error) => loading(),
                      errorWidget: (context, url, error) {
                        //print("Error loading image: $error"); // Debug error message
                        return const Icon(Icons.broken_image,
                            size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                  gapH28,
                  // Row(
                  //   children: [
                  //     const Text('Item Code :  ',style: TextStyle(fontWeight: FontWeight.bold),),
                  //     Text('${widget.product['mainCode']}')
                  //   ],
                  // ),
                  // gapH10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        SizedBox(
                          width:Sizes.deviceWidth*0.4 ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Text('quantity'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
                              Text('${widget.product['quantity']}'),
                            ],
                          ) ,
                        ),
                      Column(
                        children: [
                           Text('price'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Text('${widget.product['priceCurrency']['name']} ${widget.product['unitPrice']}'),
                        ],
                      )
                    ],
                  ),
                  gapH28,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        SizedBox(
                          width:Sizes.deviceWidth*0.4 ,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Text('category'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
                              Text('${widget.product['category']['category_name']}'),
                            ],
                          ) ,
                        ),
                      Column(
                        children: [
                           Text('barcodes'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
                          Text(widget.product['barcode'].map((obj) => obj["code"]).join("  ,  ")),
                        ],
                      )
                    ],
                  ),
                  gapH28,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Text('description'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
                      Text('${widget.product['mainDescription']}')
                    ],
                  ),

                  gapH28,

                  Text('warehouse'.tr,style: TextStyle(fontSize: 12,color: Colors.grey),),
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
                          width: MediaQuery.of(context).size.width*0.15,
                        ),
                        TableTitle(
                          text: 'name'.tr,
                          width:MediaQuery.of(context).size.width*0.2,
                        ),
                        TableTitle(
                          text: '${'quantity'.tr} (${'in_piece'.tr})',
                          width: MediaQuery.of(context).size.width*0.25,
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
              ),
            ),
          );
        }
    );
  }
}









