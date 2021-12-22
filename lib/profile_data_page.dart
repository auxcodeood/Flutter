import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/firebase.dart';
import 'package:flutter_app/types/gender.dart';

class ProfileDataPage extends StatefulWidget {
  const ProfileDataPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileDataPageState();
  }
}

class ProfileDataPageState extends State<ProfileDataPage> {
  Map<String, dynamic> user = {};
  Gender _gender = Gender.Mr;
  bool _saved = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return TextFormField(
        readOnly: true,
        initialValue: user['email'],
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (String? value) {
          if (value != null && value.isEmpty) return 'Email is required';
        },
        onSaved: (String? value) {
          if (value != null) user['email'] = value;
        });
  }

  Widget _buildFirstName() {
    return TextFormField(
        initialValue: user['firstName'],
        decoration: const InputDecoration(labelText: 'First Name'),
        validator: (String? value) {
          if (value != null && value.isEmpty) return 'First Name is required';
        },
        onSaved: (String? value) {
          if (value != null) user['firstName'] = value;
        });
  }

  Widget _buildLastName() {
    return TextFormField(
        initialValue: user['lastName'],
        decoration: const InputDecoration(labelText: 'Last Name'),
        validator: (String? value) {
          if (value != null && value.isEmpty) return 'Last Name is required';
        },
        onSaved: (String? value) {
          if (value != null) user['lastName'] = value;
        });
  }

  Widget _buildGender() {
    return DropdownButtonFormField<Gender>(
        value: _gender,
        onSaved: (Gender? value) {
          if (value != null) user['gender'] = describeEnum(_gender);
        },
        onChanged: (Gender? value) {
          if (value != null) _gender = value;
        },
        items: Gender.values.map((Gender g) {
          return DropdownMenuItem<Gender>(
              value: g, child: Text(describeEnum(g)));
        }).toList());
    // decoration: const InputDecoration(labelText: 'Gender'));
  }

  Widget _buildBirthDate() {
    DateTime lastDate = DateTime.now().subtract(const Duration(days: 18 * 365));

    return InputDatePickerFormField(
        initialDate: (user['birthDate'] as Timestamp).toDate(),
        firstDate: DateTime(1900),
        lastDate: lastDate,
        errorFormatText: 'Invalid Birth Date format',
        errorInvalidText:
            'Invalid Birth Date range (you have to be atleast 18 years old)',
        onDateSaved: (DateTime val) {
          user['birthDate'] = Timestamp.fromDate(val);
        });
  }

  Widget _buildAddress() {
    return TextFormField(
        initialValue: user['address'],
        decoration: const InputDecoration(labelText: 'Address'),
        validator: (String? value) {
          if (value != null && value.isEmpty) return 'Address is required';
        },
        onSaved: (String? value) {
          if (value != null) user['address'] = value;
        });
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
        initialValue: user['phoneNumber'],
        decoration: const InputDecoration(labelText: 'Phone Number'),
        validator: (String? value) {
          if (value != null && value.isEmpty) {
            return 'Phone Number is required';
          } else if (!RegExp(r"[0-9]{1,10}").hasMatch(value!)) {
            return 'Phone number is invalid format';
          }
        },
        onSaved: (String? value) {
          if (value != null) user['phoneNumber'] = value;
        });
  }

  Future openDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('Saved'), actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    var future = getUser();

    return Scaffold(
        appBar: AppBar(title: const Text('Profile Data')),
        body: Container(
            margin: const EdgeInsets.all(15),
            child: FutureBuilder(
                future: future,
                builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData && !_saved) {
                    user = snapshot.data.data();
                    _gender = user['gender'] == "Mrs" ? Gender.Mrs : Gender.Mr;
                    children = <Widget>[
                      Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildEmail(),
                                _buildFirstName(),
                                _buildLastName(),
                                _buildGender(),
                                _buildBirthDate(),
                                _buildAddress(),
                                _buildPhoneNumber(),
                                const SizedBox(height: 100),
                                ElevatedButton(
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    _formKey.currentState!.save();
                                    await updateByEmail(user['email'], user);
                                    openDialog();
                                  },
                                )
                              ]))
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                })));
  }
}
