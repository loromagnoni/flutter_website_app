import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_website_app/models/book.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:provider/provider.dart';

class AddBookForm extends StatefulWidget {
  @override
  _AddBookFormState createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = {};
  final FocusNode _titleNode = FocusNode();
  final FocusNode _imgUrlNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _titleNode.dispose();
    _imgUrlNode.dispose();
  }

  void _onTitleFieldSubmit() {
    _titleNode.unfocus();
    FocusScope.of(context).requestFocus(_imgUrlNode);
  }

  void _submit(BuildContext context) {
    _removeKeyboard(context);
    _tryAdd(context);
  }

  void _tryAdd(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _manageAddState(context);
    }
  }

  void _manageAddState(BuildContext context) async {
    setState(() => _isLoading = true);
    await _addBook(context);
    setState(() => _isLoading = false);
  }

  Future<void> _addBook(BuildContext context) async {
    try {
      await context.read<BooksProvider>().addBook(Book.fromMap(_formData));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _manageAddError(context);
    }
  }

  void _manageAddError(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Error! Cannot add book.")));
  }

  void _removeKeyboard(BuildContext context) {
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
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
            _Title(onFieldSubmit: _onTitleFieldSubmit, formData: _formData),
            _ImgUrl(
                imgUrlNode: _imgUrlNode,
                formData: _formData,
                onSubmit: _submit),
            _SaveButton(onSubmit: _submit, isLoading: _isLoading)
          ],
        ));
  }
}

class _Title extends StatelessWidget {
  _Title({
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
          labelText: "Enter book title",
        ),
        validator: _validator,
        onEditingComplete: _onFieldSubmit,
        onSaved: (value) => _formData['title'] = value,
      ),
    );
  }
}

class _ImgUrl extends StatelessWidget {
  _ImgUrl({
    Key key,
    @required FocusNode imgUrlNode,
    @required Map formData,
    @required Function onSubmit,
  })  : _imgUrlNode = imgUrlNode,
        _formData = formData,
        _onSubmit = onSubmit,
        super(key: key);

  final FocusNode _imgUrlNode;
  final Map _formData;
  final Function _onSubmit;
  final Function _validator = (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: _imgUrlNode,
        cursorColor: Theme.of(context).accentColor,
        cursorWidth: 10.0,
        enableSuggestions: false,
        autocorrect: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: "Enter book image url",
        ),
        validator: _validator,
        onFieldSubmitted: (_) => _onSubmit(context),
        onSaved: (value) => _formData['imgUrl'] = value,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
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
                'Save',
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
