import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInputController = TextEditingController();

  final amountInputController = TextEditingController();
  DateTime _selectedDate;

  void _submit() {
    final enterTitle = titleInputController.text;
    final enterAMount = double.parse(amountInputController.text);
    if (enterTitle.isEmpty || enterAMount < 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enterTitle, enterAMount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleInputController,
                onSubmitted: (_) => _submit(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountInputController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submit(),
                // onChanged: (amount) {
                //   amountInput = amount;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Selected!'
                          : 'Picked date : ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton('Chose Date', _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _submit,
                child: const Text('Add Transaction'),
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
