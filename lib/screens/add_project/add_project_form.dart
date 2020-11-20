import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_website_app/models/project.dart';
import 'package:intl/intl.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class AddProjectForm extends StatefulWidget {
  @override
  _AddProjectFormState createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = {};
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _imgUrlNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final FocusNode _gitHubLinkNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _titleNode.dispose();
    _descriptionNode.dispose();
    _youtubeLinkNode.dispose();
    _gitHubLinkNode.dispose();
    _imgUrlNode.dispose();
  }

  void _onTitleFieldSubmit() {
    _titleNode.unfocus();
    FocusScope.of(context).requestFocus(_descriptionNode);
  }

  void _onDescriptionFieldSubmit() {
    _descriptionNode.unfocus();
    FocusScope.of(context).requestFocus(_imgUrlNode);
  }

  void _onImgUrlFieldSubmit() {
    _imgUrlNode.unfocus();
    FocusScope.of(context).requestFocus(_youtubeLinkNode);
  }

  void _onYoutubeLinkFieldSubmit() {
    _youtubeLinkNode.unfocus();
    FocusScope.of(context).requestFocus(_gitHubLinkNode);
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
    await _addProject(context);
    setState(() => _isLoading = false);
  }

  Future<void> _addProject(BuildContext context) async {
    try {
      await context
          .read<ProjectsProvider>()
          .addProject(Project.fromMap(_formData));
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
            _FormTextField(
                onFieldSubmit: _onTitleFieldSubmit,
                focusNode: _titleNode,
                formData: _formData,
                formKey: "title",
                labelText: "Enter project title"),
            _FormTextField(
                focusNode: _descriptionNode,
                onFieldSubmit: _onDescriptionFieldSubmit,
                formData: _formData,
                formKey: "description",
                labelText: "Enter description"),
            _FormTextField(
                focusNode: _imgUrlNode,
                onFieldSubmit: _onImgUrlFieldSubmit,
                formData: _formData,
                formKey: "img_url",
                labelText: "Enter url of image"),
            _FormTextField(
              focusNode: _youtubeLinkNode,
              onFieldSubmit: _onYoutubeLinkFieldSubmit,
              formData: _formData,
              formKey: "youtube_link",
              labelText: "Enter youtube link",
              acceptNull: true,
            ),
            _FormTextField(
                focusNode: _gitHubLinkNode,
                onFieldSubmit: _onTitleFieldSubmit,
                formData: _formData,
                formKey: "github_link",
                labelText: "Enter github link",
                acceptNull: true),
            _Date(formData: _formData, onSelect: () => setState(() {})),
            _SaveButton(onSubmit: _submit, isLoading: _isLoading)
          ],
        ));
  }
}

class _FormTextField extends StatelessWidget {
  _FormTextField(
      {Key key,
      @required Function onFieldSubmit,
      @required Map formData,
      @required String formKey,
      @required String labelText,
      @required FocusNode focusNode,
      acceptNull})
      : _formData = formData,
        _formKey = formKey,
        _labelText = labelText,
        _onFieldSubmit = onFieldSubmit,
        _focusNode = focusNode,
        _acceptNull = acceptNull ?? false,
        super(key: key);
  final String _formKey;
  final bool _acceptNull;
  final String _labelText;
  final Function _onFieldSubmit;
  final FocusNode _focusNode;
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
        focusNode: _focusNode,
        cursorColor: Theme.of(context).accentColor,
        cursorWidth: 10.0,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: _labelText,
        ),
        validator: _acceptNull ? null : _validator,
        onEditingComplete: _onFieldSubmit,
        onSaved: (value) => _formData[_formKey] = value,
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final Map _formData;
  final Function _onSelect;

  _Date({@required formData, @required onSelect})
      : _formData = formData,
        _onSelect = onSelect;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Expanded(
          child: Text(
              _formData["date"] == null
                  ? "Select a date"
                  : DateFormat("dd-MM-yyyy").format(_formData["date"]),
              style: Theme.of(context).textTheme.bodyText1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () => _pickDate(context),
            child: Text(
              'Pick',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black87),
            ),
          ),
        )
      ]),
    );
  }

  void _pickDate(BuildContext context) {
    showDatePicker(
            context: context,
            firstDate: new DateTime(2015),
            lastDate: new DateTime(2100),
            initialDate: new DateTime.now())
        .then((date) {
      _formData["date"] = date;
      _onSelect();
    });
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
