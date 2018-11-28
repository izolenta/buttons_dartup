class Difficulty {
  static const int _easy = 0;
  static const int _medium = 1;
  static const int _hard = 2;

  static const stringValues = ['easy', 'medium', 'hard'];
  static const intValues = [0, 1, 2];

  int _type = _easy;

  Difficulty.easy(): this._type = _easy;
  Difficulty.medium(): this._type = _medium;
  Difficulty.hard(): this._type = _hard;

  Difficulty(this._type);

  int get intValue => _type;
  String get stringValue => stringValues[_type];
}