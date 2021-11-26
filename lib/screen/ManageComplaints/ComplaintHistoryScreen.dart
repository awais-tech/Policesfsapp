import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/providers/Complaints.dart';
import 'package:policesfs/widgets/PendingComplaints.dart';
import 'package:policesfs/widgets/complete.dart';
import 'package:provider/provider.dart';

class ComplaintHistory extends StatelessWidget {
  static final routeName = 'history';

  final stream = FirebaseFirestore.instance
      .collection('Complaints')
      .where('Userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status', isEqualTo: 'Complete')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title:
            FittedBox(fit: BoxFit.fitWidth, child: Text('Complaint History')),
      ),

      // body: StreamBuilder<List<ComplaintsModel>>(
      //   stream: complaints.allcomplaints,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       print(snapshot);
      //       return Center(
      //         child: Text("No Data is here"),
      //       );
      //     } else {
      //       final com = snapshot.data;
      //       return com!.isEmpty
      //           ? Center(
      //               child: Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: FittedBox(
      //                   fit: BoxFit.contain,
      //                   child: Text(
      //                     'Welcome! Pending Complaints will be shown here',
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 ),
      //               ),
      //             )
      //           : ListView.builder(
      //               itemCount: snapshot.data!.length,
      //               itemBuilder: (ctx, i) =>
      //                   (snapshot.data![i].status == 'pending'
      //                       ? PendingCompalints(snapshot.data![i])
      //                       : Container()),
      //             );
      //     }
      //   },
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snp) {
          if (snp.hasError) {
            print(snp);
            return Center(
              child: Text("No Data is here"),
            );
          } else if (snp.hasData || snp.data != null) {
            return snp.data!.docs.length < 1
                ? Center(child: Container(child: Text("No Complete Complaint")))
                : ListView.builder(
                    itemCount: snp.data!.docs.length,
                    itemBuilder: (ctx, i) =>
                        (snp.data!.docs[i].data() as Map)['status'] ==
                                'Complete'
                            ? CompleteCompalints(snp.data!.docs[i])
                            : Container());
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            ),
          );
        },
      ),
    );
  }
}
