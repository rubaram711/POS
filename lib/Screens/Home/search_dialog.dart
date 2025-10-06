import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/home_controller.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Backend/CategoriesBackend/get_categories.dart';
import '../../Backend/ProductsBackend/get_products.dart';
import '../../Controllers/products_controller.dart';
import '../../Widgets/loading.dart';
import '../../Widgets/reusable_btn.dart';
import '../../Widgets/reusable_text_field.dart';
import 'home_content.dart';


TextEditingController catNameController = TextEditingController();
TextEditingController selectedRootController = TextEditingController();
class SearchDialogContent extends StatefulWidget {
  const SearchDialogContent({super.key});

  @override
  State<SearchDialogContent> createState() =>
      _SearchDialogContentState();
}

class _SearchDialogContentState
    extends State<SearchDialogContent> {
  int selectedTabIndex = 0;
  final HomeController homeController = Get.find();
  // final ProductController productController = Get.find();
  TextEditingController searchController = TextEditingController();
  bool isYesClicked=false;
  List<String> customerNameList = [];
  String? selectedItem = '';
  String selectedCustomerIds = '';
  List customerIdsList = [];

  List<String>  categoriesNameList=['all_categories'.tr];
  List categoriesIds=['0'];
  String selectedCategoryId='0';
  bool isCategoriesFetched = false;
  getCategoriesFromBack() async {
    var p = await getCategories();
    setState(() {
      for (var item in p) {
        categoriesNameList.add('${item['category_name']}');
        categoriesIds.add('${item['id']}');
        isCategoriesFetched = true;
      }});
  }

  ProductController productController = Get.find();
  List productsList = [];
  bool isProductsFetched = false;
  getAllProductsFromBack() async {
    setState(() {
      productsList=[];
    });
    var p = await getAllProducts(searchController.text,selectedCategoryId=='0'?'': selectedCategoryId,'1','',searchByBarcodeController.text,-1);
    setState(() {
      productsList.addAll(p);
      isProductsFetched = true;
    });
  }
bool isJustOpened=true;
  @override
  void initState() {
    getCategoriesFromBack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DialogTitle(text: 'search'.tr),
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
          gapH32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DialogTextFieldWithoutText(
                hint: 'search'.tr,
                textEditingController: searchController,
                textFieldWidth: MediaQuery.of(context).size.width * 0.55,
              onIconClickedFunc: () {},
                validationFunc: (val) {},
                onChangedFunc: (val){},
                onCloseIconClickedFunc:(){},
              ),
              // DropdownMenu<String>(
              //   width: MediaQuery.of(context).size.width *
              //       0.6,
              //   // requestFocusOnTap: false,
              //   enableSearch: true,
              //   controller: searchController,
              //   hintText: '${'search'.tr}...',
              //   inputDecorationTheme:
              //   InputDecorationTheme(
              //     // filled: true,
              //     hintStyle: const TextStyle(
              //         fontStyle: FontStyle.italic),
              //     contentPadding:
              //     const EdgeInsets.fromLTRB(
              //         20, 0, 25, 5),
              //     // outlineBorder: BorderSide(color: Colors.black,),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           color: Primary.primary
              //               .withAlpha((0.2 * 255).toInt()),
              //           width: 1),
              //       borderRadius: const BorderRadius.all(
              //           Radius.circular(9)),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           color: Primary.primary
              //               .withAlpha((0.4 * 255).toInt()),
              //           width: 2),
              //       borderRadius: const BorderRadius.all(
              //           Radius.circular(9)),
              //     ),
              //   ),
              //   // menuStyle: ,
              //   menuHeight: 250,
              //   dropdownMenuEntries: customerNameList
              //       .map<DropdownMenuEntry<String>>(
              //           (String option) {
              //         return DropdownMenuEntry<String>(
              //           value: option,
              //           label: option,
              //         );
              //       }).toList(),
              //   enableFilter: true,
              //   onSelected: (String? val) {
              //     setState(() {
              //       selectedItem = val!;
              //       var index =
              //       customerNameList.indexOf(val);
              //       selectedCustomerIds =
              //       customerIdsList[index];
              //     });
              //   },
              // ),
              DropdownMenu<String>(
                width: MediaQuery.of(context).size.width * 0.15,
                requestFocusOnTap: false,
                hintText: 'all_categories'.tr,
                inputDecorationTheme: InputDecorationTheme(
                  // filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                  // outlineBorder: BorderSide(color: Colors.black,),
                  enabledBorder:OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                  ),
                ),
                // menuStyle: ,
                dropdownMenuEntries:categoriesNameList
                    .map<DropdownMenuEntry<String>>(
                        (String option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                        // enabled: option.label != 'Grey',
                        // style: MenuItemButton.styleFrom(
                        // foregroundColor: color.color,
                        // ),
                      );
                    }).toList(),
                onSelected: (String? val) {
                  setState(() {
                    selectedItem = val!;
                    var index = categoriesNameList.indexOf(val);
                    selectedCategoryId=categoriesIds[index];
                  });
                },
              ),
              ReusableButtonWithColor(
                  btnText: 'apply_filter'.tr,
                  onTapFunction: ()async {
                    setState(() {
                      isJustOpened=false;
                      isProductsFetched=false;
                    });
                    await getAllProductsFromBack();
                  },
                  radius: 9,
                  width: 100,
                  height: 47),
            ],
          ),
          gapH32,
          isJustOpened
          ?const Spacer()
          :isProductsFetched?Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: (1.3 / 1.1),
              children:
              List.generate(productsList.length, (index) {
                return  ItemCard(
                  product: productsList[index],
                  index : index,
                );
              }),
            ),
          ):Expanded(child: Center(child: loading())),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     TextButton(
          //         onPressed: (){
          //           setState(() {
          //             catNameController.clear();
          //             selectedRootController.clear();
          //             // shortDescriptionController.clear();
          //             // secondLanguageController.clear();
          //             // discLineLimitController.clear();
          //             // supplierCodeController.clear();
          //             // alternativeCodeController.clear();
          //             // barcodeController.clear();
          //           });
          //         },
          //         child: Text('discard'.tr,style: TextStyle(
          //             decoration: TextDecoration.underline,
          //             color: Primary.primary
          //         ),)),
          //     gapW24,
          //     ReusableButtonWithColor(btnText: 'save'.tr, onTapFunction: ()async{
          //       // var res=await storeCategory();
          //       // print('p ${res['success']}');
          //       // if (res['success'] == true) {
          //       //   CommonWidgets.snackBar('',
          //       //       'Quotation Created Successfully');
          //       //   // setState(() {
          //       //   //   isQuotationsInfoFetched = false;
          //       //   //   getFieldsForCreateQuotationFromBack();
          //       //   // });
          //       //   Get.back();
          //       //   homeController.selectedTab.value =
          //       //   'items';
          //       // } else {
          //       //   CommonWidgets.snackBar('error',
          //       //       'Enter the required fields');
          //       // }
          //     }, width: 100, height: 35),
          //   ],
          // )
        ],
      ),
    );
  }

  // Widget _buildTabChipItem(String name, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedTabIndex = index;
  //       });
  //     },
  //     child: ClipPath(
  //       clipper: const ShapeBorderClipper(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(9),
  //                   topRight: Radius.circular(9)))),
  //       child: Container(
  //         width: MediaQuery.of(context).size.width * 0.09,
  //         height: MediaQuery.of(context).size.height * 0.07,
  //         // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
  //         decoration: BoxDecoration(
  //             color: selectedTabIndex == index ? Primary.p20 : Colors.white,
  //             border: selectedTabIndex == index
  //                 ? Border(
  //               top: BorderSide(color: Primary.primary, width: 3),
  //             )
  //                 : null,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withAlpha((0.5 * 255).toInt()),
  //                 spreadRadius: 9,
  //                 blurRadius: 9,
  //                 offset: const Offset(0, 3),
  //               )
  //             ]),
  //         child: Center(
  //           child: Text(
  //             name.tr,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold, color: Primary.primary),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class DialogTitle extends StatelessWidget {
  const DialogTitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: TypographyColor.titleTable,
          fontSize: 16),
    );
  }
}


