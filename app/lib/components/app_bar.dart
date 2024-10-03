import 'package:flutter/material.dart';

const appMenuItems = [
  {
    'title': 'বন্যার পর্যবেক্ষণ',
    'route': '/flood-monitor',
  },
  {
    'title': 'অপরাধ পর্যবেক্ষণ',
    'route': '/crime-monitor',
  },
  {
    'title': 'সেটিংস',
    'route': '/settings',
  },
];

class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const MyAppbar({super.key, required this.title});

  @override
  State<MyAppbar> createState() => _MyAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              for (var item in appMenuItems)
                PopupMenuItem(
                  value: item['route'],
                  child: Text(item['title']!),
                ),
            ],
            onSelected: (value) {},
            position: PopupMenuPosition.under,
          )
        ]);
  }
}
