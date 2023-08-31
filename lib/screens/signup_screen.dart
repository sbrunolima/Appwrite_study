import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

//Providers
import '../repository/auth_repository.dart';
import '../provider/appwrite_provider.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _form = GlobalKey<FormState>();
  AppWriteProvider appWriteProvider = AppWriteProvider();

  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;

  //UPLOAD the video
  void signup() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) return;

    _form.currentState!.save();
    print('name $name, email $email, passsword $password.');

    setState(() {
      isLoading = true;
    });

    try {
      await appWriteProvider.signup(
        {
          "userId": ID.unique(),
          "email": email,
          "password": password,
          "name": name,
        },
      ).then(
        (value) {
          setState(() {
            isLoading = false;
          });
        },
      );
    } catch (error) {
      print('ERRO => $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the device Size
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        'assets/logo.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                //Email
                const SizedBox(height: 40.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.toString().length > 0) {}
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com uma URL.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value.toString();
                  },
                ),
                //Name
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Name',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.toString().length > 0) {}
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com uma URL.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value.toString();
                  },
                ),
                //Password
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Password',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.toString().length > 0) {}
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com uma URL.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value.toString();
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 60,
                  width: mediaQuery.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      signup();
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : loadingText('Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
