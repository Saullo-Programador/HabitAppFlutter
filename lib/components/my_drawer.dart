
import 'package:flutter/material.dart';
import 'package:habitude_app/pages/setting_page.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Home List
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: ListTile(
                  title: Text(
                    "H O M E", 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Settings list
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage()
                      ),
                    );
                  },
                ),
              ),
              
            ],
          ),
      )
    );
  }
}