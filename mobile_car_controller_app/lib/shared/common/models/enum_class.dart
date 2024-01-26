abstract class EnumClass<T> {
  const EnumClass();

  T get value;

  bool match(T otherValue) => value == otherValue;

  @override
  String toString() {
    return value.toString();
  }

  static R parseOfValues<T, R extends EnumClass<T>>(T rawValue, List<R> values) {
    final value = tryParseOfValues(rawValue, values);
    if(value == null) throw Exception('Value $value isn\'t $T');
    return value;
  }

  static R? tryParseOfValues<T, R extends EnumClass<T>>(T rawValue, List<R> values) {
    return values.where((element) => element.match(rawValue)).firstOrNull;    
  }
}

abstract class StringEnumClass extends EnumClass<String> {
  const StringEnumClass(this.value);

  @override
  final String value;
}

abstract class IntEnumClass extends EnumClass<int> {
  const IntEnumClass(this.value);

  @override
  final int value;  
}
