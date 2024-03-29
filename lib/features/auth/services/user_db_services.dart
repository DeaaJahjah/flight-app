import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flight_booking_concept_ui/core/enums/enums.dart';
import 'package:flight_booking_concept_ui/features/auth/models/client.dart';
import 'package:flight_booking_concept_ui/features/auth/models/company.dart';
import 'package:flight_booking_concept_ui/features/auth/providers/auth_state_provider.dart';
import 'package:flight_booking_concept_ui/main_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDbServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = auth.FirebaseAuth.instance.currentUser;

  creatUser({required Client client, required context}) async {
    try {
      await _db.collection('clients').doc(firebaseUser!.uid).set(client.toJson());

      await firebaseUser!.updateDisplayName('client');

      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } on FirebaseException catch (e) {
      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  createCompany({required Company company, required context}) async {
    try {
      await _db.collection('companies').doc(firebaseUser!.uid).set(company.toJson());

      await firebaseUser!.updateDisplayName('company');

      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } on FirebaseException catch (e) {
      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Future<UserModle?> getUser(String id) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     var user = await _db.collection('users').doc(id).get();
  //     String userType = user.data()!['user_type'];
  //     // SharedPref.set('type', userType);

  //     if (userType == UserType.benefactor.name) {
  //       sharedPreferences.setString('type', UserType.benefactor.name);

  //       return Benefactor.fromFirestore(user);
  //     }

  //     if (userType == UserType.patient.name) {
  //       final patient = Patient.fromFirestore(user);
  //       SharedPref.set('diseaseName', patient.disease!.name);
  //       sharedPreferences.setString('diseaseName', patient.disease!.name);
  //       sharedPreferences.setString('type', UserType.patient.name);

  //       return Patient.fromFirestore(user);
  //     }

  //     if (userType == UserType.charityOrg.name) {
  //       sharedPreferences.setString('type', UserType.charityOrg.name);

  //       return Charity.fromFirestore(user);
  //     }
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  //update user
  // Future<void> updateUser(UserModle user, context) async {
  //   try {
  //     await _db.collection('users').doc(firebaseUser!.uid).update(getUserType(user).toJson());
  //     await StreamChatService().updateUser(user, context);
  //     Provider.of<UserProvider>(context, listen: false).getUserData();
  //     showSuccessSnackBar(context, 'تم التعديل بنجاح');
  //     Navigator.of(context).pop(true);
  //   } on FirebaseException {
  //     showErrorSnackBar(context, 'حدث خطأ');
  //   }
  // }
}
