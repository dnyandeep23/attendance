import 'dart:io';

import 'package:attedance/Pages/profile.dart';
import 'package:attedance/Utils/otpverify.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Editprofile extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String username;
  final bool isteach;
  final String uname;
  static String verify = '';

  const Editprofile(
      {Key? key,
      required this.screenWidth,
      required this.screenHeight,
      required this.username,
      required this.isteach,
      required this.uname})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditprofileState createState() => _EditprofileState(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      username: username,
      isteach: isteach,
      uname: uname);
}

class _EditprofileState extends State<Editprofile> {
  final double screenHeight;
  final double screenWidth;
  File? _pickedFile;
  bool filepicked = false;
  final String username;
  final bool isteach;
  final String uname;
  String imageUrl = '';
  _EditprofileState(
      {required this.screenWidth,
      required this.screenHeight,
      required this.username,
      required this.isteach,
      required this.uname});
  String selectedButton = '';
  final GlobalKey<FormState> name = GlobalKey<FormState>();
  final GlobalKey<FormState> _studentid = GlobalKey<FormState>();
  final GlobalKey<FormState> _insti = GlobalKey<FormState>();
  final GlobalKey<FormState> _mail = GlobalKey<FormState>();
  final GlobalKey<FormState> _mob = GlobalKey<FormState>();
  final GlobalKey<FormState> _pass = GlobalKey<FormState>();
  final GlobalKey<FormState> mail = GlobalKey<FormState>();
  final GlobalKey<FormState> mobile = GlobalKey<FormState>();
  final GlobalKey<FormState> password = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confpass = TextEditingController();
  final TextEditingController inst = TextEditingController();
  void selectButton(String button) {
    setState(() {
      selectedButton = button;
    });
  }

  Widget _buildForm() {
    if (selectedButton == 'Name') {
      return buildName();
    } else if (selectedButton == 'Student ID') {
      return buildStudentId();
    } else if (selectedButton == 'Mail') {
      return buildEmail();
    } else if (selectedButton == 'Institute') {
      return buildInstitute();
    } else if (selectedButton == 'Mobile') {
      return buildMobile();
    } else if (selectedButton == 'Password') {
      return buildPassword();
    } else if (selectedButton == 'Image') {
      return buildImage();
    }

    return Container(
      height: screenHeight * 0.5,
    );
  }

