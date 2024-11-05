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
