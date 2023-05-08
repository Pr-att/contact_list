import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_list/services/auth_services.dart';
import '../constants.dart';

enum MenuOption { edit, delete }

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                hintText: "Enter your name", labelText: "Name"),
                          ),
                          TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
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
                                name: nameController.text,
                                phone: int.parse(phoneController.text),
                                email: context
                                    .read<SharedPrefsModel>()
                                    .email
                                    .toString());
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
              email: context.read<SharedPrefsModel>().email.toString(),
              name: nameController.text,
              phone: int.parse(phoneController.text));
        },
        child: const Icon(Icons.logout),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
