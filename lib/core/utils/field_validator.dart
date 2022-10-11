class FieldValidator {
  static String? name(String? val) {
    if (val == null) return null;
    if (val.length < 2) return 'Name should have at least two letters.';
    if (val.length > 15) return 'Name should be maximum 15 letters';

    /// Matches capital and small letters + space.
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(val)) {
      return 'Name should only contain letters';
    }
    return null;
  }

  static String? bio(String? val) {
    if (val == null || val == '') return null;
    // TODO: Handle this case.
    return null;
  }

  static String? nationality(String? val) {
    if (val == null || val == '') return null;
    if (val.length > 15) return 'Nationality should be maximum 15 letters';
    return null;
  }

  static String? age(String? val) {
    if (val == null || val == '') return null;
    int? age = int.tryParse(val);
    if (age == null) return 'Invalid age';
    if (age <= 12) return 'Age should be bigger than 12';
    if (age >= 115) return 'Age should be less than 115';
    return null;
  }

  static String? course(String? val) {
    if (val == null || val == '') return null;
    // TODO: Handle this case.
    return null;
  }

  static String? university(String? val) {
    if (val == null || val == '') return null;
    // TODO: Handle this case.
    return null;
  }
}
