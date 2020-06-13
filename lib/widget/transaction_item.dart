import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTxt,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTxt;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

Color _bgColor;

@override
  void initState() {
    const color = [Colors.red, Colors.black, Colors.blue, Colors.purple,];
    _bgColor = color[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text('\$ ${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 420
            ? FlatButton.icon(
                onPressed: () => widget.deleteTxt(widget.transaction.id),
                icon: const Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete'))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTxt(widget.transaction.id),
              ),
      ),
    );
  }
}