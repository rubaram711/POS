import 'package:shared_preferences/shared_preferences.dart';

import '../Models/role_model.dart';

saveUserInfoLocally(String accessToken,String id, String email,String name,String companyName,String companyId,String warehouseId,String posTerminalId,String posTerminalName
,String isItGarage,
    ) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', accessToken);
  prefs.setString('identifier1', id);
  prefs.setString('email', email);
  prefs.setString('name', name);
  prefs.setString('companyName', companyName);
  prefs.setString('companyId', companyId);
  prefs.setString('warehouseID', warehouseId);
  prefs.setString('posTerminalID', posTerminalId);
  prefs.setString('posTerminalName', posTerminalName);
  prefs.setString('isItGarage', isItGarage);
}

savePosTerminalIdInfoLocally(String posTerminalId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('posTerminalID', posTerminalId);
}

Future<Map> getUserInfoFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString('accessToken') ?? '';
  String id = prefs.getString('identifier1') ?? '';
  String email = prefs.getString('email') ?? '';
  String name = prefs.getString('name') ?? '';
  String companyName = prefs.getString('companyName') ?? '';
  String companyId = prefs.getString('companyId') ?? '';
  String warehouseId = prefs.getString('warehouseID') ?? '';
  String posTerminalId = prefs.getString('posTerminalID') ?? '';
  String posTerminalName = prefs.getString('posTerminalName') ?? '';
  String isItGarage = prefs.getString('isItGarage') ?? '0';
  return {
    'accessToken': accessToken,
    'identifier1':id,
    'email': email,
    'name': name,
    'companyName': companyName,
    'companyId': companyId,
    'warehouseID': warehouseId,
    'posTerminalID': posTerminalId,
    'posTerminalName': posTerminalName,
    'isItGarage': isItGarage,
  };
}

Future<String> getAccessTokenFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString('accessToken') ?? '';
  return accessToken;
}

Future<String> getPosTerminalIdFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String posTerminalId = prefs.getString('posTerminalID') ?? '';
  return posTerminalId;
}

Future<String> getPosTerminalNameFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String posTerminalName = prefs.getString('posTerminalName') ?? '';
  return posTerminalName;
}

Future<String> getWarehouseIdFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String warehouseId = prefs.getString('warehouseID') ?? '';
  return warehouseId;
}

Future<String> getEmailFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? '';
  return email;
}

Future<String> getNameFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String nike = prefs.getString('name') ?? '';
  return nike;
}


Future<String> getIdFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('identifier1') ?? '';
  return id;
}

Future<String> getCompanyNameFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String companyName = prefs.getString('companyName') ?? '';
  return companyName;
}

Future<String> getCompanyIdFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String companyId = prefs.getString('companyId') ?? '';
  return companyId;
}



saveRoleIdInfoLocally(String roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('roleId', roleId);
}
Future<String> getRoleIdFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String roleId = prefs.getString('roleId') ?? '';
  return roleId;
}

saveRoleNameInfoLocally(String roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('roleName', roleId);
}
Future<String> getRoleNameFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String roleId = prefs.getString('roleName') ?? '';
  return roleId;
}



saveRolesLocally(List<Role> roles)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = Role.encode(roles);
    await prefs.setString('roles', encodedData);
}


Future<List<Role>> getRolesFromPref()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String rolesString = prefs.getString('roles') ?? '';
  final List<Role> roles = Role.decode(rolesString);
  return roles;
}


saveIsAllowedToSellZeroLocally(bool isAllowedToSellZero)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAllowedToSellZero', isAllowedToSellZero);
}


Future<bool> getIsAllowedToSellZeroFromPref()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isAllowedToSellZero = prefs.getBool('isAllowedToSellZero') ?? false;
  return isAllowedToSellZero;
}

saveCantSellZeroMessageLocally(String cantSellZeroMessage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('cantSellZeroMessage', cantSellZeroMessage);
}
Future<String> getCantSellZeroMessageFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cantSellZeroMessage = prefs.getString('cantSellZeroMessage') ?? '';
  return cantSellZeroMessage;
}

Future<String> getIsItGarageFromPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String isItGarage = prefs.getString('isItGarage') ?? '0';
  return isItGarage;
}
// Future<String> getCostCalculationTypeFromPref() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String costCalculationType = prefs.getString('costCalculationType') ?? '';
//   return costCalculationType;
// }
//
// Future<String> getShowQuantitiesOnPosFromPref() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String showQuantitiesOnPos = prefs.getString('showQuantitiesOnPos') ?? '';
//   return showQuantitiesOnPos;
// }

// saveCompanySettingsLocally(String costCalculationType,String showQuantitiesOnPos) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('costCalculationType', costCalculationType);
//   prefs.setString('showQuantitiesOnPos', showQuantitiesOnPos);
// }




savePosIdInfoLocally(String roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('posTerminalID', roleId);
}


savePosNameInfoLocally(String roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('posTerminalName', roleId);
}

saveWarehouseIdInfoLocally(String roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('warehouseID', roleId);
}
