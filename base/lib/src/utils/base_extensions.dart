import 'package:base/redux.dart';

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      this.toLowerCase().contains(secondString.toLowerCase());

  bool isIn(List<String> strings) {
    return strings
        .any((element) => element.toLowerCase() == this.toLowerCase());
  }

  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return this?.replaceAll(exp, '') ?? "";
  }
}

extension DoubleExtension on double {
  double toPrecision({int precision = 3}) =>
      double.parse(toStringAsFixed(precision));
}

extension IterableExtenstions<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension EnumExtensions on LoadingStatus {
  bool isLoading() => this == LoadingStatus.loading;

  bool hasError() => this == LoadingStatus.error;
}
