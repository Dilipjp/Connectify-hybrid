class AdminUsersScreen extends StatefulWidget {
  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    DatabaseReference usersRef = _database.ref('users');
    usersRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final usersMap = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          userList = usersMap.entries
              .where((entry) => entry.value['userRole'] == 'User')
              .map((entry) => {
            'userId': entry.key,
            'userName': entry.value['userName'],
            'userProfileImage': entry.value['userProfileImage'],
            'userStatus': entry.value['userStatus'],
          })
              .toList();
        });
      }
    });
  }
  void _toggleUserStatus(String userId, String currentStatus) {
    String newStatus = (currentStatus == 'active') ? 'deactivated' : 'active';

    // Show confirmation dialog before toggling status
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Status Change'),
          content: Text('Are you sure you want to ${newStatus} this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                DatabaseReference userRef = _database.ref('users/$userId');

                userRef.update({'userStatus': newStatus}).then((_) {
                  setState(() {
                    // Update the status in the local list to reflect the change
                    int index = userList.indexWhere((user) => user['userId'] == userId);
                    if (index != -1) {
                      userList[index]['userStatus'] = newStatus;
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User status updated to $newStatus')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating status: $error')),
                  );
                });
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Moderator Users'),
    backgroundColor: Colors.black,
    ),
    body: userList.isEmpty
    ? Center(child: CircularProgressIndicator())
        : ListView.builder(
    itemCount: userList.length,
    itemBuilder: (context, index) {
    final user = userList[index];
    return Card(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
    children: [
    CircleAvatar(
    backgroundImage: NetworkImage(
    user['userProfileImage'] ?? 'assets/profile_placeholder.png'),
    ),
    SizedBox(width: 10),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    user['userName'] ?? 'Unknown User',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    Text('Status: ${user['userStatus'] ?? 'Unknown'}'),
    ],
    ),
    ),
    ],
    ),
    SizedBox(height: 10), // Space between user info and buttons
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    ElevatedButton(
    onPressed: () {
    _toggleUserStatus(user['userId'], user['userStatus']);
    },