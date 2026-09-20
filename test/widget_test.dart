import 'package:flutter_test/flutter_test.dart';

import 'package:koolbar_demo/main.dart';

void main() {
  testWidgets('shows the ride destination screen', (tester) async {
    await tester.pumpWidget(KoolbarApp());
    expect(find.text('Where to?'), findsOneWidget);
    expect(find.text('Current location'), findsOneWidget);
    expect(find.text('Set pin manually on map'), findsOneWidget);
  });
}
