// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:flant/flant.dart';

void main() {
  testWidgets('should render default slot correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: FlanActionBar(
            children: <Widget>[
              FlanActionBarButton(
                child: Text('Content'),
              )
            ],
          ),
        ),
      ),
    );
    expect(find.text('Content'), findsOneWidget);
  });
}
