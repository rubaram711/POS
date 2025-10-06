import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintWasteScreen extends StatefulWidget {
  const PrintWasteScreen({super.key});

  @override
  State<PrintWasteScreen> createState() => _PrintWasteScreenState();
}

class _PrintWasteScreenState extends State<PrintWasteScreen> {
  TextEditingController fieldController = TextEditingController();
  PaymentController paymentController = Get.find();
  ProductController productController = Get.find();
  HomeController homeController = Get.find();
  ClientController clientController = Get.find();
  double itemsListHeight = 10;
  double cashedMethodsListHeight = 10;
  // double subTotal=0.0;
  // getSubTotal(){
  //   for (var entry in productController.orderItemsList.entries){
  //
  //   }
  // }
  @override
  void initState() {
    itemsListHeight = productController.orderItemsList.length * 35;
    cashedMethodsListHeight =
        paymentController.selectedCashingMethodsList.length * 25;
    // cashedMethodsListHeight=paymentController.selectedMethodsList.length*30;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.deviceHeight * 0.95,
      child: Row(
        children: [
          //payment method
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'payment_successful'.tr,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        gapH20,
                        const Text(
                          'You can save invoice as pdf and print it using the icons in the bottom',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      homeController.setSelectedTab('Home');
                      productController.resetAll();
                      paymentController.resetAll();
                      clientController.resetAll();
                    },
                    child: Container(
                      height: Sizes.deviceHeight * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Primary.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Primary.p0,
                            size: 20,
                          ),
                          gapW4,
                          Text(
                            'new_order'.tr,
                            style: TextStyle(
                              fontSize: 17,
                              color: Primary.p0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: SizedBox(
              height: Sizes.deviceHeight * 0.95,
              child: PdfPreview(
                build: (format) => _generatePdf(format, 'title'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    double fontSize = 7;
    final font = await rootBundle.load('assets/fonts/Tajawal-Medium.ttf');
    final arabicFont = pw.Font.ttf(font);
    // final PdfPageFormat receiptPageFormat = PdfPageFormat(58 * PdfPageFormat.mm, PdfPageFormat.undefined as double);
    // PdfPageFormat roll80 = PdfPageFormat(80 * PdfPageFormat.mm, 200 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);
    // PdfPageFormat roll57 = PdfPageFormat(57 * PdfPageFormat.mm, 200 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.fromLTRB(3, 10, 3, 10),
        build: (context) {
          return pw.Center(
            child: pw.Column(
              // mainAxisAlignment: pw.MainAxisAlignment.center,
              // crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                homeController.companyName.startsWith('GINETTE')
                    ? pw.SizedBox(
                      width: 50,
                      child: pw.FittedBox(
                        child: pw.Text(
                          homeController.posName,
                          style: pw.TextStyle(
                            // font: font,
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : pw.SizedBox(),
                pw.SizedBox(
                  height:
                      homeController.companyName.startsWith('GINETTE') ? 5 : 0,
                ),
                pw.SizedBox(
                  width: 50,
                  child: pw.FittedBox(
                    child: pw.Text(
                      homeController.companyName,
                      style: pw.TextStyle(
                        // font: font,
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                homeController.companyName.startsWith('GINETTE')
                    ? pw.Text(
                      'Gouraud Street - Gemaizeh',
                      style: pw.TextStyle(fontSize: fontSize),
                    )
                    : pw.SizedBox(),
                homeController.companyName.startsWith('GINETTE')
                    ? pw.Text(
                      '01-570440',
                      style: pw.TextStyle(fontSize: fontSize),
                    )
                    : pw.SizedBox(),
                homeController.companyName.startsWith('GINETTE')
                    ? pw.Text(
                      'VAT No. 2212626-601',
                      style: pw.TextStyle(fontSize: fontSize),
                    )
                    : pw.SizedBox(),
                pw.SizedBox(
                  height:
                      homeController.companyName.startsWith('GINETTE') ? 5 : 0,
                ),
                clientController.selectedCustomerIdWithOk != '-1'
                    ? pw.Column(
                      children: [
                        pw.Text(
                          '${clientController.selectedCustomerObject['clientNumber'] ?? clientController.selectedCustomerObject['client_number']}, ${clientController.selectedCustomerObject['name']}',
                          style: pw.TextStyle(fontSize: fontSize),
                        ),
                        pw.SizedBox(height: 5),
                        clientController.selectedCustomerObject['country'] !=
                                    null &&
                            clientController
                                        .selectedCustomerObject['city'] !=
                                    null
                            ? pw.Text(
                              '${clientController.selectedCustomerObject['country']}, ${clientController.selectedCustomerObject['city']}',
                              style: pw.TextStyle(fontSize: fontSize),
                            )
                            : clientController
                                        .selectedCustomerObject['country'] !=
                                    null &&
                            clientController
                                        .selectedCustomerObject['city'] ==
                                    null
                            ? pw.Text(
                              '${clientController.selectedCustomerObject['country']}',
                              style: pw.TextStyle(fontSize: fontSize),
                            )
                            : pw.SizedBox(),
                        pw.SizedBox(height: 5),
                        clientController
                                    .selectedCustomerObject['phoneNumber'] ??
                            clientController
                                        .selectedCustomerObject['phone_number'] !=
                                    null
                            ? pw.Text(
                              '(${clientController.selectedCustomerObject['phoneCode'] ?? clientController.selectedCustomerObject['phone_code']})-${clientController.selectedCustomerObject['phoneNumber'] ?? clientController.selectedCustomerObject['phone_number']}'
                              '${clientController.selectedCustomerObject['mobileNumber'] ?? clientController.selectedCustomerObject['mobile_number'] == null ? '' : ',  (${clientController.selectedCustomerObject['mobileCode'] ?? clientController.selectedCustomerObject['mobile_code']})-${clientController.selectedCustomerObject['mobileNumber'] ?? clientController.selectedCustomerObject['mobile_number']}'}',
                              style: pw.TextStyle(fontSize: fontSize),
                            )
                            : pw.SizedBox(),
                        pw.SizedBox(height: 5),
                        clientController.selectedCustomerObject['email'] !=
                                null
                            ? pw.Text(
                          clientController.selectedCustomerObject['email'],
                              style: pw.TextStyle(fontSize: fontSize),
                            )
                            : pw.SizedBox(),
                        pw.SizedBox(height: 5),
                        clientController.selectedCustomerObject['taxId'] !=
                                    null ||
                                '${clientController.selectedCustomerObject['taxId']}' ==
                                    '0' ||
                            clientController
                                        .selectedCustomerObject['tax_id'] !=
                                    null ||
                                '${clientController.selectedCustomerObject['tax_id']}' ==
                                    '0'
                            ? pw.Text(
                              '${'tax_number'.tr}: ${clientController.selectedCustomerObject['taxId'] ?? clientController.selectedCustomerObject['tax_id']}',
                              style: pw.TextStyle(fontSize: fontSize),
                            )
                            : pw.SizedBox(),
                        pw.SizedBox(width: 120, child: pw.Divider()),
                      ],
                    )
                    : pw.SizedBox(),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${'wasted_by'.tr} ${homeController.useName}',
                      style: pw.TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '$formattedDate $formattedTime',
                      style: pw.TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                  child: pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.white),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            width: 50, // Set specific width for the id cell
                            child: pw.Text(
                              'Qty',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.white),
                            ),
                          ),
                          pw.Container(
                            width: 150, // Set specific width for the name cell
                            child: pw.Text(
                              'Description',
                              style: pw.TextStyle(fontSize: fontSize),
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.white),
                            ),
                          ),
                          // pw.Container(
                          //   width: 90, // Set specific width for the price cell
                          //   child: pw.Text(
                          //     'Price',
                          //     style: pw.TextStyle(fontSize: fontSize),
                          //   ),
                          //   decoration: pw.BoxDecoration(
                          //     border: pw.Border.all(color: PdfColors.white),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Divider(endIndent: 5),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                  child: pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.white),
                    children: [
                      for (var entry
                          in productController.orderItemsList.entries)
                        pw.TableRow(
                          children: [
                            pw.Container(
                              width: 50,
                              height: 25,
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    '${entry.value['quantity']}',
                                    style: pw.TextStyle(
                                      fontSize: fontSize,
                                      font: arabicFont,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            pw.Container(
                              width: 150, // Set specific width for the name cell
                              height: 25,
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    entry.value['item_name'],
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(
                                      fontSize: fontSize,
                                      font: arabicFont,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            // pw.Container(
                            //   width:
                            //       90, // Set specific width for the price cell
                            //   height: 25,
                            //   child: pw.Row(
                            //     mainAxisAlignment: pw.MainAxisAlignment.start,
                            //     // crossAxisAlignment: pw.CrossAxisAlignment.start,
                            //     children: [
                            //       pw.Text(
                            //         '${numberWithComma(entry.value['price'].toString())} ${productController.posCurrency}',
                            //         style: pw.TextStyle(
                            //           fontSize: fontSize,
                            //           font: arabicFont,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   decoration: pw.BoxDecoration(
                            //     border: pw.Border.all(color: PdfColors.white),
                            //   ),
                            // ),
                          ],
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),

              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}

class PrintBtn extends StatefulWidget {
  const PrintBtn({
    super.key,
    required this.onTapFunction,
    required this.text,
    required this.icon,
  });
  final Function onTapFunction;
  final String text;
  final IconData icon;

  @override
  State<PrintBtn> createState() => _PrintBtnState();
}

class _PrintBtnState extends State<PrintBtn> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTapFunction();
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color:
                  isHovered
                      ? Primary.primary.withAlpha((0.2 * 255).toInt())
                      : Others.divider,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 20, color: Colors.black87),
                gapW6,
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
