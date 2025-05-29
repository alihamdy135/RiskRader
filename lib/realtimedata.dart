import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Save user data to Realtime Database
  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    await _database.child('users/$uid').set(data);
  }

  // Get user data from Realtime Database
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DatabaseEvent event = await _database.child('users/$uid').once();
    return event.snapshot.value as Map<String, dynamic>?;
  }
}