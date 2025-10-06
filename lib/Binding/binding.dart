import 'package:get/get.dart';
import 'package:pos_project/Controllers/client_controller.dart';

import '../Controllers/cash_trays_controller.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/orders_controller.dart';
import '../Controllers/payment_controller.dart';
import '../Controllers/pos_controller.dart';
import '../Controllers/products_controller.dart';
import '../Controllers/role_controller.dart';
import '../Controllers/session_controller.dart';
import '../Controllers/transfer_controller.dart';
import '../Controllers/warehouse_controller.dart';



class MyBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LanguagesController>(() => LanguagesController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<TransferController>(() => TransferController());
    Get.lazyPut<WarehouseController>(() => WarehouseController());
    // Get.lazyPut<ExchangeRatesController>(() => ExchangeRatesController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PaymentController>(() => PaymentController());
    Get.lazyPut<SessionController>(() => SessionController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<CashTraysController>(() => CashTraysController());
    Get.lazyPut<RoleController>(() => RoleController());
    Get.lazyPut<PossController>(() => PossController());
    Get.lazyPut<ClientController>(() => ClientController());
  }
}