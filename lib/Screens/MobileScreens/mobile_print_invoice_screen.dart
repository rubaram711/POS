import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pos_project/const/constants.dart';
import '../../Controllers/client_controller.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../Locale_Memory/save_company_info_locally.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../const/functions.dart';
import '../Home/home_page.dart';

class MobilePrintScreen extends StatefulWidget {
  const MobilePrintScreen({super.key, required this.paperType});
  final PaperType paperType;
  @override
  State<MobilePrintScreen> createState() => _MobilePrintScreenState();
}

class _MobilePrintScreenState extends State<MobilePrintScreen> {
  TextEditingController fieldController = TextEditingController();
  PaymentController paymentController = Get.find();
  ProductController productController = Get.find();
  ClientController clientController = Get.find();
  HomeController homeController = Get.find();
  double itemsListHeight = 10;
  double cashedMethodsListHeight = 10;
  // double subTotal=0.0;
  // getSubTotal(){
  //   for (var entry in productController.orderItemsList.entries){
  //
  //   }
  // }
  Uint8List logoBytes = Uint8List(0);
  bool isImageLoading = true;
  Future<void> generatePdfFromImageUrl(String companyLogo) async {
    final response = await http.get(Uri.parse(companyLogo));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image');
    } else {
      final Uint8List imageBytes = response.bodyBytes;
      logoBytes = imageBytes;
      setState(() {
        isImageLoading = false;
      });
    }
    // quotationController.setLogo(imageBytes);
  }

  String fullCompanyName = '';
  String companyEmail = '';
  String companyPhoneNumber = '';
  String companyVat = '';
  String companyMobileNumber = '';
  String companyLogo = '';
  String companyTrn = '';
  String companyBankInfo = '';
  String companyAddress = '';
  String companyPhoneCode = '';
  String companyMobileCode = '';
  String companyLocalPayments = '';
  String primaryCurrency = '';
  String primaryCurrencyId = '';
  String primaryCurrencySymbol = '';
  String primaryLatestRate = '';
  String finallyRate = '';
  Future<void> headerRetrieve() async {
    fullCompanyName = await getFullCompanyNameFromPref();
    companyEmail = await getCompanyEmailFromPref();
    companyPhoneNumber = await getCompanyPhoneNumberFromPref();
    companyVat = await getCompanyVatFromPref();
    companyMobileNumber = await getCompanyMobileNumberFromPref();
    companyLogo = await getCompanyLogoFromPref();
    companyTrn = await getCompanyTrnFromPref();
    companyBankInfo = await getCompanyBankInfoFromPref();
    companyAddress = await getCompanyAddressFromPref();
    companyPhoneCode = await getCompanyPhoneCodeFromPref();
    companyMobileCode = await getCompanyMobileCodeFromPref();
    companyLocalPayments = await getCompanyLocalPaymentsFromPref();
    primaryCurrency = await getCompanyPrimaryCurrencyFromPref();
    primaryCurrencyId = await getCompanyPrimaryCurrencyIdFromPref();
    primaryCurrencySymbol = await getCompanyPrimaryCurrencySymbolFromPref();
    generatePdfFromImageUrl(companyLogo);
  }

  @override
  void initState() {
    headerRetrieve();
    itemsListHeight = productController.orderItemsList.length * 35;
    cashedMethodsListHeight =
        paymentController.selectedCashingMethodsList.length * 25;
    // cashedMethodsListHeight=paymentController.selectedMethodsList.length*30;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productController.primaryCurrency == productController.posCurrency
              ? '${productController.primaryCurrency} ${numberWithComma(productController.totalPriceWithExchange.toString())}'
              : '${productController.primaryCurrency} ${numberWithComma(productController.totalPriceWithExchange.toString())} '
                  '(${productController.posCurrency} ${numberWithComma(productController.totalPrice.toString())})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          IconButton(
            onPressed: () {
              productController.resetAll();
              paymentController.resetAll();
              clientController.resetAll();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const HomePage();
                  },
                ),
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            // height: Sizes.deviceHeight * 0.87,
            child: Row(
              children: [
                Expanded(
                  // flex: 9,
                  child: SizedBox(
                    height: Sizes.deviceHeight * 0.87,
                    child: PdfPreview(
                      canChangePageFormat: false,
                      build: (format) => _generatePdf(format, widget.paperType),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    PaperType paperType,
  ) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    double fontSize = 7;
    double width = MediaQuery.of(context).size.width;
    var gapW20 = pw.SizedBox(width: 20);
    var gapH4 = pw.SizedBox(height: 4);
    var gapH5 = pw.SizedBox(height: 5);
    final font = await rootBundle.load('assets/fonts/Tajawal-Medium.ttf');
    final arabicFont = pw.Font.ttf(font);
    // final PdfPageFormat receiptPageFormat = PdfPageFormat(58 * PdfPageFormat.mm, PdfPageFormat.undefined as double);
    // PdfPageFormat roll80 = PdfPageFormat(80 * PdfPageFormat.mm, 200 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);
    // PdfPageFormat roll57 = PdfPageFormat(57 * PdfPageFormat.mm, 200 * PdfPageFormat.mm, marginAll: 5 * PdfPageFormat.mm);
    // final image =isImageLoading? pw.MemoryImage(logoBytes);



    Map<String, pw.ImageProvider?> imageProviders = {};
    for (var item in productController.orderItemsList.entries) {
      if (item.value['image'] != null) {
        try {
          final response = await http.get(Uri.parse(item.value['image']));
          if (response.statusCode == 200) {
            imageProviders[item.value['image']] = pw.MemoryImage(
              response.bodyBytes,
            );
          } else {
            imageProviders[item.value['image']] =
                null; // Store null if image fails to load
          }
        } catch (e) {
          imageProviders[item.value['image']] = null;
        }
      } else {
        imageProviders[item.value['image']] = null;
      }
    }

    reusableShowInfoCard({required double width, required String text}) {
      return pw.Container(
        width: width,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2),
        child: pw.Center(
          child: pw.Text(
            text,
            style: pw.TextStyle(fontSize: 7, font: arabicFont),
          ),
        ),
      );
    }

    reusableItemRowInQuotations({
      required Map quotationItemInfo,
      required int index,
      required pw.ImageProvider? imageProvider,
    }) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                reusableShowInfoCard(
                  text:
                      quotationItemInfo['brand'] != ''
                          ? quotationItemInfo['brand']
                          : '---',
                  width: width * 0.1,
                ),

                reusableShowInfoCard(
                  text: '${quotationItemInfo['item_name'] ?? ''}',
                  width: width * 0.1,
                ),
                reusableShowInfoCard(
                  text: '${quotationItemInfo['description'] ?? ''}',
                  width: width * 0.1,
                ),
                reusableShowInfoCard(
                  text:
                      '${quotationItemInfo['sign']}${quotationItemInfo['quantity']}',
                  width: width * 0.1,
                ),
                reusableShowInfoCard(
                  text:
                  // '${quotationItemInfo['item_unit_price'] ?? ''}',
                  numberWithComma(
                    double.parse(
                      '${double.parse('${quotationItemInfo['price']}'.replaceAll(',', ''))}',
                      // '${double.parse('${quotationItemInfo['item_unit_price']}'.replaceAll(',', '')) / double.parse(finallyRate)}',
                    ).toStringAsFixed(2),
                  ),
                  width: width * 0.15,
                ),
                reusableShowInfoCard(
                  text: '${quotationItemInfo['discount_percent'] ?? '0'}',
                  width: width * 0.1,
                ),
                reusableShowInfoCard(
                  text:
                  // '${quotationItemIn
                  // fo['item_total'] ?? ''}',
                  numberWithComma(
                    double.parse(
                      '${double.parse('${quotationItemInfo['final_price']}'.replaceAll(',', ''))}',
                      // '${double.parse('${quotationItemInfo['item_total']}'.replaceAll(',', '')) / double.parse(finallyRate)}',
                    ).toStringAsFixed(2),
                  ),
                  width: width * 0.15,
                ),
              ],
            ),
            // gapH4,
            // gapH4,
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(width: 30),
                pw.Container(
                  width: 125,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.white,
                      width: 1.00,
                      style: pw.BorderStyle.solid,
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Column(
                      children: [
                        gapH4,

                        if (imageProvider != null)
                          pw.Image(
                            imageProvider,
                            fit: pw.BoxFit.contain,
                            width: 100,
                            height: 60,
                          ),
                        gapH4,
                      ],
                    ),
                  ),
                ), // pw.Container(
                //   width: 50,
                //   height: 50,
                //   decoration: pw.BoxDecoration(
                //     color: PdfColors.black,
                //     border: pw.Border.all(
                //       color: PdfColors.black,
                //       width: 1.00,
                //       style: pw.BorderStyle.solid,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      );
    }

    if (paperType == PaperType.a4) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(3, 10, 3, 10),
          build: (context) {
            return pw.Center(
              child: pw.Column(
                // mainAxisAlignment: pw.MainAxisAlignment.center,
                // crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.SizedBox(
                          width: width * 0.5,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: <pw.Widget>[
                                  pw.Container(
                                    width: 180, // Set the desired width
                                    height: 70, // Set the desired height
                                    child:
                                        isImageLoading
                                            ? pw.SizedBox.shrink()
                                            : pw.Image(
                                              pw.MemoryImage(logoBytes),
                                            ), //to be use again
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(
                          width: width * 0.5,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  gapH4,
                                  gapH4,
                                  pw.Text(
                                    homeController.companyName,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  gapH4,
                                  reusableText(homeController.companyAddress),
                                ],
                              ),
                              gapW20,
                            ],
                          ),
                        ),

                        pw.SizedBox(
                          width: width * 0.5,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  gapH4,
                                  reusableText(
                                    'T $companyPhoneCode $companyPhoneNumber $companyTrn',
                                  ),
                                  gapH4,

                                  reusableText(
                                    'T $companyMobileCode $companyMobileNumber',
                                  ),
                                  gapH4,
                                  pw.SizedBox(
                                    width: width * 0.1,
                                    child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.start,

                                      children: [reusableText(companyEmail)],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: pw.Row(
                      // crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.only(left: 10),
                          width: width * 0.5,
                          child:
                          clientController.selectedCustomerIdWithOk != '-1'
                                  ? pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            '${'to'.tr}:',
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          gapH4,
                                          pw.Text(
                                            '${'telephone'.tr}:',
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          gapH4,
                                          pw.Text(
                                            '${'address'.tr}:',
                                            style: pw.TextStyle(
                                              fontSize: 7,
                                              fontWeight: pw.FontWeight.normal,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      gapW20,
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,

                                        children: [
                                          clientController
                                              .selectedCustomerObject['name']==null?pw.Text('---'): reusableText(
                                            clientController
                                                    .selectedCustomerObject['name']
                                                    .isEmpty
                                                ? '---'
                                                : clientController
                                                    .selectedCustomerObject['name'],
                                          ),
                                          gapH4,
                                          clientController
                                              .selectedCustomerObject['clientNumber']==null?pw.Text('---'):
                                          reusableText(
                                            clientController
                                                    .selectedCustomerObject['clientNumber']
                                                    .isEmpty
                                                ? '---'
                                                : clientController
                                                    .selectedCustomerObject['clientNumber'],
                                          ),
                                          gapH4,
                                          reusableText(companyAddress),
                                        ],
                                      ),
                                    ],
                                  )
                                  : pw.SizedBox(),
                        ),
                        //date
                        pw.SizedBox(width: width * 0.5),
                        pw.SizedBox(
                          width: width * 0.5,
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    paymentController.isReprinted
                                        ? 'Reprinted invoice:'
                                        : 'Invoice:',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  gapH4,
                                  pw.Text(
                                    '${'served_by'.tr}:',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  gapH4,
                                  pw.Text(
                                    '${'date'.tr}:',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  gapH4,
                                ],
                              ),
                              gapW20,
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  reusableText(paymentController.invoiceNumber),
                                  gapH4,
                                  reusableText(
                                    homeController.useName.isEmpty
                                        ? '---'
                                        : homeController.useName,
                                  ),
                                  gapH5,
                                  reusableText('$formattedDate $formattedTime'),
                                  gapH5,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child:
                    // to
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            tableTitle(text: 'brand'.tr, width: width * 0.1),
                            tableTitle(text: 'item_'.tr, width: width * 0.1),
                            tableTitle(
                              text: 'description'.tr,
                              width: width * 0.1,
                            ),
                            tableTitle(text: 'qty'.tr, width: width * 0.1),
                            tableTitle(
                              text: 'unit_price'.tr,
                              width: width * 0.15,
                            ),
                            tableTitle(
                              text: '${'disc'.tr}%',
                              width: width * 0.1,
                            ),
                            tableTitle(
                              text: 'Total (${productController.posCurrency})',
                              width: width * 0.15,
                            ),
                          ],
                        ),

                        gapH4,
                        pw.Divider(
                          height: 5,
                          color: PdfColors.black,
                          // endIndent: 250
                        ),
                        pw.ListView.builder(
                          padding: const pw.EdgeInsets.symmetric(vertical: 10),
                          itemCount:
                              productController.orderItemsList.keys
                                  .toList()
                                  .length,
                          itemBuilder: (context, index) {
                            var keys =
                                productController.orderItemsList.keys.toList();
                            final item =
                                productController.orderItemsList[keys[index]];
                            return reusableItemRowInQuotations(
                              quotationItemInfo: item,
                              index: index,
                              imageProvider:
                                  item['image'] == ''
                                      ? null
                                      : imageProviders[item['image']], // Pass the pre-fetched ImageProvider
                              // width: width,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 10),
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(
                      horizontal: width * 0.01,
                      vertical: 25,
                    ),
                    // width: width * 0.385,
                    // height: 300,
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(9)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Divider(
                          height: 5,
                          color: PdfColors.black,
                          // endIndent: 250
                        ),
                        pw.Row(
                          children: [
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.75,
                                  child: reusableText('subtotal'.tr),
                                ),
                              ],
                            ),

                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(''),
                                ),
                              ],
                            ),
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    numberWithComma(
                                      productController.subtotal.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        homeController.companySubjectToVat != '1'
                            ? pw.Text("")
                            : pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            ),
                        homeController.companySubjectToVat != '1'
                            ? pw.Text("")
                            : pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('VAT'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        productController.posCurrency,
                                      ),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          productController.taxesSum.toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        homeController.companySubjectToVat == '1' &&
                                productController.primaryCurrency !=
                                    productController.posCurrency
                            ? pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            )
                            : pw.Text(""),
                        // TOTAL PRICE AFTER  DISCOUNT
                        homeController.companySubjectToVat == '1' &&
                                productController.primaryCurrency !=
                                    productController.posCurrency
                            ? pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('VAT'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        productController.primaryCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          productController.taxesSumWithExchange
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : pw.Text(""),
                        productController.totalDiscount == 0
                            ? pw.Text("")
                            : pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            ),
                        productController.totalDiscount == 0
                            ? pw.Text("")
                            : pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('discount'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableText(
                                        productController.posCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          productController.totalDiscount
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        pw.Divider(
                          height: 5,
                          color: PdfColors.black,
                          // endIndent: 250
                        ),
                        pw.Row(
                          children: [
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.75,
                                  child: reusableText('total'.tr),
                                ),
                              ],
                            ),

                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    productController.posCurrency,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    numberWithComma(
                                      productController.totalPrice.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        productController.primaryCurrency !=
                                productController.posCurrency
                            ? pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            )
                            : pw.Text(""),
                        //VAT
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.Text("")
                            : pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('total'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        productController.primaryCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          productController
                                              .totalPriceWithExchange
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        pw.Divider(
                          height: 5,
                          color: PdfColors.black,
                          // endIndent: 250
                        ),
                        pw.Row(
                          children: [
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.75,
                                  child: reusableText('remaining'.tr),
                                ),
                              ],
                            ),

                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    productController.posCurrency,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    numberWithComma(
                                      paymentController.remainingWithExchange
                                          .toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.Text("")
                            : pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.Text("")
                            : pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('remaining'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        productController.primaryCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          paymentController
                                              .primaryCurrencyRemaining
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        pw.Divider(
                          height: 5,
                          color: PdfColors.black,
                          // endIndent: 250
                        ),
                        pw.Row(
                          children: [
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.75,
                                  child: reusableText('change'.tr),
                                ),
                              ],
                            ),

                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    productController.posCurrency,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: width * 0.3,
                                  child: reusableNumber(
                                    numberWithComma(
                                      paymentController.changeWithExchange
                                          .toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.Text("")
                            : pw.Divider(
                              height: 5,
                              color: PdfColors.black,
                              // endIndent: 250
                            ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.Text("")
                            : pw.Row(
                              children: [
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.75,
                                      child: reusableText('change'.tr),
                                    ),
                                  ],
                                ),

                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        productController.primaryCurrency,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                      width: width * 0.3,
                                      child: reusableNumber(
                                        numberWithComma(
                                          paymentController
                                              .primaryCurrencyChange
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                  // pw.Divider(endIndent: 5),
                  // pw.Container(
                  //   margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                  //   child: pw.Row(
                  //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       pw.Text(
                  //         '${'remaining'.tr}: ${productController.posCurrency} ${numberWithComma(paymentController.remainingWithExchange.toString())}    ',
                  //         textAlign: pw.TextAlign.center,
                  //         style: pw.TextStyle(
                  //           color: PdfColors.black,
                  //           fontSize: fontSize,
                  //           // fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       productController.primaryCurrency ==
                  //               productController.posCurrency
                  //           ? pw.SizedBox()
                  //           : pw.Text(
                  //             '${productController.primaryCurrency} ${numberWithComma(paymentController.primaryCurrencyRemaining.toString())}',
                  //             textAlign: pw.TextAlign.center,
                  //             style: pw.TextStyle(
                  //               color: PdfColors.black,
                  //               fontSize: fontSize,
                  //               // fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //       pw.SizedBox(width: 10),
                  //     ],
                  //   ),
                  // ),
                  // pw.Divider(endIndent: 5),
                  // pw.Container(
                  //   margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                  //   child: pw.Row(
                  //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       pw.Text(
                  //         '${'change'.tr}: ${productController.posCurrency} ${numberWithComma(paymentController.changeWithExchange.toString())}    ',
                  //         textAlign: pw.TextAlign.center,
                  //         style: pw.TextStyle(
                  //           color: PdfColors.black,
                  //           fontSize: fontSize,
                  //           // fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       productController.primaryCurrency ==
                  //               productController.posCurrency
                  //           ? pw.SizedBox()
                  //           : pw.Text(
                  //             '${productController.primaryCurrency} ${numberWithComma(paymentController.primaryCurrencyChange.toString())}',
                  //             textAlign: pw.TextAlign.center,
                  //             style: pw.TextStyle(
                  //               color: PdfColors.black,
                  //               fontSize: fontSize,
                  //               // fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //       pw.SizedBox(width: 10),
                  //     ],
                  //   ),
                  // ),
                  pw.Divider(endIndent: 5),
                  // pw.SizedBox(height: 3),
                  paymentController.selectedCashingMethodsList.isNotEmpty
                      ? pw.SizedBox(
                        height: cashedMethodsListHeight,
                        child: pw.ListView.builder(
                          itemCount:
                              paymentController
                                  .selectedCashingMethodsList
                                  .length,
                          // itemCount: paymentController.selectedMethodsList.keys.toList().length,
                          itemBuilder: (context, index) {
                            // var keys = paymentController.selectedMethodsList.keys.toList();
                            // Map methodInfo= paymentController.selectedMethodsList[keys[index]];
                            Map methodInfo =
                                paymentController
                                    .selectedCashingMethodsList[index];
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 3,
                              ),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    methodInfo['title'],
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Container(
                                    width: 70,
                                    child: pw.Text(
                                      methodInfo['currency'] ==
                                              productController.primaryCurrency
                                          ? numberWithComma(
                                            double.parse(
                                              methodInfo['price'],
                                            ).toString(),
                                          )
                                          : numberWithComma(
                                            double.parse(
                                              methodInfo['price'],
                                            ).toString(),
                                          ),
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(fontSize: fontSize),
                                    ),
                                  ),
                                  pw.Text(
                                    '  ${methodInfo['currency']}',
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                ],
                              ),
                            );
                            //   _cashedMethod(
                            //   paymentController.selectedMethodsList[keys[index]],
                            // );
                          },
                        ),
                      )
                      : pw.SizedBox(),
                  pw.Divider(endIndent: 5),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Thank You For Your Visit',
                    style: pw.TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
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
                        homeController.companyName.startsWith('GINETTE')
                            ? 5
                            : 0,
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
                        homeController.companyName.startsWith('GINETTE')
                            ? 5
                            : 0,
                  ),
                  clientController.selectedCustomerIdWithOk != '-1'
                      ? pw.Column(
                        children: [
                          pw.Text(
                            '${clientController.selectedCustomerObject['clientNumber']}, ${clientController.selectedCustomerObject['name']}',
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
                                      .selectedCustomerObject['phoneNumber'] !=
                                  null
                              ? pw.Text(
                                '(${clientController.selectedCustomerObject['phoneCode']})-${clientController.selectedCustomerObject['phoneNumber']}'
                                '${clientController.selectedCustomerObject['mobileNumber'] == null ? '' : ',  (${clientController.selectedCustomerObject['mobileCode']})-${clientController.selectedCustomerObject['mobileNumber']}'}',
                                style: pw.TextStyle(fontSize: fontSize),
                              )
                              : pw.SizedBox(),
                          pw.SizedBox(height: 5),
                          clientController.selectedCustomerObject['email'] !=
                                  null
                              ? pw.Text(
                            clientController
                                    .selectedCustomerObject['email'],
                                style: pw.TextStyle(fontSize: fontSize),
                              )
                              : pw.SizedBox(),
                          pw.SizedBox(height: 5),
                          clientController.selectedCustomerObject['taxId'] !=
                                      null ||
                                  '${clientController.selectedCustomerObject['taxId']}' ==
                                      '0'
                              ? pw.Text(
                                '${'tax_number'.tr}: ${clientController.selectedCustomerObject['taxId']}',
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
                        '${'served_by'.tr} ${homeController.useName}',
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
                      pw.Text(
                        paymentController.isReprinted
                            ? 'Reprinted invoice'
                            : 'Invoice',
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.Text(
                        paymentController.invoiceNumber,
                        style: pw.TextStyle(fontSize: fontSize),
                      ),
                      pw.SizedBox(width: 10),
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
                              width: 98,
                              // Set specific width for the name cell
                              child: pw.Text(
                                'Description',
                                style: pw.TextStyle(fontSize: fontSize),
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            pw.Container(
                              width: 90,
                              // Set specific width for the price cell
                              child: pw.Text(
                                'Amount',
                                style: pw.TextStyle(fontSize: fontSize),
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
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
                                      '${entry.value['sign']}${entry.value['quantity']}',
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
                                width: 98,
                                // Set specific width for the name cell
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
                              pw.Container(
                                width: 90,
                                // Set specific width for the price cell
                                height: 25,
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      '${numberWithComma(entry.value['final_price'].toString())} ${productController.posCurrency}',
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
                            ],
                          ),
                      ],
                    ),
                  ),
                  // pw.Container(
                  //   margin: const pw.EdgeInsets.symmetric(horizontal: 20),
                  //       height: itemsListHeight,
                  //       child: pw.ListView.builder(
                  //           itemCount: productController.orderItemsList.keys.toList().length,
                  //           itemBuilder: (context, index) {
                  //             var keys = productController.orderItemsList.keys.toList();
                  //             Map product =productController.orderItemsList[keys[index]];
                  //             return pw.Padding(
                  //               padding: const pw.EdgeInsets.symmetric(vertical: 5.0),
                  //               child: pw.Column(
                  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //                 children: [
                  //                   pw.Row(
                  //                     children: [
                  //                       pw.Text(
                  //                         '${product['item_name'] ?? ''} ',
                  //                         style:  pw.TextStyle(
                  //                           fontSize: 10,
                  //                           fontWeight: pw.FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   pw.Row(
                  //                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       pw.Row(
                  //                         children: [
                  //                           pw.Text(
                  //                             '${product['sign']??''}${product['quantity']} ${'units'.tr} '
                  //                                 'x ${ numberWithComma(double.parse(product['price']).toStringAsFixed(2))} ${productController.orderListCurrency}/${'units'.tr}',
                  //                             style: const pw.TextStyle(
                  //                               fontSize: 7,
                  //                             ),
                  //                           ),
                  //                           product['discount_percent']!=0
                  //                               ?pw.Text(
                  //                             '     W/ ${product['discount_percent']}% ${'discount'.tr}',
                  //                             style: pw.TextStyle(
                  //                                 fontSize: 7,
                  //                                 fontWeight: pw.FontWeight.bold
                  //                             ),
                  //                           ):pw.SizedBox()
                  //                         ],
                  //                       ),
                  //                       pw.Text(
                  //                         '${numberWithComma(product['final_price'].toStringAsFixed(2))} ${productController.orderListCurrency}',
                  //                         style: pw.TextStyle(
                  //                             fontSize: 7,
                  //                             fontWeight: pw.FontWeight.bold,
                  //                             color: PdfColors.black),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             );
                  //
                  //             //   _orderItem(
                  //             //   productController.orderItemsList[keys[index]],
                  //             // );
                  //           }
                  //       ),),
                  pw.SizedBox(height: 10),
                  pw.Divider(endIndent: 5),
                  // pw.SizedBox(height: 10),
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.white),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              width: 50, // Set specific width for the id cell
                              child: pw.Text(''),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            pw.Container(
                              width: 50, // Set specific width for the id cell
                              child: pw.Text(''),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            pw.Container(
                              width: 50,
                              // Set specific width for the name cell
                              child: pw.Text(
                                'subtotal',
                                style: pw.TextStyle(fontSize: fontSize),
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                            pw.Container(
                              width: 90,
                              // Set specific width for the price cell
                              child: pw.Text(
                                numberWithComma(
                                  productController.subtotal.toString(),
                                ),
                                style: pw.TextStyle(fontSize: fontSize),
                              ),
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(color: PdfColors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  homeController.companySubjectToVat == '1'
                      ? pw.Container(
                        margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                        child: pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.white),
                          children:
                              productController.primaryCurrency ==
                                      productController.posCurrency
                                  ? [
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(''),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(
                                            'VAT'.tr,
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 50,
                                          // Set specific width for the name cell
                                          child: pw.Text(
                                            productController.posCurrency,
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 90,
                                          // Set specific width for the price cell
                                          child: pw.Text(
                                            numberWithComma(
                                              productController.taxesSum
                                                  .toString(),
                                            ),
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                  : [
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(''),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(
                                            'VAT'.tr, //'VAT 11%'.tr,
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 50,
                                          // Set specific width for the name cell
                                          child: pw.Text(
                                            productController.posCurrency,
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 90,
                                          // Set specific width for the price cell
                                          child: pw.Text(
                                            numberWithComma(
                                              productController.taxesSum
                                                  .toString(),
                                            ),
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.TableRow(
                                      children: [
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(''),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width:
                                              50, // Set specific width for the id cell
                                          child: pw.Text(''),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 50,
                                          // Set specific width for the name cell
                                          child: pw.Text(
                                            productController.primaryCurrency,
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                        pw.Container(
                                          width: 90,
                                          // Set specific width for the price cell
                                          child: pw.Text(
                                            numberWithComma(
                                              productController
                                                  .taxesSumWithExchange
                                                  .toString(),
                                            ),
                                            style: pw.TextStyle(
                                              fontSize: fontSize,
                                            ),
                                          ),
                                          decoration: pw.BoxDecoration(
                                            border: pw.Border.all(
                                              color: PdfColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                        ),
                      )
                      : pw.SizedBox(),
                  pw.SizedBox(height: 10),
                  productController.totalDiscount != 0
                      ? pw.Container(
                        margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                        child: pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.white),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Container(
                                  width: 50,
                                  // Set specific width for the id cell
                                  child: pw.Text(''),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 50,
                                  // Set specific width for the id cell
                                  child: pw.Text(
                                    'discount'.tr,
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 50,
                                  // Set specific width for the name cell
                                  child: pw.Text(
                                    productController.posCurrency,
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: 90,
                                  // Set specific width for the price cell
                                  child: pw.Text(
                                    numberWithComma(
                                      productController.totalDiscount
                                          .toString(),
                                    ),
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : pw.SizedBox(),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.white),
                      children:
                          productController.primaryCurrency ==
                                  productController.posCurrency
                              ? [
                                pw.TableRow(
                                  children: [
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(''),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(
                                        'total'.tr,
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 50,
                                      // Set specific width for the name cell
                                      child: pw.Text(
                                        productController.posCurrency,
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 90,
                                      // Set specific width for the price cell
                                      child: pw.Text(
                                        numberWithComma(
                                          productController.totalPrice
                                              .toString(),
                                        ),
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                              : [
                                pw.TableRow(
                                  children: [
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(''),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(
                                        'total'.tr,
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 50,
                                      // Set specific width for the name cell
                                      child: pw.Text(
                                        productController.posCurrency,
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 90,
                                      // Set specific width for the price cell
                                      child: pw.Text(
                                        numberWithComma(
                                          productController.totalPrice
                                              .toString(),
                                        ),
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(''),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width:
                                          50, // Set specific width for the id cell
                                      child: pw.Text(''),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 50,
                                      // Set specific width for the name cell
                                      child: pw.Text(
                                        productController.primaryCurrency,
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 90,
                                      // Set specific width for the price cell
                                      child: pw.Text(
                                        numberWithComma(
                                          productController
                                              .totalPriceWithExchange
                                              .toString(),
                                        ),
                                        style: pw.TextStyle(fontSize: fontSize),
                                      ),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                    ),
                  ),
                  pw.Divider(endIndent: 5),
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${'remaining'.tr}: ${productController.posCurrency} ${numberWithComma(paymentController.remainingWithExchange.toString())}    ',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: fontSize,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.SizedBox()
                            : pw.Text(
                              '${productController.primaryCurrency} ${numberWithComma(paymentController.primaryCurrencyRemaining.toString())}',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: fontSize,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                        pw.SizedBox(width: 10),
                      ],
                    ),
                  ),
                  pw.Divider(endIndent: 5),
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(horizontal: 3),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${'change'.tr}: ${productController.posCurrency} ${numberWithComma(paymentController.changeWithExchange.toString())}    ',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: fontSize,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        productController.primaryCurrency ==
                                productController.posCurrency
                            ? pw.SizedBox()
                            : pw.Text(
                              '${productController.primaryCurrency} ${numberWithComma(paymentController.primaryCurrencyChange.toString())}',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: fontSize,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                        pw.SizedBox(width: 10),
                      ],
                    ),
                  ),
                  pw.Divider(endIndent: 5),
                  // pw.SizedBox(height: 3),
                  paymentController.selectedCashingMethodsList.isNotEmpty
                      ? pw.SizedBox(
                        height: cashedMethodsListHeight,
                        child: pw.ListView.builder(
                          itemCount:
                              paymentController
                                  .selectedCashingMethodsList
                                  .length,
                          // itemCount: paymentController.selectedMethodsList.keys.toList().length,
                          itemBuilder: (context, index) {
                            // var keys = paymentController.selectedMethodsList.keys.toList();
                            // Map methodInfo= paymentController.selectedMethodsList[keys[index]];
                            Map methodInfo =
                                paymentController
                                    .selectedCashingMethodsList[index];
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 3,
                              ),
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    methodInfo['title'],
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Container(
                                    width: 70,
                                    child: pw.Text(
                                      methodInfo['currency'] ==
                                              productController.primaryCurrency
                                          ? numberWithComma(
                                            double.parse(
                                              methodInfo['price'],
                                            ).toString(),
                                          )
                                          : numberWithComma(
                                            double.parse(
                                              methodInfo['price'],
                                            ).toString(),
                                          ),
                                      textAlign: pw.TextAlign.right,
                                      style: pw.TextStyle(fontSize: fontSize),
                                    ),
                                  ),
                                  pw.Text(
                                    '  ${methodInfo['currency']}',
                                    style: pw.TextStyle(fontSize: fontSize),
                                  ),
                                ],
                              ),
                            );
                            //   _cashedMethod(
                            //   paymentController.selectedMethodsList[keys[index]],
                            // );
                          },
                        ),
                      )
                      : pw.SizedBox(),
                  pw.Divider(endIndent: 5),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Thank You For Your Visit',
                    style: pw.TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  reusableText(String text) {
    return text.isEmpty
        ? pw.SizedBox()
        : pw.Text(text, style: pw.TextStyle(fontSize: 7));
  }

  reusableNumber(String text) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [pw.Text(text, style: pw.TextStyle(fontSize: 7))],
    );
  }

  tableTitle({required String text, required double width}) {
    return pw.SizedBox(
      width: width,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.black,
          fontSize: 7,
          fontWeight: pw.FontWeight.normal,
          // decoration: pw.TextDecoration.underline,
        ),
      ),
    );
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