  Widget buildName() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: name,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: firstName,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "First Name is required";
                  } else if (value.length < 2) {
                    return "First Name is too short";
                  } else if (value.length > 50) {
                    return "First Name is too long";
                  } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                    return "First Name can only contain letters";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: lastName,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Last Name is required";
                  } else if (value.length < 2) {
                    return "Last Name is too short";
                  } else if (value.length > 50) {
                    return "Last Name is too long";
                  } else if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                    return "Last Name can only contain letters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updateName();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updateName() {
    if (name.currentState!.validate()) {
      String fname = firstName.text.toUpperCase();
      String lname = lastName.text.toUpperCase();
      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'firstName': fname, 'lastName': lname});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'firstName': fname, 'lastName': lname});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      }
    }
  }

  Widget buildStudentId() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _studentid,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: id,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Student ID',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Student ID is required";
                  } else if (value.length >= 10) {
                    return "Student ID must be exactly 10 characters long";
                  } else if (!RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(value)) {
                    return "Student ID can only contain letters and numbers";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updateId();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updateId() {
    if (_studentid.currentState!.validate()) {
      String idT = id.text.toUpperCase();

      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'userName': idT});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'studentId': idT});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      }
    }
  }

  Widget buildEmail() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _mail,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[a-zA-Z ]{2,})+$')
                      .hasMatch(value)) {
                    return "Please enter a valid email address";
                  } else if (value.length > 100) {
                    return "Email cannot be longer than 100 characters";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updateMail();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updateMail() {
    if (_mail.currentState!.validate()) {
      String emailId = email.text;
      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'Email': emailId});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'Email': emailId});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      }
    }
  }

  Widget buildInstitute() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _insti,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                controller: inst,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Institute',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "institute name is required";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updateInstitute();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updateInstitute() {
    if (_insti.currentState!.validate()) {
      String insti = inst.text.toUpperCase();
      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'Institute Name': insti});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'instituteName': insti});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      }
    }
  }

  Widget buildMobile() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _mob,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phone,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelText: 'Mobile No',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mobile Number is required';
                  }

                  return null;
                },
                onSaved: (value) {},
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () async {
                    updateMobile();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updateMobile() {
    if (_mob.currentState!.validate()) {
      String mob = phone.text.trim();

      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$mob',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Editprofile.verify = verificationId;
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OTPverify(
                username: username, isteach: isteach, name: uname, phone: mob),
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Widget buildPassword() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _pass,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: pass,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  } else if (value.length < 8) {
                    return "Password must be at least 8 characters long";
                  } else if (!RegExp(r'^(?=.*[a-z ])').hasMatch(value)) {
                    return "Password must contain at least one lowercase letter";
                  } else if (!RegExp(r'^(?=.*[A-Z ])').hasMatch(value)) {
                    return "Password must contain at least one uppercase letter";
                  } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                    return "Password must contain at least one digit";
                  } else if (!RegExp(r'^(?=.*[@#$%^&+= ])').hasMatch(value)) {
                    return "Password must contain at least one special character";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: confpass,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 253, 253, 253)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    fillColor: Colors.black26,
                    counterStyle: TextStyle(color: Colors.white)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm Password is required";
                  } else if (value != confpass.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updatePassword();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  void updatePassword() {
    if (_pass.currentState!.validate()) {
      String password = pass.text;
      if (isteach == true) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('teacher');
        ref.child(username).update({'Password': password});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      } else {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child('student');
        ref.child(username).update({'Password': password});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Profile(
            username: username,
            isteach: isteach,
            show_update: false,
          ),
        ));
      }
    }
  }

  Widget buildImage() {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color.fromARGB(200, 113, 112, 112),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              InkWell(
                onTap: () {
                  !filepicked ? _pickImage() : null;
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: Colors.white,
                    radius: const Radius.circular(20),
                    strokeWidth: 2,
                    dashPattern: const [8, 2, 8, 2],
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth * 0.88,
                      height: screenHeight * 0.2,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(50, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          filepicked
                              ? Icon(
                                  CupertinoIcons.checkmark_circle_fill,
                                  color: Colors.white,
                                  size: screenWidth * 0.1,
                                )
                              : Icon(
                                  CupertinoIcons.photo_fill,
                                  color: Colors.white,
                                  size: screenWidth * 0.1,
                                ),
                          SizedBox(
                            width: screenWidth * 0.03,
                          ),
                          filepicked
                              ? Text(
                                  "${_pickedFile!.path.split('/').last}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "Upload Image",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(20, 255, 255, 255)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.white, width: 1))),
                  onPressed: () {
                    updateImage();
                  },
                  child: Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  Future<void> _pickImage() async {
    print("Entered");
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedFile = File(pickedFile.path);
        filepicked = true;
      } else {
        filepicked = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected.'),
          ),
        );
      }
    });
  }

  void updateImage() async {
    if (filepicked == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image selected.'),
        ),
      );
    } else {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
          storage.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = storageReference.putFile(_pickedFile!);

      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
        // Now, store the URL in Firebase Realtime Database
        if (isteach == true) {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref().child('teacher');
          ref.child(username).update({'image': imageUrl});
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Profile(
              username: username,
              isteach: isteach,
              show_update: false,
            ),
          ));
        } else {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref().child('student');
          ref.child(username).update({'image': imageUrl});
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Profile(
              username: username,
              isteach: isteach,
              show_update: false,
            ),
          ));
        }
      });
    }
    // if (_pass.currentState!.validate()) {
    //   String password = pass.text;
    //   if (isteach == true) {
    //     DatabaseReference ref =
    //         FirebaseDatabase.instance.ref().child('teacher');
    //     ref.child(username).update({'Password': password});
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => Profile(
    //         username: username,
    //         isteach: isteach,
    //         show_update: false,
    //       ),
    //     ));
    //   } else {
    //     DatabaseReference ref =
    //         FirebaseDatabase.instance.ref().child('student');
    //     ref.child(username).update({'Password': password});
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => Profile(
    //         username: username,
    //         isteach: isteach,
    //         show_update: false,
    //       ),
    //     ));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(240, 46, 45, 45),
            ),
            child: Stack(children: [
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Text(
                    "UPDATE INFORMATION",
                    style: TextStyle(
                        fontFamily: 'postnobillbold',
                        color: Colors.white,
                        fontSize: screenHeight * 0.04),
                  ),
                  Divider(),
                  RadioListTile<String>(
                    title: Text(
                      'Name',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Name',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Student ID',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Student ID',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Institute',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Institute',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Mail',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Mail',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Mobile',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Mobile',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Password',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Profile Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: 'Image',
                    groupValue: selectedButton,
                    onChanged: (value) => selectButton(value!),
                  ),
                  _buildForm()
                ],
              ),
              Positioned(
                right: screenWidth * 0.02,
                top: screenHeight * 0.01,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Profile(
                        username: username,
                        isteach: isteach,
                        show_update: false,
                      ),
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.08,
                    height: screenWidth * 0.08,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey),
                    child: Icon(
                      CupertinoIcons.clear_thick_circled,
                      size: screenHeight * 0.03,
                      color: Color.fromARGB(255, 49, 48, 48),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
