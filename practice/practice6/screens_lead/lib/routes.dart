/// Every route name in the app lives here, and only here. A typo in a
/// constant is a compile error; a typo in a string is a crash that waits
/// for the user.
abstract final class Routes {
  static const students = '/';
  static const student = '/student';
  static const edit = '/edit';
}
