import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> addEvent(DateTime date, String event, String type) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('calendar_events')
          .add({
        'date': Timestamp.fromDate(date),
        'event': event,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao adicionar evento: $e');
    }
  }

  Stream<QuerySnapshot> getEventsStream() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('calendar_events')
        .orderBy('date')
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getEventsForDate(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('calendar_events')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar eventos: $e');
    }
  }

  Future<void> removeEvent(String eventId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('calendar_events')
          .doc(eventId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao remover evento: $e');
    }
  }
}