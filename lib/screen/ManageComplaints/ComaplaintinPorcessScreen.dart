import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/models/Complaints.dart';
import 'package:policesfs/providers/Complaints.dart';
import 'package:policesfs/widgets/PendingComplaints.dart';
import 'package:provider/provider.dart';

class OrdersInProcess extends StatelessWidget {
  var _isLoading = false;
  // final complaints = Complaints();

  final stream = FirebaseFirestore.instance
      .collection('Complaints')
      .where('Userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('status', whereIn: ['Active', 'Assigned', "Request"]).snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            print(snp.data!.docs.length);
            return snp.data!.docs.length < 1
                ? Center(child: Container(child: Text("No Active Complaint")))
                : ListView.builder(
                    itemCount: snp.data!.docs.length,
                    itemBuilder: (ctx, i) =>
                        (snp.data!.docs[i].data() as Map)['status'] ==
                                    'Active' ||
                                (snp.data!.docs[i].data() as Map)['status'] ==
                                    'Assigned' ||
                                (snp.data!.docs[i].data() as Map)['status'] ==
                                    'Request'
                            ? PendingCompalints(snp.data!.docs[i])
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
