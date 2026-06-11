import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../models/rsvp_entry.dart';

class RsvpDatabase {
  static final RsvpDatabase instance = RsvpDatabase._();
  static Database? _db;

  RsvpDatabase._();

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'andro_rsvps.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE rsvps (
          userId    TEXT NOT NULL,
          eventId   TEXT NOT NULL,
          status    TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          checkedIn INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY (userId, eventId)
        )
      '''),
    );
  }

  Future<List<RsvpEntry>> getRsvpsForUser(String userId) async {
    final db = await database;
    final rows = await db.query(
      'rsvps',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return rows.map(RsvpEntry.fromMap).toList();
  }

  Future<void> upsertRsvp(String userId, RsvpEntry entry) async {
    final db = await database;
    await db.insert(
      'rsvps',
      entry.toMap(userId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRsvp(String userId, String eventId) async {
    final db = await database;
    await db.delete(
      'rsvps',
      where: 'userId = ? AND eventId = ?',
      whereArgs: [userId, eventId],
    );
  }

  Future<int> countForUser(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as c FROM rsvps WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
