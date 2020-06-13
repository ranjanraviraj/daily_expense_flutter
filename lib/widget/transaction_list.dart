import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTxt;

  TransactionList(this.transaction, this.deleteTxt);

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrains) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added !',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: constrains.maxHeight * 0.1,
                  ),
                  Container(
                    height: constrains.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView(
            children: transaction
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTxt: deleteTxt,
                    ))
                .toList());
  }
}
