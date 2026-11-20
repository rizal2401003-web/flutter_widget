import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'navigation.dart';
import 'theme.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  _CatalogLayout _layout = _CatalogLayout.list;
  final Set<String> _favoriteItems = {'Sepatu Sneaker'};

  void _toggleFavorite(_CatalogItem item) {
    final isFav = _favoriteItems.contains(item.name);
    setState(() {
      if (isFav) {
        _favoriteItems.remove(item.name);
      } else {
        _favoriteItems.add(item.name);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFav ? Icons.info_outline : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isFav ? 'Dihapus dari Favorit' : 'Ditambahkan ke Favorit',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: isFav
            ? const Color(0xFF424242)
            : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      current: AppTab.katalog,
      onNavigate: widget.onNavigate,
      title: 'Katalog Produk',
      backgroundColor: AppColors.catalogBackground,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
        tooltip: 'Menu',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Keranjang belanja masih kosong'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          },
          tooltip: 'Keranjang',
        ),
      ],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perlengkapan Kuliah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pilih tampilan daftar atau grid untuk melihat katalog.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<_CatalogLayout>(
                showSelectedIcon: false,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return Colors.white;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return const Color(0xFF374151);
                  }),
                  side: WidgetStateProperty.all(
                    BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                segments: const [
                  ButtonSegment(
                    value: _CatalogLayout.list,
                    label: Text('Daftar'),
                    icon: Icon(Icons.view_list_outlined),
                  ),
                  ButtonSegment(
                    value: _CatalogLayout.grid,
                    label: Text('Grid'),
                    icon: Icon(Icons.grid_view_outlined),
                  ),
                ],
                selected: {_layout},
                onSelectionChanged: (selection) {
                  setState(() => _layout = selection.first);
                },
              ),
            ),
          ),
          Expanded(
            child: _layout == _CatalogLayout.list
                ? ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    children: [
                      for (final item in _catalogItems)
                        _CatalogListItem(
                          item: item,
                          isFavorite: _favoriteItems.contains(item.name),
                          onToggleFavorite: () => _toggleFavorite(item),
                        ),
                    ],
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 1000
                          ? 4
                          : constraints.maxWidth >= 600
                          ? 3
                          : 2;

                      return GridView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 220,
                        ),
                        children: [
                          for (final item in _catalogItems)
                            _CatalogGridItem(
                              item: item,
                              isFavorite: _favoriteItems.contains(item.name),
                              onToggleFavorite: () => _toggleFavorite(item),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

enum _CatalogLayout { list, grid }

class _CatalogItem {
  const _CatalogItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    this.icon = Icons.shopping_bag_outlined,
  });

  final String name;
  final String description;
  final String price;
  final String image;
  final double rating;
  final IconData icon;
}

const _catalogItems = [
  _CatalogItem(
    name: 'Tas Ransel',
    description: 'Tas ransel ergonomis untuk membawa laptop dan buku.',
    price: 'Rp125.000',
    image: 'assets/image/backpack.jpg',
    rating: 4.5,
    icon: Icons.backpack_outlined,
  ),
  _CatalogItem(
    name: 'Sepatu Sneaker',
    description: 'Sepatu sneaker sporty dan nyaman dipakai harian.',
    price: 'Rp250.000',
    image: 'assets/image/sneaker.jpg',
    rating: 4.8,
    icon: Icons.roller_skating_outlined,
  ),
  _CatalogItem(
    name: 'Headphone',
    description: 'Headphone wireless over-ear suara jernih dan bass mantap.',
    price: 'Rp180.000',
    image: 'assets/image/headphone.jpg',
    rating: 4.6,
    icon: Icons.headphones_outlined,
  ),
  _CatalogItem(
    name: 'Smartwatch',
    description:
        'Jam tangan pintar dengan pemantau detak jantung & notifikasi.',
    price: 'Rp220.000',
    image: 'assets/image/smartwatch.jpg',
    rating: 4.7,
    icon: Icons.watch_outlined,
  ),
  _CatalogItem(
    name: 'Buku Catatan',
    description: 'Buku tulis tebal untuk mencatat materi kuliah.',
    price: 'Rp15.000',
    image: 'assets/image/notebook.jpg',
    rating: 4.5,
    icon: Icons.menu_book_outlined,
  ),
  _CatalogItem(
    name: 'Pulpen',
    description: 'Pulpen tinta hitam untuk kebutuhan harian.',
    price: 'Rp5.000',
    image: 'assets/image/pen.jpg',
    rating: 4.4,
    icon: Icons.edit_outlined,
  ),
  _CatalogItem(
    name: 'Pensil Mekanik',
    description: 'Pensil mekanik 0.5 mm untuk menulis dan menggambar.',
    price: 'Rp12.000',
    image: 'assets/image/pencil.jpg',
    rating: 4.6,
    icon: Icons.create_outlined,
  ),
  _CatalogItem(
    name: 'Highlighter',
    description: 'Stabilo untuk menandai poin penting.',
    price: 'Rp8.000',
    image: 'assets/image/highlighter.jpg',
    rating: 4.7,
    icon: Icons.border_color_outlined,
  ),
  _CatalogItem(
    name: 'Penggaris',
    description: 'Penggaris 30 cm presisi untuk alat tulis.',
    price: 'Rp4.000',
    image: 'assets/image/ruler.jpg',
    rating: 4.3,
    icon: Icons.straighten_outlined,
  ),
];

class _CatalogListItem extends StatelessWidget {
  const _CatalogListItem({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final _CatalogItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1.5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 64,
                height: 64,
                color: const Color(0xFFF3F4F6),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(item.icon, size: 32, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey.shade600,
              ),
              onPressed: onToggleFavorite,
              tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogGridItem extends StatelessWidget {
  const _CatalogGridItem({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final _CatalogItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(item.icon, size: 52, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 15, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey.shade600,
              ),
              onPressed: onToggleFavorite,
              tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
            ),
          ),
        ],
      ),
    );
  }
}
