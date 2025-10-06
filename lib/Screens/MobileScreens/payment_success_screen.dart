import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/payment_controller.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/Screens/MobileScreens/choose_pint_format_dialog.dart';
import 'package:pos_project/const/colors.dart';

import '../../Controllers/client_controller.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  HomeController homeController = Get.find();
  PaymentController paymentController = Get.find();
  ClientController clientController = Get.find();
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _animation2 = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAnimatedCircles() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _animation2,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Primary.primary.withAlpha((0.1 * 255).toInt()),
              shape: BoxShape.circle,
            ),
          ),
        ),
        ScaleTransition(
          scale: _animation1,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Primary.primary.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Primary.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ],
    );
  }

  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'payment_successful'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            buildAnimatedCircles(),
            const SizedBox(height: 30),
            Text('the_receipt_number_is:'.tr, style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Text(
              paymentController.invoiceNumber,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.back();
                        productController.resetAll();
                        paymentController.resetAll();
                        clientController.resetAll();
                        productController.setSelectedMobileTab(1);
                      },
                      icon: Icon(Icons.close, color: Primary.primary),
                      label: Text(
                        "close".tr,
                        style: TextStyle(color: Primary.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Primary.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        paymentController.setIsReprintedInvoice(false);
                        showDialog<String>(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(9),
                                  ),
                                ),
                                elevation: 0,
                                content: ChoosePrintFormatDialog(),
                              ),
                        );

                        // Get.to(MobilePrintScreen());
                      },
                      icon: const Icon(Icons.print, color: Colors.white),
                      label: Text("print_receipt".tr),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Primary.primary),
                        backgroundColor: Primary.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
