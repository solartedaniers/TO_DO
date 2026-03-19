import 'package:flutter_test/flutter_test.dart';
import 'package:task_pro_supabase/main.dart';

void main() {
  testWidgets('MainApp muestra pantalla de error cuando falla el arranque', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MainApp(
        bootstrapError: 'No se pudo inicializar Supabase',
      ),
    );

    expect(find.text('Error de conexion'), findsOneWidget);
    expect(find.text('No se pudo inicializar Supabase'), findsOneWidget);
  });
}
