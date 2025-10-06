import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pos_project/Controllers/home_controller.dart';
import 'package:pos_project/Controllers/transfer_controller.dart';
import 'package:printing/printing.dart';
import '../../../const/colors.dart';
import '../../Widgets/page_title.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;

import '../../const/Sizes.dart';

class PrintTransferIn extends StatefulWidget {
  const PrintTransferIn(
      {super.key,
      required this.transferNumber,
      required this.ref,
      required this.transferTo,
        required this.rowsInListViewInTransfer,
        required this.receivedDate,
        required this.creationDate,
        required this.transferFrom, required this.receivedUser, required this.senderUser, required this.status, this.isInTransferOut=false});
  final String transferNumber;
  final String ref;
  final String receivedDate;
  final String creationDate;
  final String receivedUser;
  final String senderUser;
  final String transferFrom;
  final String transferTo;
  final String status;
  final bool isInTransferOut;
  final List rowsInListViewInTransfer;

  @override
  State<PrintTransferIn> createState() => _PrintTransferInState();
}

class _PrintTransferInState extends State<PrintTransferIn> {
  bool isHomeHovered = false;
  // final ProductController productController = Get.find();
  // final PaymentController paymentController = Get.find();
  final TransferController transferController=Get.find();

  @override
  Widget build(BuildContext context) {
    HomeController homeController=Get.find();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if(transferController.isSubmitAndPreviewClicked){
                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) {
                          //           return const HomePage();
                          //         }));
                          transferController.getAllTransactionsFromBack();
                          Get.back();
                          homeController.selectedTab.value = 'transfers';
                        }else{Get.back();}
                        // Navigator.pushReplacement(context, MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return const CashTrayOptions();
                        //     }));
                      },
                      child: Icon(Icons.arrow_back,
                          size: 22,
                          // color: Colors.grey,
                          color: Primary.primary),
                    ),
                    gapW10,
                    const PageTitle(text: 'Inter-Warehouse Transfer'),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onHover: (val) {
                      setState(() {
                        isHomeHovered = val;
                      });
                    },
                    child: Icon(
                      Icons.home,
                      size: 30,
                      color:
                      isHomeHovered ? Primary.primary : Colors.grey,
                    ),
                    onTap: () {
                      Get.back();
                      homeController.selectedTab.value = 'transfers';
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) {
                      //           return const HomePage();
                      //         }));
                      // productController.resetAll();
                      // paymentController.resetAll();
                      // // productController.resetAll();
                      // // paymentController.resetAll();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) {
                      //           return const HomePage();
                      //         }));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              width: Sizes.deviceWidth * 0.35,
              height: Sizes.deviceHeight * 0.85,
              child: PdfPreview(
                build: (format) => _generatePdf(format, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    double width = MediaQuery.of(context).size.width;
    var gapW20 = pw.SizedBox(width: 20);
    var gapH40 = pw.SizedBox(height: 40);
    var gapH4 = pw.SizedBox(height: 4);
    var gapH10 = pw.SizedBox(height: 10);
    tableTitle({required String text, required double width}) {
      return pw.SizedBox(
          width: width,
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.left,
            style: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 23,
                fontWeight: pw.FontWeight.bold),
          ));
    }

    reusableTitle({required String text}) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            text,
            style: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 26,
                fontWeight: pw.FontWeight.bold),
          )
        ]
      );
    }

    reusableShowInfoCard({required double width, required String text}) {
      return pw.Container(
        width: width,
        padding: const pw.EdgeInsets.symmetric(horizontal: 2),
        child: pw.Text(text, textAlign: pw.TextAlign.center,style: const pw.TextStyle(
            fontSize: 23
        )),
      );
    }

    reusableItemRowInTransferIn(
        {required Map transferredItemInfo, required int index}) {
      return pw.Container(
        // margin: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: width* 0.25,
              padding: const pw.EdgeInsets.symmetric(horizontal: 2),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text(transferredItemInfo['itemName'], style: const pw.TextStyle(
                    fontSize: 23
                )),
                pw.Text(transferredItemInfo['mainDescription']??'', style: const pw.TextStyle(
                    fontSize: 23
                ))
              ]),),

            // reusableShowInfoCard(
            //     text:transferredItemInfo['mainDescription']==''
            //         ? transferredItemInfo['itemName'] ?? ''
            //         :'${transferredItemInfo['itemName']} \n ${transferredItemInfo['mainDescription']}',
            //     width: width * 0.13),
            // reusableShowInfoCard(
            //     text: transferredItemInfo['mainDescription'] ?? '',
            //     width: width * 0.05),
            // reusableShowInfoCard(
            //     text: '${transferredItemInfo['transferredQty'] ?? ''}',
            //     width: width * 0.04),
            // reusableShowInfoCard(
            //     text:
            //         '${transferredItemInfo['transferredQtyPackageName'] ?? ''}',
            //     width: width * 0.04),
            reusableShowInfoCard(
                text:
                    '${transferredItemInfo['receivedQty'] ?? '0'} ${transferredItemInfo['transferredQtyPackageName'] ?? ''}',
                width: width * 0.1),
            // reusableShowInfoCard(
            //     text:
            //         '${transferredItemInfo['transferredQtyPackageName'] ?? ''}',
            //     width: width * 0.04),
            // reusableShowInfoCard(
            //     text:
            //         '${transferredItemInfo['qtyDifference'] ?? '0'}',
            //     width: width * 0.04),
            // reusableShowInfoCard(
            //     text:
            //         '${transferredItemInfo['transferredQtyPackageName'] ?? ''}',
            //     width: width * 0.04),
            // reusableShowInfoCard(
            //     text:
            //         '${transferredItemInfo['note'] ?? ''}',
            //     width: width * 0.04),
          ],
        ),
      );
    }
   reusableText(String text){
      return  pw.Text(text, style: const pw.TextStyle(
        fontSize: 23,
      ));
   }
    pdf.addPage(
        pw.MultiPage(

        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                reusableTitle(
                    text: 'Inter-Warehouse Transfer'),
                reusableTitle(
                    text: '${widget.transferNumber}'
                        '${widget.ref!=''?'/${widget.ref}':''}'),
                gapH40,
                reusableText('${'status'.tr}: ${widget.status}'),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          gapH4,
                          reusableText('${'transfer_date'.tr}: ${widget.creationDate}'),
                          gapH4,
                          reusableText('${'sender_user'.tr}: ${widget.senderUser}'),
                          gapH4,
                          reusableText('${'src_whse'.tr}: ${widget.transferFrom}'),
                        ]
                    ),
                    gapW20,
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          gapH4,
                          reusableText(widget.receivedDate!=''?'${'received_date'.tr}: ${widget.receivedDate}':''),
                          gapH4,
                          reusableText(widget.receivedUser!=''?'${'receiver_user'.tr}: ${widget.receivedUser}':''),
                          gapH4,
                          reusableText('${'dest_whse'.tr}: ${widget.transferTo}'),
                        ]
                    )
                  ]
                ),

                // pw.Text('${'status'.tr}: ${widget.status}'),
                // gapH4,
                // pw.Text('${'creation_date'.tr}: ${widget.creationDate}    ${widget.receivedDate!=''?'${'received_date'.tr}: ${widget.receivedDate}':''}'),
                // gapH4,
                // pw.Text('${'src_whse'.tr}: ${widget.transferFrom}        ${'dest_whse'.tr}: ${widget.transferTo}'),
                // // pw.Text('${'dest_whse'.tr}: ${widget.transferTo}'),
                // gapH4,
                // pw.Text('${'sender_user'.tr}: ${widget.senderUser}        ${widget.receivedUser!=''?'${'receiver_user'.tr}: ${widget.receivedUser}':''}'),
                // // pw.Text('${'receiver_user'.tr}: ${widget.transferTo}'),
                // gapH4,
                gapH10,
                pw.Divider(
                  color: PdfColors.black,
                  // endIndent: 250
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    tableTitle(
                      text: 'item'.tr,
                      width: width * 0.25,
                    ),
                    // tableTitle(
                    //   text: 'description'.tr,
                    //   width: width * 0.05,
                    // ),
                    // tableTitle(
                    //   text: 'qty_transferred'.tr,
                    //   width: width * 0.04,
                    // ),
                    // tableTitle(
                    //   text: 'pack'.tr,
                    //   width: width * 0.04,
                    // ),
                    tableTitle(
                      text: 'qty_received'.tr,
                      width: width * 0.1,
                    ),
                    // tableTitle(
                    //   text: 'pack'.tr,
                    //   width: width * 0.04,
                    // ),
                    // tableTitle(
                    //   text: 'difference'.tr,
                    //   width: width * 0.04,
                    // ),
                    // tableTitle(
                    //   text: 'pack'.tr,
                    //   width: width * 0.04,
                    // ),
                    // tableTitle(
                    //   text: 'note'.tr,
                    //   width: width * 0.04,
                    // ),
                  ],
                ),
                gapH4,
                pw.Divider(
                  color: PdfColors.black,
                  // endIndent: 250
                ),
                pw.ListView.builder(
                  padding: const pw.EdgeInsets.symmetric(vertical: 10),
                  itemCount: widget.rowsInListViewInTransfer
                      .length, //products is data from back res
                  itemBuilder: (context, index) => reusableItemRowInTransferIn(
                    transferredItemInfo: widget.rowsInListViewInTransfer[index],
                    index: index,
                  ),
                ),
              ],
            ),
          ];
        }));

    return pdf.save();
  }
}
