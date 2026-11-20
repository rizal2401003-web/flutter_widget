import 'package:flutter/material.dart';

import 'navigation.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.current,
    required this.onNavigate,
    required this.child,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
  });

  final int current;
  final ValueChanged<int> onNavigate;
  final Widget child;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title ?? appDestinations[current].title),
        leading: leading ??
            (Navigator.canPop(context)
                ? IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Kembali',
                  )
                : null),
        actions: actions,
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: current,
        onDestinationSelected: (index) {
          if (index != current) {
            onNavigate(index);
          }
        },
        destinations: [
          for (final destination in appDestinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}
