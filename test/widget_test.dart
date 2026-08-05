import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/modules/home/controllers/home_controller.dart';
import 'package:portfolio/app/modules/home/views/home_view.dart';

void main() {
  testWidgets('Portfolio UI Renders Successfully', (WidgetTester tester) async {
    // Inject the HomeController required by HomeView
    Get.put(HomeController());

    // Build the widget tree
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );

    // Verify that the title is rendered
    expect(find.text('Persona'), findsOneWidget);
  });
}
