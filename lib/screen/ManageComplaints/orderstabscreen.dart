import 'package:flutter/material.dart';

import 'package:policesfs/screen/ManageComplaints/ComaplaintinPorcessScreen.dart';
import 'package:policesfs/screen/ManageComplaints/ComplaintPendingScreen.dart';

class ComplaintTrack extends StatelessWidget {
  static final routeName = 'Track Complaint';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                'Track Complaints',
                textAlign: TextAlign.center,
              ),
            ),
            bottom: TabBar(
              tabs: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Tab(
                      icon: Icon(Icons.approval_rounded),
                      text: "Pending Complaints"),
                ),
                FittedBox(
                  child: Tab(
                      icon: Icon(Icons.pending_actions_rounded),
                      text: "Active Complaints"),
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
