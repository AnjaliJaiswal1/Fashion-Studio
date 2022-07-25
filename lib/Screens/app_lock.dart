import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task1/Screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AppLock extends StatefulWidget {
  const AppLock({Key? key}) : super(key: key);

  @override
  State<AppLock> createState() => _AppLockState();
}

class _AppLockState extends State<AppLock> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckbiometrics;
  _SupportState _supportState = _SupportState.unknown;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isauthenticating = false;
  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState =
              isSupported ? _SupportState.supported : _SupportState.unsupported;
        }));
    _checkBiometrics();
    _getAvailableBiometrics();

    _authenticate();
    
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _canCheckbiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print(availableBiometrics);

      availableBiometrics.forEach((element) { 

        print(element == BiometricType.face);
      });
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }catch(error){
      print(error);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isauthenticating = true;
        _authorized = "Authenticating";
      });
      authenticated = await auth.authenticate(
          localizedReason: "Let OS determine authentication method",
          options: AuthenticationOptions(
              stickyAuth: true, useErrorDialogs: true, biometricOnly: false));
              
      if (authenticated)
        Get.off(SplashScreen());
      else
        SystemNavigator.pop();
      setState(() {
        _isauthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isauthenticating = false;
        _authorized = 'Erroe-${e.message}';
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isauthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isauthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isauthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() {
      _isauthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
          child: Container(
              height: 100,
              width: 100,
              child: Icon(
                Icons.fingerprint,
                size: 100,
              ))),
    ));
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
