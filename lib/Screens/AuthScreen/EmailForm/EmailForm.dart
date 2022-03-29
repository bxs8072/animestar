import 'package:animestar/Screens/AuthScreen/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

enum FormType { login, register }

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FormType _formType = FormType.login;

  formTypeToggler() {
    bool _isLoginType = _formType == FormType.login;
    setState(() {
      _formType = _isLoginType ? FormType.register : FormType.login;
      _key.currentState.reset();
    });
  }

  String get email => _emailController.text.trim().toLowerCase();
  String get password => _passwordController.text.trim();
  AuthBase _auth = Auth();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future showErrorDialog(String error) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            content: Text(error),
            actions: [
              FlatButton(
                child: Text(
                  "Ok",
                  style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        });
  }

  void submit() async {
    bool _isLoginType = _formType == FormType.login;
    if (_key.currentState.validate()) if (_isLoginType) {
      _auth.signInWithEmailAndPassword(email, password).catchError((e) {
        return showErrorDialog(e.message);
      });
    } else {
      _auth.registerWithEmailAndPassword(email, password).catchError((e) {
        return showErrorDialog(e.message);
      });
    }
  }

  void resetEmail() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Forget Password?"),
        content: TextField(
          controller: _emailController,
          decoration: InputDecoration(hintText: "Email"),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              _auth.resetPassword(email).then((value) {
                Navigator.of(ctx).pop(true);
              }).catchError((e) {
                return showErrorDialog(e.message);
              }).then((value) {
                return showErrorDialog("Check your email to reset password!!!");
              });
            },
            child: Text("Reset"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  final _key = GlobalKey<FormState>();

  OutlineInputBorder _border(BuildContext context) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: ThemeProvider.controllerOf(context).currentThemeId == "storm"
            ? Colors.black
            : Colors.white,
        style: BorderStyle.solid,
      ));
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: _formType == FormType.login ? 'Sign In' : 'Register',
                  style: GoogleFonts.ubuntu(
                    color: ThemeProvider.controllerOf(context).currentThemeId ==
                            "storm"
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.045,
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: _border(context),
              focusedBorder: _border(context),
              hintText: "Email Address",
              prefixIcon: Icon(
                Icons.email,
                color: ThemeProvider.controllerOf(context).currentThemeId ==
                        "storm"
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            validator: (val) {
              if (val.isEmpty || !val.contains(".") || !val.contains("@")) {
                return "Enter valid email address.";
              }
              return null;
            },
            onChanged: (val) {
              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _passwordController,
            validator: (val) {
              if (val.isEmpty) {
                return "Enter valid password.";
              }
              return null;
            },
            decoration: InputDecoration(
              border: _border(context),
              focusedBorder: _border(context),
              hintText: "Password",
              prefixIcon: Icon(
                Icons.lock,
                color: ThemeProvider.controllerOf(context).currentThemeId ==
                        "storm"
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            onChanged: (val) {
              setState(() {});
            },
          ),
          FlatButton(
            child: Text(
              _formType == FormType.login
                  ? "Don't have an acccount? Register!"
                  : "Already have an account? Sign In",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
            onPressed: formTypeToggler,
          ),
          FlatButton(
            child: Text(
              "Forget Password?",
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.022,
              ),
            ),
            onPressed: resetEmail,
          ),
          CupertinoButton(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100),
            child: Text(
              _formType == FormType.login ? "Login" : "Register",
              style: GoogleFonts.lato(),
            ),
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
