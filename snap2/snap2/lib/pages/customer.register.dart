import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snap2/pages/shop.register.dart';
import 'package:velocity_x/velocity_x.dart';
//import 'applogo.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

import 'dart:developer' as dev;

class CRegistration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<CRegistration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();

  bool _isNotValidate = false;

  void registerUser() async {
    dev.log("email > " + emailController.text.toString());
    dev.log("password > " + passwordController.text.toString());

    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        longitudeController.text.isNotEmpty &&
        latitudeController.text.isNotEmpty 


        ) {

        var regBody = {
          "email": emailController.text,
          "password": passwordController.text
        };

        var shopBody = {
          "Name": nameController.text,          
          "address": addressController.text,
          "phoneNumber": phoneNumberController.text,
          "longitude": longitudeController.text,
          "latitude": latitudeController.text,
          "userName": emailController.text,
        };


      dev.log(Uri.parse(registration).toString());  
      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var shopResponse = await http.post(Uri.parse(addShop),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(shopBody));


      dev.log("request for registration sent successfully");

      var jsonResponse = jsonDecode(response.body);
      var jsonShopResponse = jsonDecode(shopResponse.body);
      dev.log("response body > " + jsonResponse.toString());

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      } else {
        print("SomeThing Went Wrong");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Customer Registration'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //owner name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Name',
                  errorText: _isNotValidate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
             
              
              // address
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter Address',
                  errorText: _isNotValidate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              // phone number
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter Phone Number',
                  errorText: _isNotValidate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              // username
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter Email',
                  errorText: _isNotValidate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              // password
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  errorText: _isNotValidate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              // map icon to take current location
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: longitudeController,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        hintText: 'Enter Longitude',
                        errorText:
                            _isNotValidate ? 'Value Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: latitudeController,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        hintText: 'Enter Latitude',
                        errorText:
                            _isNotValidate ? 'Value Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                ],
              ),



              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInPage()))
              }, // Handle login functionality
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => Registration()))
              }, // Handle sign in as customer functionality
              child: Text('Sign in as Customer'),
            ),
          ],
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
