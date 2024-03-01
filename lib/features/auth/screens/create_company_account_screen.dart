import 'dart:io';

import 'package:flight_booking_concept_ui/core/constents/constents.dart';
import 'package:flight_booking_concept_ui/core/enums/enums.dart';
import 'package:flight_booking_concept_ui/core/widgets/custom_snackbar.dart';
import 'package:flight_booking_concept_ui/core/widgets/filled_button.dart';
import 'package:flight_booking_concept_ui/features/auth/models/company.dart';
import 'package:flight_booking_concept_ui/features/auth/services/authentecation_service.dart';
import 'package:flight_booking_concept_ui/features/auth/services/file_services.dart';
import 'package:flight_booking_concept_ui/features/auth/services/files_picker.dart';
import 'package:flight_booking_concept_ui/features/auth/services/user_db_services.dart';
import 'package:flight_booking_concept_ui/main_pages/home_page.dart';
import 'package:flight_booking_concept_ui/utils/r.dart';
import 'package:flight_booking_concept_ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class CreateCompanyAccountScreen extends StatefulWidget {
  static const routeName = '/create-company-account';
  const CreateCompanyAccountScreen({super.key});

  @override
  State<CreateCompanyAccountScreen> createState() => _CreateCompanyAccountScreenState();
}

class _CreateCompanyAccountScreenState extends State<CreateCompanyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? imageName;
  File? imageFile;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.primaryColor,
      body: ListView(
        children: [
          Container(
              // height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('انشاء حساب جديد', style: Theme.of(context).textTheme.headlineLarge),
                  sizedBoxLarge,
                  InkWell(
                    onTap: () async {
                      try {
                        imageFile = await FilesPicker().pickImage();
                        imageName = path.basename(imageFile!.path);
                        setState(() {});
                      } catch (e) {}
                    },
                    child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        child: (imageFile == null)
                            ? Image.asset("assets/images/pick_image.png", scale: 1.2)
                            : CircleAvatar(radius: 70, backgroundImage: FileImage(imageFile!))),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      // gradient: const LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     primaryColor,
                      //     secondaryColor,
                      //   ],
                      // ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            CustomTextField(
                                labelText: 'الاسم الكامل',
                                prefixIcon: Icon(Icons.person, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _fullNameController,
                                keyboardType: TextInputType.text),
                            sizedBoxMedium,
                            CustomTextField(
                                labelText: 'العنوان',
                                prefixIcon: Icon(Icons.location_city, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _addressController,
                                keyboardType: TextInputType.text),
                            sizedBoxMedium,
                            CustomTextField(
                                labelText: 'البريد الإلكتروني',
                                prefixIcon: Icon(Icons.email, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress),
                            sizedBoxMedium,
                            CustomTextField(
                                labelText: 'كلمة السر',
                                prefixIcon: Icon(Icons.lock, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword),
                            sizedBoxMedium,
                            CustomTextField(
                                labelText: 'رقم الهاتف',
                                prefixIcon: Icon(Icons.phone, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone),
                            CustomTextField(
                                labelText: 'وصف عن الشركة',
                                prefixIcon: Icon(Icons.description, color: R.secondaryColor),
                                mainColor: R.secondaryColor,
                                secondaryColor: R.tertiaryColor,
                                controller: _descriptionController,
                                keyboardType: TextInputType.text)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
                      child: CustomFilledButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();

                            String? imageUrl;

                            setState(() {
                              isLoading = true;
                            });
                            if (imageFile != null) {
                              imageUrl = await FileDbService().uploadeimage(imageName!, imageFile!, context);
                            }

                            if (imageUrl == 'error') {
                              showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            var company = Company(
                              id: '',
                              email: _emailController.text,
                              name: _fullNameController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                              description: _descriptionController.text,
                              imageUrl: imageUrl,
                              userType: UserType.company,
                            );

                            if (mounted) {
                              var user = await FlutterFireAuthServices().signUp(
                                  email: _emailController.text, password: _passwordController.text, context: context);

                              if (user == null) {
                                showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');

                                return;
                              } else {
                                await UserDbServices().createCompany(company: company, context: context);

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
                              }
                            }
                          },
                          text: 'موافق')),
                ],
              )),
        ],
      ),
    );
  }
}
