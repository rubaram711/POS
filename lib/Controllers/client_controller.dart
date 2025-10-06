import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Backend/ClientsBackend/get_clients.dart';
import '../../Screens/Clients/customers_dialog.dart';
import '../Backend/get_sales_persons.dart';

class ClientController extends GetxController {
  Map selectedCustomerCar = {};
  List<String> customersNamesList = [];
  List customersIdsList = [];
  bool isClientsFetched = false;
  List customersList = [];
  String selectedCustomerId = '-1';
  String selectedCustomerIdWithOk = '-1';
  Map selectedCustomerObject = {};

  getAllClientsFromBack() async {
    customersList = [];
    customersNamesList = [];
    customersIdsList = [];
    isClientsFetched = false;
    var p = await getAllClients(searchInCustomersController.text);
    customersList = p;
    for (var c in p) {
      customersNamesList.add(c['name']);
      customersIdsList.add('${c['id']}');
    }
    isClientsFetched = true;
    update();
  }

  setSelectedCustomerId(String newValue) {
    selectedCustomerId = newValue;
    update();
  }

  setSelectedCustomerIdWithOk() {
    selectedCustomerIdWithOk = selectedCustomerId;
    update();
  }

  setSelectedCustomerObject(Map newVal) {
    selectedCustomerObject = newVal;
    // productController.setTotalDiscountAsPercent(double.parse('${newVal['grantedDiscount']??newVal['granted_discount']??'0'}'));
    // productController.calculateSummary();
    update();
  }

  resetAll() {
    selectedCustomerId = '-1';
    selectedCustomerIdWithOk = '-1';
    selectedCustomerObject = {};
    update();
  }

  setSelectedClientOrderInfo(Map order) {
    if (order['client']['client_number'] != 'CashCustomer') {
      selectedCustomerId = '${order['client']['id']}';
      selectedCustomerIdWithOk = '${order['client']['id']}';
      selectedCustomerObject = order['client'];
    }
  }

  //contacts and addresses
  List<Map> contactsList = [
    // {    'type':'1',
    //   'name':'',
    //   'title':'',
    //   'jobPosition':'',
    //   'deliveryAddress':'',
    //   'phoneCode':'',
    //   'phoneNumber':'',
    //   'extension':'',
    //   'mobileCode':'',
    //   'mobileNumber':'',
    //   'email':'',
    //   'note':'',
    //   'internalNote':'',}
  ];
  addToContactsList(Map newMap) {
    contactsList.add(newMap);
    update();
  }

  updateContactType(int index, String newVal) {
    contactsList[index]['type'] = newVal;
  }

  updateContactName(int index, String newVal) {
    contactsList[index]['name'] = newVal;
  }

  updateContactTitle(int index, String newVal) {
    contactsList[index]['title'] = newVal;
  }

  updateContactJobPosition(int index, String newVal) {
    contactsList[index]['jobPosition'] = newVal;
  }

  updateContactDeliveryAddress(int index, String newVal) {
    contactsList[index]['deliveryAddress'] = newVal;
  }

  updateContactPhoneCode(int index, String newVal) {
    contactsList[index]['phoneCode'] = newVal;
  }

  updateContactPhoneNumber(int index, String newVal) {
    contactsList[index]['phoneNumber'] = newVal;
  }

  updateContactExtension(int index, String newVal) {
    contactsList[index]['extension'] = newVal;
  }

  updateContactMobileCode(int index, String newVal) {
    contactsList[index]['mobileCode'] = newVal;
  }

  updateContactMobileNumber(int index, String newVal) {
    contactsList[index]['mobileNumber'] = newVal;
  }

  updateContactEmail(int index, String newVal) {
    contactsList[index]['email'] = newVal;
  }

  updateContactNote(int index, String newVal) {
    contactsList[index]['note'] = newVal;
  }

  updateContactInternalNote(int index, String newVal) {
    contactsList[index]['internalNote'] = newVal;
  }

  //sales person
  List salesPersonList = [];
  List<String> salesPersonListNames = [];
  List salesPersonListId = [];
  String salesPersonName = '';
  int salesPersonId = 0;
  String selectedSalesPerson = '';
  int selectedSalesPersonId = 0;
  TextEditingController salesPersonController = TextEditingController();

  getAllUsersSalesPersonFromBack() async {
    salesPersonList = [];
    salesPersonListNames = [];
    salesPersonName = '';
    salesPersonId = 0;
    update();
    var p = await getAllUsersSalesPerson();
    if ('$p' != '[]') {
      salesPersonList = p;
      for (var salesPerson in salesPersonList) {
        salesPersonName = salesPerson['name'];
        salesPersonId = salesPerson['id'];
        salesPersonListNames.add(salesPersonName);
        salesPersonListId.add(salesPersonId);
      }
      selectedSalesPerson = salesPersonListNames[0];
      selectedSalesPersonId = salesPersonListId[0];
      salesPersonController.text = salesPersonListNames[0];
    }
    update();
  }

  setSelectedSalesPerson(String name, int id) {
    selectedSalesPerson = name;
    selectedSalesPersonId = id;
    update();
  }

  //cars
  List carsListForSelectedCustomer = [
    {
      "odometer": '25000',
      "registration": "ABC123",
      "year": '2020',
      "color": "Red",
      "model": "Corolla",
      "brand": "Toyota",
      "chassis_no": "CH123456",
      "rating": '4.5',
      "comment": "Good condition",
      "car_fax": "Clean",
      'technician': 'ahmad',
    },
    {
      "odometer": '25000',
      "registration": "ABC123",
      "year": '2020',
      "color": "blue",
      "model": "Corolla",
      "brand": "Toyota",
      "chassis_no": "CH124444",
      "rating": '3',
      "comment": "Good condition",
      "car_fax": "Clean",
      'technician': 'ahmad',
    },
  ];
  setSelectedCustomerCarsList(List list) {
    carsListForSelectedCustomer = list;
    update();
  }

  setSelectedCustomerCar(Map val) {
    selectedCustomerCar = val;
    update();
  }

  List<Map> carsList = [
    //      'odometer': '',
    //       'registration': '',//unique
    //       'year': '',
    //       'color': '',
    //       'model': '',
    //       'brand': '',
    //       'chassis_no': '',//number
    //       'rating': '',
    //       'comment': '',
    //       'car_fax': '',
    //       'technician': '',
  ];

  addToCarsList(Map newMap) {
    carsList.add(newMap);
    update();
  }

  updateCarTechnician(int index, String newVal) {
    carsList[index]['technician'] = newVal;
  }

  updateCarOdometer(int index, String newVal) {
    carsList[index]['odometer'] = newVal;
  }

  updateCarRegistration(int index, String newVal) {
    carsList[index]['registration'] = newVal;
  }

  updateCarYear(int index, String newVal) {
    carsList[index]['year'] = newVal;
  }

  updateCarColor(int index, String newVal) {
    carsList[index]['color'] = newVal;
  }

  updateCarModel(int index, String newVal) {
    carsList[index]['model'] = newVal;
  }

  updateCarBrand(int index, String newVal) {
    carsList[index]['brand'] = newVal;
  }

  updateCarChassisNo(int index, String newVal) {
    carsList[index]['chassis_no'] = newVal;
  }

  updateCarRating(int index, String newVal) {
    carsList[index]['rating'] = newVal;
  }

  updateCarComment(int index, String newVal) {
    carsList[index]['comment'] = newVal;
  }

  updateCarFax(int index, String newVal) {
    carsList[index]['car_fax'] = newVal;
  }
}
