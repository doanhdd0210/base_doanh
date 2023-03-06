import 'package:intl/intl.dart';

bool isStrEmpty(String? str) {
  return str == null || str.trim().isEmpty;
}

bool isStrNotEmpty(String? str) {
  return str != null && str.isNotEmpty;
}

String formatCurrency(dynamic amount, String symbol) {
  dynamic price;
  if (amount is String) {
    price = double.tryParse(amount) ?? 0;
  } else {
    price = amount;
  }
  final formatter = NumberFormat('###,###.##');
  final String mAmount = formatter.format(price);
  return mAmount + symbol;
}
