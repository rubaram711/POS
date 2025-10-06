//
//
//
//
// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pos_project/Screens/Home/search_dialog.dart';
// import '../../Backend/CategoriesBackend/get_categories.dart';
// import '../../Backend/ProductsBackend/get_products.dart';
// import '../../Controllers/products_controller.dart';
// import '../../Widgets/custom_drop_down_menu.dart';
// import '../../Widgets/loading.dart';
// import '../../Widgets/reusable_btn.dart';
// import '../../const/Sizes.dart';
// import '../../const/colors.dart';
//
//
//
//
//
//
// class HomeContent extends StatefulWidget {
//   const HomeContent({Key? key}) : super(key: key);
//
//   @override
//   State<HomeContent> createState() => _HomeContentState();
// }
//
// class _HomeContentState extends State<HomeContent> {
//   String selectedCustomer = '';
//   String selectedCategoryId='0';
//   bool isFilterCatClicked=false;
//   var shiftStart;
//   List categoriesList = [
//     {'category_name':'All Menu'},
//   ];
//   bool isCategoriesFetched = false;
//   getCategoriesFromBack() async {
//     var p = await getCategories();
//     setState(() {
//       categoriesList.addAll(p);
//       isCategoriesFetched = true;
//     });
//   }
//
//   ProductController productController = Get.find();
//   List productsList = [];
//   bool isProductsFetched = false;
//   getAllProductsFromBack() async {
//     setState(() {
//       isProductsFetched = false;
//       productsList = [];
//     });
//     var p = await getAllProducts('', selectedCategoryId=='0'?'': selectedCategoryId);
//     setState(() {
//       productsList.addAll(p);
//       isProductsFetched = true;
//     });
//   }
//
//
//   @override
//   void initState() {
//     start();
//     shiftStart=DateFormat('hh:mm:ss').format(DateTime.now());
//     getCategoriesFromBack();
//     getAllProductsFromBack();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height:  MediaQuery.of(context).size.height * 0.87,
//       margin: const EdgeInsets.only( right: 20,top: 15,left:20),
//       padding: const EdgeInsets.only(right: 20, left: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 14,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 _shiftShow(),
//                 _topMenu(
//                   title: 'Menu Items',
//                   subTitle: '(${productsList.length})',
//                   action: _search(),//todo remove
//                 ),
//                 Container(
//                   height: 85,
//                   padding: const EdgeInsets.symmetric(vertical: 24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width*0.57,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categoriesList.length,
//                           itemBuilder: (context, index) =>  _categoryCard(
//                               title: categoriesList[index]['category_name'],
//                               index: index,
//                               id: '${categoriesList[index]['id'] ?? '0'}'
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 20.0),
//                         child: InkWell(
//                             onTap: (){
//                               showDialog<String>(
//                                   context: context,
//                                   builder: (BuildContext context) => const AlertDialog(
//                                     backgroundColor: Colors.white,
//                                     contentPadding: EdgeInsets.all(0),
//                                     titlePadding: EdgeInsets.all(0),
//                                     actionsPadding: EdgeInsets.all(0),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                       BorderRadius.all(Radius.circular(9)),
//                                     ),
//                                     elevation: 0,
//                                     content: SearchDialogContent(),
//                                   ));
//                             },
//                             child: Icon(Icons.search,
//                                 color:Primary.primary
//
//                             )),
//                       ),
//                       // gapW4,
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 6,
//                     childAspectRatio: (1 / 1.1),
//                     children:
//                     List.generate(productsList.length, (index) {
//                       return  ItemCard(
//                         product: productsList[index],
//                         index: index,
//                       );
//                     }),
//                     // const [
//                     //   Item(
//                     //     image: 'items/1.png',
//                     //     title: 'Original Burger',
//                     //     price: '\$5.99',
//                     //     item: '11 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/2.png',
//                     //     title: 'Double Burger',
//                     //     price: '\$10.99',
//                     //     item: '10 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/3.png',
//                     //     title: 'Cheese Burger',
//                     //     price: '\$6.99',
//                     //     item: '7 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/4.png',
//                     //     title: 'Double Cheese Burger',
//                     //     price: '\$12.99',
//                     //     item: '20 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/5.png',
//                     //     title: 'Spicy Burger',
//                     //     price: '\$7.39',
//                     //     item: '12 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/6.png',
//                     //     title: 'Special Black Burger',
//                     //     price: '\$7.39',
//                     //     item: '39 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/7.png',
//                     //     title: 'Special Cheese Burger',
//                     //     price: '\$8.00',
//                     //     item: '2 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/8.png',
//                     //     title: 'Jumbo Cheese Burger',
//                     //     price: '\$15.99',
//                     //     item: '2 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/9.png',
//                     //     title: 'Spicy Burger',
//                     //     price: '\$7.39',
//                     //     item: '12 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/10.png',
//                     //     title: 'Special Black Burger',
//                     //     price: '\$7.39',
//                     //     item: '39 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/11.png',
//                     //     title: 'Special Cheese Burger',
//                     //     price: '\$8.00',
//                     //     item: '2 item',
//                     //   ),
//                     //   Item(
//                     //     image: 'items/12.png',
//                     //     title: 'Jumbo Cheese Burger',
//                     //     price: '\$15.99',
//                     //     item: '2 item',
//                     //   ),
//                     // ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Expanded(flex: 1, child: Container()),
//           Expanded(
//             flex: 6,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//               height:  MediaQuery.of(context).size.height*0.85 ,
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(18))
//               ),
//               child: GetBuilder<ProductController>(
//                   builder: (controller) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _topMenu(
//                           title: 'Order\'s Summary',
//                           subTitle: '',
//                           action: Container(),
//                         ),
//                         gapH10,
//                         CustomDropDownMenu(
//                           optionsList: ['cash_customer'.tr, 'madlen Mhd','alaa ta'],
//                           text: 'customer'.tr,
//                           hint: 'cash_customer'.tr,
//                           rowWidth:
//                           MediaQuery.of(context).size.width * 0.25,
//                           textFieldWidth:
//                           MediaQuery.of(context).size.width * 0.15,
//                           onSelected: (value) {
//                             setState(() {
//                               selectedCustomer = value;
//                             });
//                           },
//                         ),
//                         gapH10,
//                         Text(
//                           'Total Items (${controller.orderList.length})',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Container(
//                           height:  MediaQuery.of(context).size.height*0.3,
//                           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
//                           child: ListView.builder(
//                               itemCount: controller.orderList.length,
//                               itemBuilder: (context, index) =>  _itemOrder(
//                                   controller.orderList[index]
//                               )
//                             // [
//                             //   _itemOrder(
//                             //     image: 'items/1.png',
//                             //     title: 'Original Burger',
//                             //     qty: 2,
//                             //     price: 5.99,
//                             //   ),
//                             //   _itemOrder(
//                             //     image: 'items/2.png',
//                             //     title: 'Double Burger',
//                             //     qty: 3,
//                             //     price: 10.99,
//                             //   ),
//                             //   _itemOrder(
//                             //     image: 'items/6.png',
//                             //     title: 'Special Black Burger',
//                             //     qty: 2,
//                             //     price: 8.00,
//                             //   ),
//                             //   _itemOrder(
//                             //     image: 'items/4.png',
//                             //     title: 'Special Cheese Burger',
//                             //     qty: 2,
//                             //     price: 12.99,
//                             //   ),
//                             // ],
//                           ),
//                         ),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Container(
//                               // padding: const EdgeInsets.all(20),
//                               margin: const EdgeInsets.symmetric(vertical: 15),
//                               padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(14),
//                                   color: Colors.white,
//                                   border: Border.all(color:Colors.grey.withAlpha((0.2 * 255).toInt()))
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Text(
//                                     'Payment Summary',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15
//                                     ),
//                                   ),
//                                   SizedBox(height:Sizes.deviceHeight*0.01),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         'Price',
//                                         style: TextStyle(),
//                                       ),
//                                       Text(
//                                         '\$${controller.totalPrice}',
//                                         style: const TextStyle(
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height:Sizes.deviceHeight*0.01),
//                                   const Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Taxes',
//                                         style: TextStyle(
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         '\$0',
//                                         style: TextStyle(
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height:Sizes.deviceHeight*0.01),
//                                   const Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Discount',
//                                         style: TextStyle(
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         '\$0',
//                                         style: TextStyle(
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     margin:   EdgeInsets.symmetric(vertical:Sizes.deviceHeight*0.01),
//                                     height: 2,
//                                     width: double.infinity,
//                                     child: const Divider(),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         'Total',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15
//                                         ),
//                                       ),
//                                       Text(
//                                         '\$${controller.totalPrice}',//todo another total after discounts and taxes
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Primary.primary,
//                                             fontSize: 15
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         ReusableButtonWithColor(
//                           btnText: 'Place Order', onTapFunction: (){},
//                           height: 40,
//                           width: Sizes.deviceWidth*0.4,
//                         )
//                       ],
//                     );
//                   }
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _itemOrder(Map product) {
//     return GetBuilder<ProductController>(
//         builder: (controller) {
//           return Container(
//             padding: const EdgeInsets.all(10),
//             margin: const EdgeInsets.only(bottom: 10),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 color: Colors.white,
//                 border: Border.all(color:Colors.grey.withAlpha((0.2 * 255).toInt()))
//             ),
//             child: Row(
//               crossAxisAlignment:CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius
//                       .all(Radius.circular(12)),
//                   child: CachedNetworkImage(
//                     imageUrl: '${product['images']}'=='[]'
//                         ?'http://rooster.williamtouma.com/roosterV2/backend/public/storage/WhatsApp%20Image%202024-03-03%20at%2011.41.15%20AM.jpeg'
//                         :'${product['images'][0]}',
//                     height: 70,
//                     width: 70,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => loading(),
//                     errorWidget: (context, url, error) => loading(),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             '${product['item_name'] ?? ''} ',
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//
//                             ),
//                           ),
//                           gapW10,
//                           Container(
//                               width:Sizes.deviceWidth*0.05,
//                               height: Sizes.deviceHeight*0.031,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(14)),),
//                               // decoration: BoxDecoration(
//                               //     borderRadius: BorderRadius.circular(18),
//                               //     color: Colors.white,
//                               //     border: Border.all(color: Primary.primary)
//                               // ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(1),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(25)),
//                                     ),
//                                     child: InkWell(
//                                       highlightColor: Colors.green,
//                                       onTap: () {
//                                         if(controller.orderItemsQuantities[product['id']]>1){
//                                           controller.addToOrderItemsQuantities(product['id'], controller.orderItemsQuantities[product['id']]-1);
//                                           controller.decreaseTotal(product['unitPrice']);}
//                                       },
//                                       child: const Icon(Icons.remove,size: 14),
//                                     ),
//                                   ),
//                                   gapW4,
//                                   // Container(
//                                   //   padding: const EdgeInsets.symmetric(
//                                   //       vertical: 3, horizontal: 5),
//                                   //   decoration: BoxDecoration(
//                                   //     color: Colors.grey[300],
//                                   //     borderRadius: const BorderRadius.all(
//                                   //         Radius.circular(5)),
//                                   //   ),
//                                   //   child:,
//                                   // ),
//                                   Text('${controller.orderItemsQuantities[product['id']]}'),
//                                   gapW4,
//                                   Container(
//                                     padding: const EdgeInsets.all(1),
//                                     decoration: const BoxDecoration(
//                                       color:Colors.white,
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(25)),
//                                     ),
//                                     child: InkWell(
//                                       child: const Icon(Icons.add,size: 14,),
//                                       // highlightColor: Colors.green,
//                                       onTap: () {
//                                         //todo right quantity in if statement
//                                         if (controller.orderItemsQuantities[product['id']] <40) {
//                                           //   setState(() {
//                                           //     counter++;
//                                           //   });
//                                           // cont.setTotalPrice(
//                                           //     cont.counter * price);
//                                           controller.addToOrderItemsQuantities(product['id'], controller.orderItemsQuantities[product['id']]+1);
//                                           controller.increaseTotal(product['unitPrice']);
//
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               )
//                           ),
//
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         '(${product['unitPrice']}) x${controller.orderItemsQuantities[product['id']]}  =${product['unitPrice']*controller.orderItemsQuantities[product['id']]}',
//                         // '($price)',
//                         style: TextStyle(
//                             fontSize: 14,
//                             // fontWeight: FontWeight.bold,
//                             color: Others.priceColor
//                         ),
//                       )
//
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//
//                     InkWell(
//                       onTap: (){},
//                       child: const Icon(
//                         // Icons.delete_forever_outlined,
//                         // color: Colors.red,
//                         Icons.close,
//                         color: Colors.grey,
//                         size: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   }
//   int selectedMenuIndex=0;
//   int hoveredCategoryIndex=-1;
//   Widget _categoryCard(
//       {required String title,required int index,required String id}) {
//     return InkWell(
//       onTap: (){
//         setState(() {
//           selectedMenuIndex=index;
//           selectedCategoryId=id;
//         });
//         getAllProductsFromBack();
//       },
//       // onHover: (val){
//       //   if(val) {
//       //     hoveredCategoryIndex=index;
//       //   }else{
//       //     hoveredCategoryIndex=-1;
//       //   }
//       // },
//       child: Container(
//         margin: const EdgeInsets.only(right: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 25),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           // color: const Color(0xff1f2029),
//           border:  selectedMenuIndex==index
//               ? Border.all(color: Primary.primary, width: 1)
//               : hoveredCategoryIndex==index?
//           Border.all(color: Colors.white, width: 1)
//               : Border.all(color: Colors.grey.withAlpha((0.2 * 255).toInt()), width: 1),
//           color:  selectedMenuIndex==index
//               ?  Primary.primary
//               : hoveredCategoryIndex==index
//               ?  Primary.primary.withAlpha((0.2 * 255).toInt())
//               :  Colors.white,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image.asset(
//             //   icon,
//             //   width: 38,
//             // ),
//             Icon(Icons.category,
//               color: selectedMenuIndex==index?Colors.white: hoveredCategoryIndex==index
//                   ?  Colors.white:Others.priceColor,size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 13,
//                 color:selectedMenuIndex==index?Colors.white : hoveredCategoryIndex==index
//                     ?  Colors.white:Others.priceColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   int seconds=0,minutes=0,hours=0;
//   String digitSeconds='00',digitMinutes='00',digitHours='00';
//   Timer? timer;
//   bool started=false;
//   List laps=[];
//
//   void stop(){
//     timer!.cancel();
//     setState(() {
//       started=false;
//     });
//   }
//
//   void reset(){
//     timer!.cancel();
//     setState(() {
//       seconds=0;minutes=0;hours=0;
//       digitSeconds='00';digitMinutes='00';digitHours='00';
//       started=false;
//     });
//   }
//
//   void addLaps(){
//     String lap='$digitHours:$digitMinutes:$digitSeconds';
//     setState(() {
//       laps.add(lap);
//     });
//   }
//
//   void start(){
//     started=true;
//     timer=Timer.periodic(const Duration(seconds: 1), (timer) {
//       int localSecond=seconds+1;
//       int localMinutes=minutes;
//       int localHours=hours;
//
//       if(localSecond>59){
//         if(localMinutes>59){
//           localHours++;
//           localMinutes=0;
//         }else{
//           localMinutes++;
//           localSecond=0;
//         }
//       }
//       setState(() {
//         seconds=localSecond;
//         minutes=localMinutes;
//         hours=localHours;
//         digitSeconds=(seconds>=10)?'$seconds':'0$seconds';
//         digitHours=(hours>=10)?'$hours':'0$hours';
//         digitMinutes=(minutes>=10)?'$minutes':'0$minutes';
//       });
//     });
//   }
//
//
//
//   Widget _shiftShow(){
//     return Container(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Row(
//         children: [
//           const Text('ruba ram is in',style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),),
//           gapW32,
//           Text('start shift at $shiftStart'),
//           gapW32,
//           Text('$digitHours:$digitMinutes:$digitSeconds')
//         ],
//       ),
//     );
//   }
//
//   Widget _topMenu({
//     required String title,
//     required String subTitle,
//     required Widget action,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 28.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 subTitle,
//                 style: TextStyle(
//                   color: TypographyColor.titleTable,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//           Expanded(flex: 1, child: Container(width: double.infinity)),
//           // Expanded(flex: 4, child: action),
//         ],
//       ),
//     );
//   }
//
//   Widget _search() {
//     return InkWell(
//       onTap: (){
//         showDialog<String>(
//             context: context,
//             builder: (BuildContext context) => const AlertDialog(
//               backgroundColor: Colors.white,
//               contentPadding: EdgeInsets.all(0),
//               titlePadding: EdgeInsets.all(0),
//               actionsPadding: EdgeInsets.all(0),
//               shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.all(Radius.circular(9)),
//               ),
//               elevation: 0,
//               content: SearchDialogContent(),
//             ));
//       },
//       child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           width: double.infinity,
//           height: 40,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(color: Colors.grey)
//             // color: const Color(0xff1f2029),
//           ),
//           child: const Row(
//             children: [
//               Icon(
//                   Icons.search,
//                   color: Colors.grey
//               ),
//               SizedBox(width: 10),
//               Text(
//                 'Search menu here...',
//                 style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 11),
//               )
//             ],
//           )),
//     );
//   }
//
//
//
// }
//
//
// class ItemCard extends StatefulWidget {
//   const ItemCard({super.key, required this.product, required this.index});
//   final Map product;
//   final int index;
//   final int quantity=40;
//   @override
//   State<ItemCard> createState() => ItemCardState();
// }
//
// class ItemCardState extends State<ItemCard> {
//   bool isClicked=false;
//   int counter = 1;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductController>(
//         builder: (controller) {
//           return InkWell(
//             onTap: (){
//               isClicked=true;
//               //todo
//               controller.addToOrder(widget.product);
//               // if (controller.orderItemsQuantities[widget.product['id']] <widget.quantity) {
//               //      controller.addToOrderItemsQuantities(widget.product['id'], controller.orderItemsQuantities[widget.product['id']]+1);
//               //      controller.increaseTotal(widget.product['unitPrice']);
//               // }
//               controller.addToOrderItemsQuantities(widget.product['id'], 1);
//               controller.increaseTotal(widget.product['unitPrice']);
//             },
//             child: Container(
//               margin: const EdgeInsets.only(right: 20, bottom: 20),
//               padding:  EdgeInsets.symmetric(horizontal:  Sizes.deviceWidth*0.01,vertical: Sizes.deviceHeight*0.015),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(18),
//                   color: Colors.white,
//                   border: Border.all(color:isClicked ? Primary.primary: Colors.grey.withAlpha((0.2 * 255).toInt()))
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius
//                         .all(Radius.circular(12)),
//                     child: CachedNetworkImage(
//                       imageUrl:'${widget.product['images']}' =='[]'
//                           ? 'http://rooster.williamtouma.com/roosterV2/backend/public/storage/WhatsApp%20Image%202024-03-03%20at%2011.41.15%20AM.jpeg'
//                           :'${widget.product['images'][0]}',
//                       height:  Sizes.deviceHeight*0.28,
//                       width: Sizes.deviceWidth*0.3,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => loading(),
//                       errorWidget: (context, url, error) => loading(),
//                     ),
//                   ),
//                   // gapH16,
//                   Row(
//                     children: [
//                       gapW6,
//                       Text(
//                         '${widget.product['item_name'] ?? ''} ',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                       Text(
//                         ' ( ${widget.product['unitPrice'] ?? ''}${widget.product['currency'] != null ? '${widget.product['currency']['symbol'] ?? ''}' : ''} )',
//                         style:   TextStyle(
//                           color: Others.priceColor,//Primary.primary,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                   ),
//                   // gapH16,
//
//                 ],
//               ),
//             ),
//           );
//         }
//     );
//   }
// }
//