//
// class DialogDropMenu extends StatefulWidget {
//   const DialogDropMenu({super.key, required this.optionsList, required this.rowWidth, required this.textFieldWidth, required this.text, required this.onSelected, required this.hint, this.controller, required this.isDetectedHeight});
//   final List<String> optionsList;
//   final double rowWidth;
//   final double textFieldWidth;
//   final String text;
//   final String hint;
//   final Function onSelected;
//   final TextEditingController? controller;
//   final bool isDetectedHeight;
//   @override
//   State<DialogDropMenu> createState() => _DialogDropMenuState();
// }
//
// class _DialogDropMenuState extends State<DialogDropMenu> {
//   final TextEditingController controller = TextEditingController();
//   String? selectedItem ;
//   @override
//   void initState() {
//     selectedItem  = widget.optionsList[0];
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return   SizedBox(
//       width: widget.rowWidth,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(widget.text),
//           DropdownMenu<String>(
//             width: widget.textFieldWidth,
//             requestFocusOnTap: false,
//             hintText: widget.hint,
//             inputDecorationTheme: InputDecorationTheme(
//               // filled: true,
//               contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
//               // outlineBorder: BorderSide(color: Colors.black,),
//               enabledBorder:OutlineInputBorder(
//                 borderSide:
//                 BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
//                 borderRadius: const BorderRadius.all(Radius.circular(9)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide:
//                 BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
//                 borderRadius: const BorderRadius.all(Radius.circular(9)),
//               ),
//             ),
//             menuStyle: widget.isDetectedHeight
//                 ? MenuStyle(
//                 maximumSize: MaterialStateProperty.resolveWith((states) {
//                   // if (states.contains(MaterialState.disabled)) {
//                   //   return Size(width, height);
//                   // }
//                   return const Size(400, 400);
//                 }))
//                 : null,
//             dropdownMenuEntries: widget.optionsList
//                 .map<DropdownMenuEntry<String>>(
//                     (String option) {
//                   return DropdownMenuEntry<String>(
//                     value: option,
//                     label: option,
//                     // enabled: option.label != 'Grey',
//                     // style: MenuItemButton.styleFrom(
//                     // foregroundColor: color.color,
//                     // ),
//                   );
//                 }).toList(),
//             onSelected: (String? val) {
//               widget.onSelected(val);
//               setState(() {
//                 selectedItem = val!;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


class DialogDropMenu extends StatefulWidget {
  const DialogDropMenu(
      {super.key,
        required this.optionsList,
        required this.rowWidth,
        required this.textFieldWidth,
        required this.text,
        required this.onSelected,
        required this.hint,
        this.controller,
        this.isDetectedHeight = false,
        this.isSearchEnabled = false

      });
  final List<String> optionsList;
  final double rowWidth;
  final double textFieldWidth;
  final String text;
  final String hint;
  final Function onSelected;
  final TextEditingController? controller;
  final bool isDetectedHeight;
  final bool isSearchEnabled ;
  @override
  State<DialogDropMenu> createState() => _DialogDropMenuState();
}

class _DialogDropMenuState extends State<DialogDropMenu> {
  // final TextEditingController controller = TextEditingController();
  // String? selectedItem;
  @override
  void initState() {
    // selectedItem = widget.optionsList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text),
          DropdownMenu<String>(
            controller: widget.controller,
            width: widget.textFieldWidth,
            requestFocusOnTap: false,
            hintText: widget.hint,
            enableSearch: widget.isSearchEnabled,
              inputDecorationTheme: InputDecorationTheme(
              // filled: true,
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
              // outlineBorder: BorderSide(color: Colors.black,),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(9)),
              ),
            ),
            // menuStyle: widget.isDetectedHeight
            //     ? MenuStyle(
            //     maximumSize: MaterialStateProperty.resolveWith((states) {
            //       // if (states.contains(MaterialState.disabled)) {
            //       //   return Size(width, height);
            //       // }
            //       return const Size(400, 400);
            //     }))
            //     : null,
            dropdownMenuEntries: widget.optionsList
                .map<DropdownMenuEntry<String>>((String option) {
              return DropdownMenuEntry<String>(
                value: option,
                label: widget.isDetectedHeight
                    ? option.length > 35
                    ? '${option.substring(0, 35)}...'
                    : option
                    : option,
                // enabled: option.label != 'Grey',
                // style: MenuItemButton.styleFrom(
                // foregroundColor: color.color,
                // ),
              );
            }).toList(),
            onSelected: (String? val) {
              widget.onSelected(val);
              // setState(() {
              //   selectedItem = val!;
              // });
            },
          ),
        ],
      ),
    );
  }
}


