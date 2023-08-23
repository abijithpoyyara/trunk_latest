class ChangeFilterAction {
  final type;
  final DateTime fromDate;
  final DateTime toDate;
  final bool margin;
  final bool major;

  ChangeFilterAction(
      {this.fromDate, this.toDate, this.margin, this.major, this.type});
}
