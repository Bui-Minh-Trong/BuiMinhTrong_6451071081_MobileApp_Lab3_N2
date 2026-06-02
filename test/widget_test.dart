import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buiminhtrong_6451071081_lab3/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupSqfliteMock();

  testWidgets('Profile screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Wait for the loading to finish and frames to render
    await tester.pumpAndSettle();
    
    // Verify that Profile title exists
    expect(find.text('Profile'), findsOneWidget);
    // Verify that the user's name is rendered
    expect(find.text('Bùi Minh Trọng'), findsOneWidget);
  });
}

void setupSqfliteMock() {
  const channel = MethodChannel('com.tekartik.sqflite');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
    if (methodCall.method == 'getDatabasesPath') {
      return '.';
    }
    if (methodCall.method == 'openDatabase') {
      return 1; // Database ID
    }
    if (methodCall.method == 'query') {
      final arguments = methodCall.arguments as Map?;
      final sql = arguments?['sql'] as String?;
      if (sql != null && sql.contains('profile')) {
        return [
          {
            'id': 1,
            'name': 'Bùi Minh Trọng',
            'email': '6451071081@st.utc2.edu.vn',
            'about_me': 'Lorem ipsum dolor sit amet.'
          }
        ];
      }
      return [];
    }
    return null;
  });
}
