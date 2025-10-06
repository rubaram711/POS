import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../Controllers/products_controller.dart';
import 'home_content.dart';


class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _barcode = 'Scan a barcode';  // Initial placeholder text
  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.camera_alt),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: GetBuilder<ProductController>(
        builder: (proCont) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: MobileScanner(
                  onDetect: (BarcodeCapture barcodeCapture) async {
                    // Extract barcode value from the BarcodeCapture object
                    final String code = barcodeCapture.barcodes.first.rawValue ?? 'Unknown';

                    // Update the barcode value and stop scanning
                    setState(() {
                      _barcode = code;
                      searchByBarcodeController.text=_barcode;// Display the scanned barcode value
                    });
                    await productController
                        .getAllProductsFromBackWithSearch();
                    if (proCont.productsList.length == 1) {
                      String id =
                          '${proCont.productsList[0]['id']}';
                      double tax = proCont.productsList[0]
                      ['taxation'] /
                          100.0;
                      double usdPrice = 0.0,
                          otherCurrencyPrice = 0.0;
                      if (proCont.productsList[0]['priceCurrency']
                      ['symbol'] ==
                          '\$') {
                        setState(() {
                          usdPrice = double.parse(
                              '${proCont.productsList[0]['unitPrice']}');
                          otherCurrencyPrice = double.parse(
                              '${Decimal.parse('$usdPrice') * Decimal.parse('${productController.latestRate}')}');
                        });
                      } else {
                        setState(() {
                          otherCurrencyPrice = double.parse(
                              '${proCont.productsList[0]['unitPrice']}');
                          usdPrice = double.parse(
                              '${double.parse('$otherCurrencyPrice') / double.parse('${productController.latestRate}')}');
                        });
                      }
                      Map p = {
                        'id': proCont.productsList[0]['id'],
                        'item_name': proCont.productsList[0]
                        ['item_name'],
                        'quantity': '1',
                        'tax': tax,
                        'percent_tax': proCont.productsList[0]
                        ['taxation'],
                        'discount': 0,
                        'discount_percent': 0,
                        'discount_type_id': '',
                        'original_price':
                        otherCurrencyPrice, //widget.product['unitPrice'],
                        'price':
                        '$otherCurrencyPrice', // widget.product['unitPrice'],
                        'UsdPrice':
                        usdPrice, // widget.product['unitPrice'],
                        'final_price':
                        otherCurrencyPrice, // widget.product['unitPrice'],
                        'symbol': proCont.productsList[0]
                        ['posCurrency']['symbol'] ??
                            '',
                         'sign': proCont.isReturnClicked ? '-' : ''
                      };
                      proCont.addToOrderItemsList(id, p);
                      proCont.calculateSummary();
                    }

                    Get.back();
                  },
                ),
              )
            ],
          );
        }
      ),
    );
  }
}



