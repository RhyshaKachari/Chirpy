import 'package:chirpy/Backend/firebase/Auth/email_and_pwd_auth.dart';
import 'package:chirpy/Backend/firebase/Auth/google_auth.dart';
import 'package:chirpy/Global_Uses/reg_exp.dart';
import 'package:chirpy/frontend/auth_ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../Global_Uses/enum_generation.dart';
import '../NewUserEntry/new_user_entry.dart';
import '../MainScreens/home_page.dart';
import 'common_auth_methods.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpKey = GlobalKey();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _confirmPwd = TextEditingController();

  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(239, 46, 38, 78),
      body: LoadingOverlay(
        isLoading: this._isLoading,
        color: Colors.black,
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Text(
                  'Sign-Up',
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color.fromARGB(255, 239, 236, 236)),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.65,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
                child: Form(
                    key: this._signUpKey,
                    child: ListView(
                      children: [
                        commonTextFormField(
                            hintText: 'Email',
                            validator: (inputVal) {
                              if (!emailRegex.hasMatch(inputVal.toString())) {
                                return 'Email Format not Matching';
                                return null;
                              }
                            },
                            textEditingController: this._email),
                        commonTextFormField(
                            hintText: 'Password',
                            validator: (String? inputVal) {
                              if (inputVal!.length < 6) {
                                return 'Password must be at least 6 characters';
                                return null;
                              }
                            },
                            textEditingController: this._pwd),
                        commonTextFormField(
                            hintText: 'Confirm Password',
                            validator: (String? inputVal) {
                              if (inputVal!.length < 6) {
                                return 'Confirm Password Must be t least 6 characters';
                                if (this._pwd.text != this._confirmPwd.text) {
                                  return 'Password and Confirm Not Same Here';
                                }
                                return null;
                              }
                            },
                            textEditingController: this._confirmPwd),
                        signUpAuthButton(context, 'Sign-Up'),
                      ],
                    )),
              ),
              Center(
                  child: Text(
                'Or Continue With',
                style: TextStyle(color: Colors.white70, fontSize: 20.0),
              )),
              signUpSocialMediaIntegrationButtons(),
              switchAnotherAuthScreen(
                  context, "Already have an account? ", "Log-In"),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _commonTextFormField({required String hintText}) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.lightBlue,
              width: 2.0,
            ))),
      ),
    );
  }

  Widget signUpAuthButton(BuildContext, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width - 60, 30.0),
            elevation: 5.0,
            primary: Color.fromARGB(239, 46, 38, 78),
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            )),
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 25.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () async {
          if (this._signUpKey.currentState!.validate()) {
            print('Validated');
            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            final EmailSignUpResults response = await this
                ._emailAndPasswordAuth
                .signUpAuth(email: this._email.text, pwd: this._pwd.text);
            if (response == EmailSignUpResults.SignUpCompleted) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LogInScreen()));
            } else {
              final String msg =
                  response == EmailSignUpResults.EmailAlreadyPresent
                      ? 'Email Already Present'
                      : 'Sign Up Not Completed';
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));
            }
          } else {
            print('Not Validated');
          }
          if (mounted) {
            setState(() {
              this._isLoading = false;
            });
          }
        },
      ),
    );
  }

  Widget _socialMediaIntegrationButtons() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google.png',
            width: 50.0,
          ),
          SizedBox(
            width: 80.0,
          ),
          Image.asset(
            'assets/images/fbook.png',
            width: 50.0,
          ),
        ],
      ),
    );
  }

  Widget _switchToLogin() {
    return ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              "Log-In",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 16.0,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Color.fromARGB(239, 46, 38, 78),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LogInScreen()));
        });
  }

  Widget signUpSocialMediaIntegrationButtons() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              print('Google Pressed');
              if (mounted) {
                setState(() {
                  this._isLoading = true;
                });
              }
              final GoogleSignInResults _googleSignInResults =
                  await this._googleAuthentication.signInWithGoogle();
              String msg = '';

              if (_googleSignInResults == GoogleSignInResults.SignInCompleted) {
                msg = 'Sign In Completed';
              } else if (_googleSignInResults ==
                  GoogleSignInResults.SignInNotCompleted) {
                msg = 'Sign In not Completed';
              } else if (_googleSignInResults ==
                  GoogleSignInResults.AlreadySignedIn) {
                msg = 'Already Google SignedIn';
              } else {
                msg = 'Unexpected Error Happen';
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));

              if (_googleSignInResults == GoogleSignInResults.SignInCompleted)
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => TakePrimaryUserData()),
                    (route) => false);
              if (mounted) {
                setState(() {
                  this._isLoading = false;
                });
              }
            },
            child: Image.asset(
              'assets/images/google.png',
              width: 50.0,
            ),
          ),
          SizedBox(
            width: 80.0,
          ),
          GestureDetector(
            onTap: () {
              print('Facebook Pressed');
            },
            child: Image.asset(
              'assets/images/fbook.png',
              width: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
