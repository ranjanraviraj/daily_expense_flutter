import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final double totalAmount;
  final double totalAmountPercent;

  ChartBar({
    @required this.day,
    @required this.totalAmount,
    @required this.totalAmountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constaints) {
        return Column(
          children: <Widget>[
            Container(
                height: constaints.maxHeight * 0.15,
                child: FittedBox(
                    child: Text('\$ ${totalAmount.toStringAsFixed(0)}'))),
            SizedBox(
              height: constaints.maxHeight * 0.05,
            ),
            Container(
              height: constaints.maxHeight * 0.60,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: totalAmountPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constaints.maxHeight * 0.05,
            ),
            Container(
              height: constaints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(day),
              ),
            ),
          ],
        );
      },
    );
  }
}
