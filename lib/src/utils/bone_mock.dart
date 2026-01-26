class MockData {
  static const String _word = 'Mocking';

  static String chars(int charNo, [String char = 'C']) => char * charNo;

  static String words(int words) => _word * words;

  static String title = _word * 2;

  static String get subtitle => _word * 3;

  static String name = _word * 2;

  static String fullName = _word * 3;

  static String get paragraph => _word * 20;

  static String get longParagraph => _word * 50;

  static String date = chars(10);

  static String time = chars(5);

  static String phone = chars(12);

  static String email = chars(18);

  static String address = chars(30);

  static String city = chars(15);

  static String country = chars(15);
}
