import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  FormTextField(
      {Key key,
      @required Function onFieldSubmit,
      @required Map formData,
      @required String formKey,
      @required String labelText,
      @required TextEditingController controller,
      @required FocusNode focusNode,
      acceptNull})
      : _formData = formData,
        _formKey = formKey,
        _labelText = labelText,
        _onFieldSubmit = onFieldSubmit,
        _focusNode = focusNode,
        _controller = controller,
        _acceptNull = acceptNull ?? false,
        super(key: key);
  final String _formKey;
  final bool _acceptNull;
  final String _labelText;
  final Function _onFieldSubmit;
  final FocusNode _focusNode;
  final Map _formData;
  final TextEditingController _controller;
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
        controller: _controller,
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
