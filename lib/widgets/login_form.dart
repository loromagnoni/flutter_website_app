import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_website_app/screens/management/management.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = {};
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
  }

  void _onEmailFieldSubmit() {
    _emailNode.unfocus();
    FocusScope.of(context).requestFocus(_passwordNode);
  }

  void _submit(BuildContext context) {
    _removeKeyboard(context);
    _trySignIn(context);
  }

  void _trySignIn(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _manageSignInState(context);
    }
  }

  void _manageSignInState(BuildContext context) async {
    setState(() => _isLoading = true);
    await _signIn(context);
    setState(() => _isLoading = false);
  }

  void _removeKeyboard(BuildContext context) {
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  void _signIn(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _formData['email'], password: _formData['password']);
      Navigator.pushNamed(context, ManagementScreen.routeName);
    } on FirebaseAuthException catch (e) {
      _manageLoginError(e, context);
    }
  }

  void _manageLoginError(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'user-not-found') {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that email.')));
    } else if (e.code == 'wrong-password') {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Wrong password.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LoginTitle(),
            _Email(onFieldSubmit: _onEmailFieldSubmit, formData: _formData),
            _Password(
                passwordNode: _passwordNode,
                formData: _formData,
                onSubmit: _submit),
            _LoginButton(onSubmit: _submit, isLoading: _isLoading)
          ],
        ));
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('> Login', style: Theme.of(context).textTheme.headline1);
  }
}

class _Email extends StatelessWidget {
  _Email({
    Key key,
    @required Function onFieldSubmit,
    @required Map formData,
  })  : _formData = formData,
        _onFieldSubmit = onFieldSubmit,
        super(key: key);
  final Function _onFieldSubmit;
  final Map _formData;
  final Function _validator = (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? "Enter a valid email" : null;
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        cursorColor: Theme.of(context).accentColor,
        cursorWidth: 10.0,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: "Enter your email",
        ),
        validator: _validator,
        onEditingComplete: _onFieldSubmit,
        onSaved: (value) => _formData['email'] = value,
      ),
    );
  }
}

class _Password extends StatelessWidget {
  _Password({
    Key key,
    @required FocusNode passwordNode,
    @required Map formData,
    @required Function onSubmit,
  })  : _passwordNode = passwordNode,
        _formData = formData,
        _onSubmit = onSubmit,
        super(key: key);

  final FocusNode _passwordNode;
  final Map _formData;
  final Function _onSubmit;
  final Function _validator = (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    if (value.length < 6) {
      return 'Password is too short';
    }
    return null;
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: _passwordNode,
        cursorColor: Theme.of(context).accentColor,
        cursorWidth: 10.0,
        enableSuggestions: false,
        autocorrect: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: "Enter your password",
        ),
        validator: _validator,
        onFieldSubmitted: (_) => _onSubmit(context),
        onSaved: (value) => _formData['password'] = value,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required Function onSubmit,
    @required bool isLoading,
  })  : _onSubmit = onSubmit,
        _isLoading = isLoading,
        super(key: key);

  final Function _onSubmit;
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _isLoading
          ? _Loading()
          : RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () => _onSubmit(context),
              child: Text(
                'Submit',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black87),
              ),
            ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 20, width: 20, child: CircularProgressIndicator()));
  }
}
