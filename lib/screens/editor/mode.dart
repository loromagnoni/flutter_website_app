enum Mode {
  Add,
  Edit,
}

extension ModeExtension on Mode {
  String get stringValue {
    switch (this) {
      case Mode.Add:
        return 'Add';
      case Mode.Edit:
        return 'Edit';
    }
    return "";
  }
}
