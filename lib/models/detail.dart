import 'impaye.dart';

class DetailArguments {
  final String creancierName;
  final String creanceName;
  final String debiteurName;
  final DateTime dateCreance;
  final List<Impaye> selectedImpayes;

  DetailArguments({
    required this.creancierName,
    required this.creanceName,
    required this.debiteurName,
    required this.dateCreance,
    required this.selectedImpayes,
  });
}