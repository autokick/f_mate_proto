import 'package:flutter_test/flutter_test.dart';

import 'package:f_mate_proto/app.dart';

void main() {
  testWidgets('prototype home renders key sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FMateApp(startInHome: true));

    expect(find.text('F-MATE'), findsWidgets);
    expect(find.text('MATCHDAY PICK'), findsOneWidget);
    expect(find.text('성수 수요 야간 5v5'), findsOneWidget);
  });
}
