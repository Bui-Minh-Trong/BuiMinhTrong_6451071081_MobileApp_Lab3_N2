import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profile_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. profile table
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        about_me TEXT
      )
    ''');

    // 2. work_experience table
    await db.execute('''
      CREATE TABLE work_experience (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT,
        company TEXT,
        period TEXT
      )
    ''');

    // 3. education table
    await db.execute('''
      CREATE TABLE education (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        degree TEXT,
        school TEXT,
        period TEXT
      )
    ''');

    // 4. skill table
    await db.execute('''
      CREATE TABLE skill (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // 5. language table
    await db.execute('''
      CREATE TABLE language (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // 6. appreciation table
    await db.execute('''
      CREATE TABLE appreciation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        awarder TEXT,
        year TEXT
      )
    ''');

    // 7. resume table
    await db.execute('''
      CREATE TABLE resume (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_name TEXT,
        file_size TEXT,
        upload_time TEXT
      )
    ''');

    // Seed default data
    await db.insert('profile', {
      'id': 1,
      'name': 'Bùi Minh Trọng',
      'email': '6451071081@st.utc2.edu.vn',
      'about_me': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus id commodo egestas metus interdum dolor.'
    });

    await db.insert('work_experience', {
      'role': 'Manager',
      'company': 'Amazon Inc',
      'period': 'Jan 2015 - Feb 2022 · 5 Years'
    });

    await db.insert('education', {
      'degree': 'Information Technology',
      'school': 'University of Oxford',
      'period': 'Sep 2010 - Aug 2013 · 5 Years'
    });

    final defaultSkills = [
      'Leadership',
      'Teamwork',
      'Visioner',
      'Target oriented',
      'Consistent',
      'Good communication',
      'English',
      'Problem Solving',
      'Creativity',
      'Adaptability'
    ];
    for (var skill in defaultSkills) {
      await db.insert('skill', {'name': skill});
    }

    final defaultLanguages = [
      'English',
      'German',
      'Spanish',
      'Mandarin',
      'Italy',
      'Vietnamese',
      'Japanese'
    ];
    for (var lang in defaultLanguages) {
      await db.insert('language', {'name': lang});
    }

    await db.insert('appreciation', {
      'title': 'Wireless Symposium (RWS)',
      'awarder': 'Young Scientist',
      'year': '2014'
    });

    await db.insert('resume', {
      'file_name': 'Jamet kudasi - CV - UI/UX Designer',
      'file_size': '867 Kb',
      'upload_time': '14 Feb 2022 at 11:30 am'
    });
  }

  // Fetching data
  Future<Map<String, dynamic>> getProfile() async {
    final db = await database;
    final maps = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }

  Future<List<Map<String, String>>> getWorkExperiences() async {
    final db = await database;
    final maps = await db.query('work_experience');
    return maps.map((map) => {
      'role': map['role'] as String? ?? '',
      'company': map['company'] as String? ?? '',
      'period': map['period'] as String? ?? '',
    }).toList();
  }

  Future<List<Map<String, String>>> getEducations() async {
    final db = await database;
    final maps = await db.query('education');
    return maps.map((map) => {
      'degree': map['degree'] as String? ?? '',
      'school': map['school'] as String? ?? '',
      'period': map['period'] as String? ?? '',
    }).toList();
  }

  Future<List<String>> getSkills() async {
    final db = await database;
    final maps = await db.query('skill');
    return maps.map((map) => map['name'] as String? ?? '').toList();
  }

  Future<List<String>> getLanguages() async {
    final db = await database;
    final maps = await db.query('language');
    return maps.map((map) => map['name'] as String? ?? '').toList();
  }

  Future<List<Map<String, String>>> getAppreciations() async {
    final db = await database;
    final maps = await db.query('appreciation');
    return maps.map((map) => {
      'title': map['title'] as String? ?? '',
      'awarder': map['awarder'] as String? ?? '',
      'year': map['year'] as String? ?? '',
    }).toList();
  }

  Future<List<Map<String, String>>> getResumes() async {
    final db = await database;
    final maps = await db.query('resume');
    return maps.map((map) => {
      'fileName': map['file_name'] as String? ?? '',
      'fileSize': map['file_size'] as String? ?? '',
      'uploadTime': map['upload_time'] as String? ?? '',
    }).toList();
  }

  // Save all profile data inside a transaction
  Future<void> saveAllProfileData({
    required String name,
    required String email,
    required String aboutMe,
    required List<Map<String, String>> workExperiences,
    required List<Map<String, String>> educations,
    required List<String> skills,
    required List<String> languages,
    required List<Map<String, String>> appreciations,
    required List<Map<String, String>> resumes,
  }) async {
    final db = await database;
    await db.transaction((txn) async {
      // 1. Update profile
      await txn.update(
        'profile',
        {
          'name': name,
          'email': email,
          'about_me': aboutMe,
        },
        where: 'id = ?',
        whereArgs: [1],
      );

      // 2. Work experiences
      await txn.delete('work_experience');
      for (var exp in workExperiences) {
        await txn.insert('work_experience', {
          'role': exp['role'] ?? '',
          'company': exp['company'] ?? '',
          'period': exp['period'] ?? '',
        });
      }

      // 3. Educations
      await txn.delete('education');
      for (var edu in educations) {
        await txn.insert('education', {
          'degree': edu['degree'] ?? '',
          'school': edu['school'] ?? '',
          'period': edu['period'] ?? '',
        });
      }

      // 4. Skills
      await txn.delete('skill');
      for (var skill in skills) {
        await txn.insert('skill', {'name': skill});
      }

      // 5. Languages
      await txn.delete('language');
      for (var lang in languages) {
        await txn.insert('language', {'name': lang});
      }

      // 6. Appreciations
      await txn.delete('appreciation');
      for (var app in appreciations) {
        await txn.insert('appreciation', {
          'title': app['title'] ?? '',
          'awarder': app['awarder'] ?? '',
          'year': app['year'] ?? '',
        });
      }

      // 7. Resumes
      await txn.delete('resume');
      for (var res in resumes) {
        await txn.insert('resume', {
          'file_name': res['fileName'] ?? '',
          'file_size': res['fileSize'] ?? '',
          'upload_time': res['uploadTime'] ?? '',
        });
      }
    });
  }
}
