import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final DatabaseReference _reportsRef = FirebaseDatabase.instance.ref('reports');
  final DatabaseReference _postsRef = FirebaseDatabase.instance.ref('posts');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  List<Map<dynamic, dynamic>> reportsList = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    _reportsRef.onValue.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> reports = event.snapshot.value as Map<dynamic, dynamic>;

        List<Map<dynamic, dynamic>> loadedReports = [];
        for (var reportKey in reports.keys) {
          final reportData = reports[reportKey];
          final postId = reportData['postId'];
          final reporterId = reportData['userId'];
          final reason = reportData['reason'];
          final timestamp = reportData['timestamp'];

          // Fetch post details (caption, uploaderId, and postImageUrl)
          final postSnapshot = await _postsRef.child(postId).get();
          final postDetails = postSnapshot.value as Map<dynamic, dynamic>;
          final caption = postDetails['caption'];
          final uploaderId = postDetails['userId'];
          final postImageUrl = postDetails['postImageUrl'];

          // Fetch uploader's name
          final uploaderSnapshot = await _usersRef.child(uploaderId).get();
          final uploaderName = uploaderSnapshot.child('userName').value as String;

          // Fetch reporter's name
          final reporterSnapshot = await _usersRef.child(reporterId).get();
          final reporterName = reporterSnapshot.child('userName').value as String;

          // Add the complete report details to the list
          loadedReports.add({
            'postId': postId,
            'caption': caption,
            'reason': reason,
            'timestamp': timestamp,
            'uploaderName': uploaderName,
            'reporterName': reporterName,
            'postImageUrl': postImageUrl,
          });
        }

        setState(() {
          reportsList = loadedReports;
        });
      } else {
        setState(() {
          reportsList = [];
        });
      }
    });
  }

  // Helper function to format timestamp
  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reported Posts'),
        backgroundColor: Colors.black,
      ),
      body: reportsList.isEmpty
          ? Center(child: Text('No reports found'))
          : ListView.builder(
        itemCount: reportsList.length,
        itemBuilder: (context, index) {
          final report = reportsList[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (report['postImageUrl'] != null)
                    Container(
                      margin: EdgeInsets.only(bottom: 8.0),
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(report['postImageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Text(
                    'Caption: ${report['caption']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Uploader: ${report['uploaderName']}'),
                  Text('Reported by: ${report['reporterName']}'),
                  Text('Reason: ${report['reason']}'),
                  Text('Date: ${_formatTimestamp(report['timestamp'])}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}