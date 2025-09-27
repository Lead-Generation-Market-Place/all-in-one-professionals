// lib/features/questions/domain/enums/form_type_enum.dart

enum FormType {
  checkbox('checkbox'),
  radio('radio'),
  text('text'),
  select('select'),
  number('number'),
  date('date');

  final String value;
  const FormType(this.value);

  static FormType fromString(String value) {
    return FormType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FormType.text, // default fallback
    );
  }

  bool get isCheckbox => this == FormType.checkbox;
  bool get isRadio => this == FormType.radio;
  bool get isText => this == FormType.text;
  bool get isSelect => this == FormType.select;
  bool get isNumber => this == FormType.number;
  bool get isDate => this == FormType.date;
}
