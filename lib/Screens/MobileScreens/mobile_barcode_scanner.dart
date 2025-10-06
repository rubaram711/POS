import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../Controllers/products_controller.dart';
import '../Home/home_content.dart';
import 'mobile_stoke.dart';

class MobileBarcodeScannerPage extends StatefulWidget {
  const MobileBarcodeScannerPage({super.key});

  @override
  State<MobileBarcodeScannerPage> createState() =>
      _MobileBarcodeScannerPageState();
}

class _MobileBarcodeScannerPageState extends State<MobileBarcodeScannerPage> {
  String _barcode = 'Scan a barcode';
  ProductController productController = Get.find();
  final player = AudioPlayer();
  bool isProcessing = false;
  bool isFlashOn = false; // Added variable to track flash state
  MobileScannerController cameraController = MobileScannerController(); // Added camera controller

  // Variables to control the size of the scanning area
  double _scanAreaWidth = 250;
  double _scanAreaHeight = 120;
  final double _minScanAreaWidth = 100;
  final double _minScanAreaHeight = 50;

  @override
  void initState() {
    mobileSearchByBarcodeController.clear();
    super.initState();
  }

  Future<void> _playBeep() async {
    try {
      await player.play(AssetSource("sounds/beep.mp3"));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('barcode_scanner'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
          // Added flash button
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // The camera view
          MobileScanner(
            controller: cameraController, // Assigned the controller
            onDetect: (BarcodeCapture barcodeCapture) async {
              if (isProcessing) return;
              isProcessing = true;

              final String code =
                  barcodeCapture.barcodes.first.rawValue ?? 'Unknown';

              setState(() {
                _barcode = code;
                mobileSearchByBarcodeController.text = _barcode;
                searchByBarcodeOrNameController.text = _barcode;
              });


              await productController.getAllProductsFromBackWithSearch();
              await _playBeep();
              if (productController.productsList.length == 1 && productController.selectedMobileTab==2) {
                // await _playBeep();
                String id = '${productController.productsList[0]['id']}';

                if (productController.orderItemsList.keys.contains(id)) {
                  productController.orderItemsList[id]['quantity'] =
                  '${double.parse(productController.orderItemsList[id]['quantity']) + 1}';
                } else {
                  double tax =
                      productController.productsList[0]['taxation'] / 100.0;
                  double usdPrice = 0.0, otherCurrencyPrice = 0.0;

                  if (productController.productsList[0]['priceCurrency']
                  ['symbol'] ==
                      '\$') {
                    usdPrice = double.parse(
                      '${productController.productsList[0]['unitPrice']}',
                    );
                    otherCurrencyPrice = double.parse(
                      '${Decimal.parse('$usdPrice') * Decimal.parse('${productController.latestRate}')}',
                    );
                  } else {
                    otherCurrencyPrice = double.parse(
                      '${productController.productsList[0]['unitPrice']}',
                    );
                    usdPrice = double.parse(
                      '${double.parse('$otherCurrencyPrice') / double.parse('${productController.latestRate}')}',
                    );
                  }

                  Map p = {
                    'id': productController.productsList[0]['id'],
                    'available_qty':
                    productController.productsList[0]['quantity'],
                    'item_name':
                    productController.productsList[0]['item_name'],
                    'quantity': '1',
                    'tax': tax,
                    'percent_tax':
                    productController.productsList[0]['taxation'],
                    'discount': 0,
                    'discount_percent': 0,
                    'discount_type_id': '',
                    'original_price': otherCurrencyPrice,
                    'price': '$otherCurrencyPrice',
                    'UsdPrice': usdPrice,
                    'final_price': otherCurrencyPrice,
                    'symbol': productController.productsList[0]['posCurrency']
                    ['symbol'] ??
                        '',
                    'sign': productController.isReturnClicked ? '-' : '',
                    'image': '',
                    'brand': '',
                    'description': '',
                  };

                  productController.addToOrderItemsList(id, p);
                  productController.calculateSummary();
                }
              }
              // else  if (productController.productsList.length >= 1 && productController.selectedMobileTab!=2) {
              //     await _playBeep();
              // }
              Future.delayed(const Duration(seconds: 1), () {
                isProcessing = false;
              });
            },
          ),

          // The dark, transparent overlays
          // Top overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2 - AppBar().preferredSize.height,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          // Bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          // Left overlay
          Positioned(
            left: 0,
            top: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2 - AppBar().preferredSize.height,
            bottom: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2,
            child: Container(
              width: (MediaQuery.of(context).size.width - _scanAreaWidth) / 2,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          // Right overlay
          Positioned(
            right: 0,
            top: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2 - AppBar().preferredSize.height,
            bottom: (MediaQuery.of(context).size.height - _scanAreaHeight) / 2,
            child: Container(
              width: (MediaQuery.of(context).size.width - _scanAreaWidth) / 2,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),

          // The resizable scanning area and the crop icon
          Center(
            child: SizedBox(
              width: _scanAreaWidth,
              height: _scanAreaHeight,
              child: Stack(
                clipBehavior: Clip.none, // Allow children to go outside the parent
                children: [
                  // The resize handle (crop icon)
                  Positioned(
                    top: -20, // Move the icon up by half its height
                    left: -20, // Move the icon left by half its width
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _scanAreaWidth = (_scanAreaWidth - details.delta.dx).clamp(
                            _minScanAreaWidth,
                            MediaQuery.of(context).size.width * 0.9,
                          );
                          _scanAreaHeight = (_scanAreaHeight - details.delta.dy).clamp(
                            _minScanAreaHeight,
                            MediaQuery.of(context).size.height * 0.7,
                          );
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.crop,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}