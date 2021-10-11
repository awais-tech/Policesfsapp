import 'package:flutter/material.dart';
import 'package:policesfs/manageorders/Ordersinprocess.dart';
import 'package:policesfs/manageorders/ordersPending_screen.dart';

class ComplaintTrack extends StatelessWidget {
  static final routeName = 'Track Complaint';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('hello')),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffB788E5),
            title: Text('Comaplaints'),
            bottom: TabBar(
              tabs: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Tab(
                      icon: Icon(Icons.approval_rounded),
                      text: "Pending Complaint"),
                ),
                FittedBox(
                  child: Tab(
                      icon: Icon(Icons.pending_actions_rounded),
                      text: "Active Complaint"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Orderspendings(),
              OrdersInProcess(),
            ],
          ),
        ),
      ),
    );
  }
}
