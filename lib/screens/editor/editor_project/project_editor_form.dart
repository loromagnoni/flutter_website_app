import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_website_app/models/project.dart';
import 'package:flutter_website_app/screens/editor/form_text_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_website_app/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class ProjectEditorForm extends StatefulWidget {
  final Map _toEdit;

  ProjectEditorForm({toEdit}) : _toEdit = (toEdit) ?? {};

  @override
  _ProjectEditorFormState createState() => _ProjectEditorFormState();
}

class _ProjectEditorFormState extends State<ProjectEditorForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _imgUrlNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final FocusNode _gitHubLinkNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  final TextEditingController _githubLinkController = TextEditingController();
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
      _descriptionController.text = _formData['description'] ?? "";
      _youtubeLinkController.text = _formData['youtube_link'] ?? "";
      _githubLinkController.text = _formData['github_link'] ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleNode.dispose();
    _titleController.dispose();
    _descriptionNode.dispose();
    _descriptionController.dispose();
    _youtubeLinkNode.dispose();
    _youtubeLinkController.dispose();
    _gitHubLinkNode.dispose();
    _githubLinkController.dispose();
    _imgUrlNode.dispose();
    _imgUrlController.dispose();
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

  void _onGithubLinkFieldSubmit() {
    _gitHubLinkNode.unfocus();
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
    if (_isNewProject) {
      await _addProject(context);
    } else {
      await _updateProject(context);
    }
    setState(() => _isLoading = false);
  }

  bool get _isNewProject => _formData["id"] == null;

  Future<void> _addProject(BuildContext context) async {
    try {
      await context
          .read<ProjectsProvider>()
          .addProject(Project.fromMap(_formData));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _manageFirebaseError(context);
    }
  }

  Future<void> _updateProject(BuildContext context) async {
    try {
      await context
          .read<ProjectsProvider>()
          .updateProject(Project.fromMap(_formData));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
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
                controller: _titleController,
                onFieldSubmit: _onTitleFieldSubmit,
                focusNode: _titleNode,
                formData: _formData,
                formKey: "title",
                labelText: "Enter project title"),
            FormTextField(
                controller: _descriptionController,
                focusNode: _descriptionNode,
                onFieldSubmit: _onDescriptionFieldSubmit,
                formData: _formData,
                formKey: "description",
                labelText: "Enter description"),
            FormTextField(
                controller: _imgUrlController,
                focusNode: _imgUrlNode,
                onFieldSubmit: _onImgUrlFieldSubmit,
                formData: _formData,
                formKey: "img_url",
                labelText: "Enter url of image"),
            FormTextField(
              controller: _youtubeLinkController,
              focusNode: _youtubeLinkNode,
              onFieldSubmit: _onYoutubeLinkFieldSubmit,
              formData: _formData,
              formKey: "youtube_link",
              labelText: "Enter youtube link",
              acceptNull: true,
            ),
            FormTextField(
                controller: _githubLinkController,
                focusNode: _gitHubLinkNode,
                onFieldSubmit: _onGithubLinkFieldSubmit,
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
