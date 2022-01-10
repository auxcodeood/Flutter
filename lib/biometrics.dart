// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/firebase.dart';
import 'package:local_auth/local_auth.dart';

class Biometrics extends StatefulWidget {
  @override
  _BiometricsState createState() => _BiometricsState();
}

class _BiometricsState extends State<Biometrics> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then((isSupported) async => {
          setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
          if (await _authenticateWithBiometrics())
            {
              SyncUser("mv@auxcode.com").then(
                  (_) => {Navigator.pushReplacementNamed(context, '/home')})
            }
        });
  }

  Future<bool> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return false;
    }
    if (!mounted) return false;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    return true;
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Icon(Icons.fingerprint, size: 150),
    ));
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
