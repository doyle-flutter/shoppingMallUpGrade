import 'package:shared_preferences/shared_preferences.dart';

class LocalDB{

  SharedPreferences _prefsInstance;

  void init() async {
   _prefsInstance = await SharedPreferences.getInstance();
  }

  static const String NAME_KEY = "nameKey";
  static const String PHONE_KEY = "phoneKey";
  static const String ADDRESS_KEY = "addressKey";
  static const String ADDRESS2_KEY = "address2Key";

  //SET
  void saveUserName(String userName) {
    _prefsInstance.setString(NAME_KEY, userName);
  }
  void saveUserAddress(String userAddress) {
    _prefsInstance.setString(ADDRESS_KEY, userAddress);
  }
  void saveUserAddress2(String userAddress) {
    _prefsInstance.setString(ADDRESS2_KEY, userAddress);
  }
  void saveUserPhone(String userPhone) {
    _prefsInstance.setString(PHONE_KEY, userPhone);
  }

  //GET
  String getUserName(){
    return _prefsInstance.getString(NAME_KEY);
  }
  String getUserAddress(){
    return _prefsInstance.getString(ADDRESS_KEY);
  }
  String getUserAddress2(){
    return _prefsInstance.getString(ADDRESS2_KEY);
  }
  String getUserPhone(){
    return _prefsInstance.getString(PHONE_KEY);
  }

  //Func

  void removeAll(){
    _prefsInstance.clear();
  }

}