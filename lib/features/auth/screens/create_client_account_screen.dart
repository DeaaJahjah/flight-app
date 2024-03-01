import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flight_booking_concept_ui/core/constents/constents.dart';
import 'package:flight_booking_concept_ui/core/enums/enums.dart';
import 'package:flight_booking_concept_ui/core/widgets/custom_progress.dart';
import 'package:flight_booking_concept_ui/core/widgets/custom_snackbar.dart';
import 'package:flight_booking_concept_ui/core/widgets/filled_button.dart';
import 'package:flight_booking_concept_ui/features/auth/models/client.dart';
import 'package:flight_booking_concept_ui/features/auth/services/authentecation_service.dart';
import 'package:flight_booking_concept_ui/features/auth/services/file_services.dart';
import 'package:flight_booking_concept_ui/features/auth/services/user_db_services.dart';
import 'package:flight_booking_concept_ui/main_pages/home_page.dart';
import 'package:flight_booking_concept_ui/utils/r.dart';
import 'package:flight_booking_concept_ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class CreateClientAccountScreen extends StatefulWidget {
  static const routeName = '/create-client-account';
  const CreateClientAccountScreen({super.key});

  @override
  State<CreateClientAccountScreen> createState() => _CreateClientAccountScreenState();
}

class _CreateClientAccountScreenState extends State<CreateClientAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? birthday;
  String? imageName;
  File? imageFile;
  FilePickerResult? pickedFile;
  Uint8List? logoBase64;

  bool isLoading = false;

  void chooseImage() async {
    pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      try {
        setState(() {
          logoBase64 = pickedFile!.files.first.bytes;
          imageName = pickedFile!.files.first.name;
        });
      } catch (err) {
        print(err);
      }
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.primaryColor,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('انشاء حساب زبون', style: Theme.of(context).textTheme.headlineLarge),
              sizedBoxLarge,
              InkWell(
                onTap: () async {
                  try {
                    chooseImage();
                    setState(() {});
                  } catch (e) {}
                },
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: (logoBase64 == null)
                        ? Image.asset("assets/images/pick_image.png", scale: 1.2)
                        : CircleAvatar(radius: 70, backgroundImage: MemoryImage(logoBase64!))),
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
                            controller: _fullNameController,
                            prefixIcon: Icon(Icons.person, color: R.secondaryColor),
                            mainColor: R.secondaryColor,
                            secondaryColor: R.tertiaryColor,
                            keyboardType: TextInputType.text),
                        sizedBoxMedium,
                        CustomTextField(
                            labelText: 'تاريخ الميلاد',
                            prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                            mainColor: R.secondaryColor,
                            secondaryColor: R.tertiaryColor,
                            controller: _ageController,
                            onTap: () async {
                              birthday = await showRoundedDatePicker(
                                context: context,
                                lastDate: DateTime.now(),
                                initialDate: DateTime(1960),
                                // firstDate: DateTime(2000),
                                theme: ThemeData(primarySwatch: Colors.pink),
                              );
                              _ageController.text =
                                  ('${birthday!.year}-${birthday!.month}-${birthday!.day}').toString();
                            },
                            readOnly: true,
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
                            keyboardType: TextInputType.phone)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
                  child: !isLoading
                      ? CustomFilledButton(
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
                            if (logoBase64 != null) {
                              imageUrl = await FileDbService().uploadeimage(imageName!, imageFile!, context);
                            }

                            if (imageUrl == 'error') {
                              showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                            var client = Client(
                                id: '',
                                name: _fullNameController.text,
                                phone: _phoneController.text,
                                birthday: birthday!,
                                userType: UserType.client,
                                imageUrl: imageUrl);
                            if (mounted) {
                              var user = await FlutterFireAuthServices().signUp(
                                  email: _emailController.text, password: _passwordController.text, context: context);

                              if (user == null) {
                                showErrorSnackBar(context, 'حدث خطأ عند انشاء الحساب');
                                setState(() {
                                  isLoading = false;
                                });

                                return;
                              } else {
                                await UserDbServices().creatUser(client: client, context: context);

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
                              }
                            }
                          },
                          text: 'موافق')
                      : const CustomProgress()),
            ],
          ),
        ],
      ),
    );
  }
}
