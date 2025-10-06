import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/const/colors.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Widgets/page_title.dart';
import '../../const/Sizes.dart';
import 'home_content.dart';


class CameraScannerPage extends StatefulWidget {
  const CameraScannerPage({super.key});

  @override
  State<CameraScannerPage> createState() => _CameraScannerPageState();
}

class _CameraScannerPageState extends State<CameraScannerPage> {
  Barcode? _barcode;
  final MobileScannerController mobileScannerController =
      MobileScannerController(
    autoStart: true,
    torchEnabled: true,
    useNewCameraSelector: true,
  );

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.black),
      );
    }
    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.black),
    );
  }

  HomeController homeController = Get.find();
  ClientController clientController = Get.find();
  ProductController productController = Get.find();
  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
      if (barcodes.barcodes.isNotEmpty) {
        searchByBarcodeOrNameController.text = '${_barcode!.displayValue}';
        await productController.getAllProductsFromBackWithSearch();
        homeController.selectedTab.value = 'Home';
      }
    }
  }

  // givePermission() async {
  // final perm = await html.window.navigator.permissions.query({"name": "camera"});
  //   if (perm.state == "denied") {
  //     CommonWidgets.snackBar('error', "Oops! Camera access denied!");
  //   return;
  //   }
  //   final stream = await html.window.navigator.getUserMedia(video: true);
  //   // ...
  //   }
  getPermissions()async{
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }
  }
  @override
  void initState() {
    getPermissions();
    // window.navigator.getUserMedia();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Primary.primary,
        //   title: Text(
        //     'scan_barcode'.tr,
        //     style:
        //         const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           mobileScannerController.switchCamera();
        //         },
        //         icon: const Icon(
        //           Icons.camera_rear_outlined,
        //           color: Colors.white,
        //         ))
        //   ],
        // ),
        // body:
        SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            // color: Primary.primary,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        // Navigator.pushReplacement(context, MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return const SessionsOptions();
                        //     }));
                        homeController.setSelectedTab('Home');
                        productController.resetAll();
                        clientController.resetAll();
                        // paymentController.resetAll();
                      },
                      child:   Icon(Icons.arrow_back,
                          size: 22,
                          // color: Colors.grey,
                          color: Primary.primary),
                    ),
                    gapW10,
                    PageTitle(text: 'scan_barcode'.tr),
                  ],
                ),
                _buildBarcode(_barcode),
                IconButton(
                    onPressed: () {
                      mobileScannerController.switchCamera();
                    },
                    icon: Icon(
                      Icons.camera_rear_outlined,
                      color: Primary.primary,
                      size: 23,
                    ))
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: MobileScanner(
                  controller: mobileScannerController,
                  onDetect: (barcodes) {
                    // if (mounted) {
                    // setState(() {
                    //   _barcode = barcodes.barcodes.firstOrNull;
                    // });
                    _handleBarcode(barcodes);
                    // }
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: QRScannerOverlay(
                  overlayColour: Colors.black.withAlpha((0.5 * 255).toInt()),
                ),
              )
            ],
          ),
        ],
      ),
    );
    // );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key, required this.overlayColour});

  final Color overlayColour;

  @override
  Widget build(BuildContext context) {
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 330.0;
    return Stack(children: [
      ColorFiltered(
        colorFilter: ColorFilter.mode(
            overlayColour, BlendMode.srcOut), // This one will create the magic
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode
                      .dstOut), // This one will handle background + difference out
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: scanArea,
                width: scanArea,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: CustomPaint(
          foregroundPainter: BorderPainter(),
          child: SizedBox(
            width: scanArea + 25,
            height: scanArea + 25,
          ),
        ),
      ),
    ]);
  }
}

// Creates the white borders
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.height - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}
