import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widget/transaction_list.dart';
import './models/transaction.dart';
import './widget/chart.dart';
import './widget/new_transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Expense',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white)),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 29.9,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly grocery',
    //   amount: 17.9,
    //   date: DateTime.now(),
    // )
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTranscation {
    return _userTransaction.where((txt) {
      return txt.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  _addTransaction(
      String inputTitle, double inputAmount, DateTime selectedDate) {
    final newTxt = Transaction(
      id: DateTime.now().toString(),
      title: inputTitle,
      amount: inputAmount,
      date: selectedDate,
    );

    setState(() {
      _userTransaction.add(newTxt);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((txt) => txt.id == id);
    });
  }

  void _showNewTransactionSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () => {},
          child: NewTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildPotraitModeCOntent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
    bool islandScape,
    bool _showChart,
  ) {
    final factor = islandScape ? 0.7 : 0.3;
    final height = (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        factor;
    final charts = Container(
      height: height,
      child: Charts(_recentTranscation),
    );
    if (islandScape) {
      if (_showChart)
        return [charts];
      else
        return [txListWidget];
    } else {
      return [charts, txListWidget];
    }
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Daily Expense',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _showNewTransactionSheet(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Daily Expense'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showNewTransactionSheet(context),
              )
            ],
          );
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final islandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (islandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            ..._buildPotraitModeCOntent(
                mediaQuery, appBar, txListWidget, islandScape, _showChart),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _showNewTransactionSheet(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
