import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_website_app/models/book.dart';
import 'package:flutter_website_app/providers/books_provider.dart';
import 'package:provider/provider.dart';

import '../form_text_field.dart';

class BookEditorForm extends StatefulWidget {
  final Map _toEdit;

  BookEditorForm({toEdit}) : _toEdit = (toEdit) ?? {};

  @override
  _BookEditorFormState createState() => _BookEditorFormState();
}

class _BookEditorFormState extends State<BookEditorForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();
  final FocusNode _imgUrlNode = FocusNode();
  Map _formData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMap();
    _initFields();
  }

  void _loadMap() => _formData = widget._toEdit;

  void _initFields() {
    setState(() {
      _titleController.text = _formData['title'] ?? "";
      _imgUrlController.text = _formData['img_url'] ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleNode.dispose();
    _titleController.dispose();
    _imgUrlNode.dispose();
    _imgUrlController.dispose();
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
    if (_isNewBook) {
      await _addBook(context);
    } else {
      await _updateBook(context);
    }
    setState(() => _isLoading = false);
  }

  bool get _isNewBook => _formData["id"] == null;

  Future<void> _addBook(BuildContext context) async {
    try {
      await context.read<BooksProvider>().addBook(Book.fromMap(_formData));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (_) {
      _manageFirebaseError(context);
    }
  }

  Future<void> _updateBook(BuildContext context) async {
    try {
      await context.read<BooksProvider>().updateBook(Book.fromMap(_formData));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (_) {
      _manageFirebaseError(context);
    }
  }

  void _manageFirebaseError(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Error! Cannot update book.")));
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
            FormTextField(
              onFieldSubmit: _onTitleFieldSubmit,
              formData: _formData,
              controller: _titleController,
              formKey: "title",
              labelText: "Enter title",
              focusNode: _titleNode,
            ),
            FormTextField(
              onFieldSubmit: () => _submit(context),
              formData: _formData,
              controller: _imgUrlController,
              formKey: "img_url",
              labelText: "Enter image url",
              focusNode: _imgUrlNode,
            ),
            _SaveButton(onSubmit: _submit, isLoading: _isLoading)
          ],
        ));
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
