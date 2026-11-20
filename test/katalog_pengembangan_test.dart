import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget/main.dart';

void main() {
  testWidgets('Pengembangan 1: Produk memiliki gambar dan minimal 3 produk baru ditambahkan', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Tas Ransel'), findsWidgets);
    expect(find.text('Sepatu Sneaker'), findsWidgets);
    expect(find.text('Headphone'), findsWidgets);
    expect(find.text('Smartwatch'), findsWidgets);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('Pengembangan 3: Informasi rating ditampilkan', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsWidgets);
    expect(find.text('4.5'), findsWidgets);
    expect(find.text('4.8'), findsWidgets);
  });

  testWidgets('Pengembangan 4: GridView responsif 2 kolom di layar ponsel dan 3 kolom di layar lebar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MainApp());
    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Grid'));
    await tester.pumpAndSettle();

    var grid = tester.widget<GridView>(find.byType(GridView));
    expect(
      (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount).crossAxisCount,
      2,
    );

    tester.view.physicalSize = const Size(700, 900);
    await tester.pumpAndSettle();

    grid = tester.widget<GridView>(find.byType(GridView));
    expect(
      (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount).crossAxisCount,
      3,
    );
  });

  testWidgets('Pengembangan 5: Tombol favorit berfungsi dengan respons SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.byIcon(Icons.storefront_outlined));
    await tester.pumpAndSettle();

    final favButtons = find.byTooltip('Tambah favorit');
    expect(favButtons, findsWidgets);

    // Tap to add favorite
    await tester.tap(favButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Ditambahkan ke Favorit'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // Settle out the snackbar
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Now tap to remove favorite
    final removeFavButtons = find.byTooltip('Hapus favorit');
    expect(removeFavButtons, findsWidgets);

    await tester.tap(removeFavButtons.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dihapus dari Favorit'), findsOneWidget);
  });
}
