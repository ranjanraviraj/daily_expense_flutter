import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Charts extends StatelessWidget {
  List<Transaction> recentTransaction;

  Charts(this.recentTransaction);

  List<Map<String, Object>> get getGroupTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totaAmmount = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totaAmmount += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totaAmmount,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return getGroupTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding:const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getGroupTransactionValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  day: data['day'],
                  totalAmount: data['amount'],
                  totalAmountPercent: totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
