import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/auth/login_view.dart';

class SharedPreferenceController {
  final String _onBoardingKey = '/onBoarding';
  SharedPreferences? _prefs;
  SharedPreferenceController._internal();
  static final SharedPreferenceController _instance =
      SharedPreferenceController._internal();

  factory SharedPreferenceController() {
    return _instance;
  }
  Future<void> _checkInstance() async {
    if (_prefs == null) {
      await init();
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool?> setToken(String token) async {
    await _checkInstance();
    return await _prefs?.setString('token', token);
  }

  Future<bool?> setData(String key, dynamic data) async {
    await _checkInstance();
    switch (data.runtimeType) {
      case int:
        return _prefs?.setInt(key, data);
      case String:
        return _prefs?.setString(key, data);
      case bool:
        return _prefs?.setBool(key, data);
    }
    return null;
  }

  dynamic getData(String key) async {
    await _checkInstance();
    return await _prefs?.get(key);
  }

  Future<bool>? shouldShowOnBoarding() async {
    await _checkInstance();
    bool onBoardingShow = _prefs?.getBool(_onBoardingKey) ?? false;
    return onBoardingShow;
  }

  Future<bool>? setOnBoarding() async {
    await _checkInstance();
    Future<bool>? onBoardingShow = _prefs?.setBool(_onBoardingKey, true);
    return onBoardingShow!;
  }

  //  Future<bool> saveLoginData(UserSignInModel user) async{
  //    await _checkInstance();
  // try{
  //   await  _prefs?.setString('token', ${user.token});
  //   await  _prefs?.setString('id', user.id);
  //   return true;
  // }catch(e){
  //     return false;
  //   }
  //
  //
  //  }
  //  Future<bool> saveSingUp(UserSignUpModel user) async{
  //    await _checkInstance();
  // try{
  //   await  _prefs?.setString('token','Bearer ${user.token}');
  //   await  _prefs?.setString('id',user.id );
  //   return true;
  // }catch(e){
  //     return false;
  //   }
  //
  //
  //  }
  void logout(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      Navigator.pushReplacementNamed(context, LoginView.id);
    });
  }

  Future<T?> getValueFor<T>(String key) async {
    await _checkInstance();
    if (_prefs!.containsKey(key)) {
      return _prefs!.getKeys() as T;
    }
    return null;
  }

  Future<bool> clear() async {
    await _checkInstance();
    return _prefs!.clear();
  }
}
