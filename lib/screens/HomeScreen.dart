import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_list/services/auth_services.dart';
import '../constants.dart';

enum MenuOption { edit, delete }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts"), actions: [
        IconButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
            Navigator.popAndPushNamed(context, '/login-screen');
          },
          icon: const Icon(Icons.logout),
        )
      ]),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.watch<SharedPrefsModel>().email),
            trailing: PopupMenuButton<MenuOption>(
              onSelected: (menuItem) {
                if (menuItem == MenuOption.edit) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Contact'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Enter your name", labelText: "Name"),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Enter your phone number",
                                labelText: "Phone Number"),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            AuthService().updateUserContact(
                                context: context,
                                name: "pratty",
                                phone: 1234567890,
                                email: 'pratt1697@gmail.com');
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                } else {
                  showSnackBar(context, "Delete not allowed!");
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<MenuOption>(
                  value: MenuOption.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text("Edit item"),
                  ),
                ),
                PopupMenuItem<MenuOption>(
                  value: MenuOption.delete,
                  child: const ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete item"),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AuthService().updateUserContact(
              context: context,
              email: "pratt1697@gmail.com",
              name: "pratty",
              phone: 1234567890);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
