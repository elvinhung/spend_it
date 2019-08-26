import 'database_helper.dart';

class Utilities {
  static double getSum(List<Payment> payments) {
    double total = 0;
    payments.forEach((payment) => total += payment.price);
    return total;
  }

}