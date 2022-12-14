import 'package:chirpy/Backend/firebase/Auth/email_and_pwd_auth.dart';
import 'package:chirpy/Backend/firebase/Auth/google_auth.dart';
import 'package:chirpy/Global_Uses/reg_exp.dart';
import 'package:chirpy/frontend/NewUserEntry/new_user_entry.dart';
import 'package:chirpy/frontend/MainScreens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../Global_Uses/enum_generation.dart';
import 'common_auth_methods.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(239, 46, 38, 78),
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
                  'Log-In',
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color.fromARGB(255, 239, 236, 236)),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
                child: Form(
                    key: this._logInKey,
                    child: ListView(
                      children: [
                        commonTextFormField(
                            hintText: 'Email',
                            validator: (String? inputVal) {
                              if (!emailRegex.hasMatch(inputVal.toString())) {
                                return 'Email format is not matching';
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
                        logInAuthButton(context, 'Log-In'),
                      ],
                    )),
              ),
              Center(
                  child: Text(
                'Or Continue With',
                style: TextStyle(color: Colors.white70, fontSize: 20.0),
              )),
              logInSocialMediaIntegrationButtons(),
              switchAnotherAuthScreen(
                  context, "Don't Have an Account?", "Sign-Up"),
            ],
          ),
        ),
      ),
    ));
  }

  Widget logInAuthButton(BuildContext context, String buttonName) {
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
          if (this._logInKey.currentState!.validate()) {
            print('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }
            final EmailSignInResults emailSignInResults =
                await _emailAndPasswordAuth.signInWithEmailAndPassword(
                    email: this._email.text, pwd: this._pwd.text);
            String msg = '';
            if (emailSignInResults == EmailSignInResults.SignInCompleted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => TakePrimaryUserData()),
                  (route) => false);
            } else if (emailSignInResults ==
                EmailSignInResults.EmailNotVerified) {
              msg =
                  'Email not Verified. \nPlease Verify your email and then Log In';
            } else if (emailSignInResults ==
                EmailSignInResults.EmailOrPasswordInvalid) {
              msg = 'Email And Password Invalid';
            }
            if (msg != '') {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));
            }
            if (mounted) {
              setState(() {
                this._isLoading = false;
              });
            }
          } else {
            print('Not Validated');
          }
        },
      ),
    );
  }

  Widget logInSocialMediaIntegrationButtons() {
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
