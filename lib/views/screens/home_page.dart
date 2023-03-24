import 'package:adv_11_am_firebase_app/helpers/firebase_auth_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/firestore_helper.dart';
import 'package:adv_11_am_firebase_app/helpers/local_notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String? name;
  int? contact;
  String? email;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    LocalNotificationHelper.localNotificationHelper.initNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CircleAvatar(
                radius: 80,
                foregroundImage: (user.photoURL != null)
                    ? NetworkImage(user.photoURL as String)
                    : null),
            const Divider(),
            (user.isAnonymous)
                ? Container()
                : (user.displayName == null)
                    ? Container()
                    : Text("Username: ${user.displayName}"),
            (user.isAnonymous) ? Container() : Text("Email: ${user.email}"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .sendSimpleNotification();
                },
                child: const Text("Simple Notification"),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalNotificationHelper.localNotificationHelper
                      .sendScheduledNotification();
                },
                child: const Text("Scheduled Notification"),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalNotificationHelper.localNotificationHelper
                      .sendBigPictureNotification();
                },
                child: const Text("Big Picture Notification"),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  LocalNotificationHelper.localNotificationHelper
                      .sendMediaStyleNotification();
                },
                child: const Text("Media Style Notification"),
              ),
            ],
          ),
        ),
        // child: StreamBuilder(
        //   stream: FireStoreHelper.fireStoreHelper.getUser(),
        //   builder: (context, snapShots) {
        //     if (snapShots.hasError) {
        //       return Center(
        //         child: Text("Error: ${snapShots.error}"),
        //       );
        //     } else if (snapShots.hasData) {
        //       List data = snapShots.data!.docs;
        //
        //       return ListView.builder(
        //         itemCount: data.length,
        //         itemBuilder: (context, index) => ExpansionTile(
        //           title: Text(data[index]['name']),
        //           subtitle: Text(
        //               "Email: ${data[index]['email']}\nContact: ${data[index]['contact']}"),
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 ElevatedButton.icon(
        //                   onPressed: () {
        //                     Map<Object, Object> updatedValue = {
        //                       'name': data[index]['name'],
        //                       'email': data[index]['email'],
        //                       'contact': data[index]['contact'],
        //                     };
        //
        //                     showDialog(
        //                       context: context,
        //                       builder: (context) => AlertDialog(
        //                         title: const Text("Edit user"),
        //                         content: Form(
        //                           key: updateFormKey,
        //                           child: Column(
        //                             mainAxisSize: MainAxisSize.min,
        //                             children: [
        //                               TextFormField(
        //                                 validator: (val) {
        //                                   if (val!.isEmpty) {
        //                                     return "Please Enter name...";
        //                                   } else {
        //                                     return null;
        //                                   }
        //                                 },
        //                                 onSaved: (val) {
        //                                   updatedValue['name'] = val as Object;
        //                                 },
        //                                 textInputAction: TextInputAction.next,
        //                                 initialValue: data[index]['name'],
        //                                 decoration: InputDecoration(
        //                                   border: OutlineInputBorder(),
        //                                 ),
        //                               ),
        //                               TextFormField(
        //                                 validator: (val) {
        //                                   if (val!.isEmpty) {
        //                                     return "Please Enter email...";
        //                                   } else {
        //                                     return null;
        //                                   }
        //                                 },
        //                                 onSaved: (val) {
        //                                   updatedValue['email'] = val as Object;
        //                                 },
        //                                 textInputAction: TextInputAction.next,
        //                                 initialValue: data[index]['email'],
        //                                 decoration: InputDecoration(
        //                                   border: OutlineInputBorder(),
        //                                 ),
        //                               ),
        //                               TextFormField(
        //                                 validator: (val) {
        //                                   if (val!.isEmpty) {
        //                                     return "Please Enter contact...";
        //                                   } else {
        //                                     return null;
        //                                   }
        //                                 },
        //                                 onSaved: (val) {
        //                                   updatedValue['contact'] =
        //                                       int.parse(val!);
        //                                 },
        //                                 keyboardType: TextInputType.phone,
        //                                 inputFormatters: [
        //                                   FilteringTextInputFormatter
        //                                       .digitsOnly,
        //                                 ],
        //                                 textInputAction: TextInputAction.done,
        //                                 onFieldSubmitted: (val) {
        //                                   if (updateFormKey.currentState!
        //                                       .validate()) {
        //                                     updateFormKey.currentState!.save();
        //
        //                                     print(
        //                                         "================================");
        //                                     print("${data[index]['id']}");
        //                                     print(
        //                                         "================================");
        //
        //                                     FireStoreHelper.fireStoreHelper
        //                                         .editUser(
        //                                             id: data[index]['id']
        //                                                 .toString(),
        //                                             data: updatedValue);
        //
        //                                     Navigator.pop(context);
        //                                   }
        //                                 },
        //                                 initialValue:
        //                                     data[index]['contact'].toString(),
        //                                 decoration: InputDecoration(
        //                                   border: OutlineInputBorder(),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                   label: const Text("Edit"),
        //                   icon: const Icon(Icons.edit),
        //                 ),
        //                 ElevatedButton.icon(
        //                   onPressed: () {
        //                     FireStoreHelper.fireStoreHelper
        //                         .removeRecord(id: data[index]['id']);
        //                   },
        //                   label: const Text("Delete"),
        //                   icon: const Icon(Icons.delete),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //     return const Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add user"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (val) =>
                          (val!.isEmpty) ? "Please enter name" : null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Name"),
                      onSaved: (val) => name = val!,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      validator: (val) =>
                          (val!.isEmpty) ? "Please enter email" : null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Email"),
                      onSaved: (val) => email = val!,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      validator: (val) =>
                          (val!.isEmpty) ? "Please enter contact" : null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Contact"),
                      onSaved: (val) => contact = int.parse(val!),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (val) async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          await FireStoreHelper.fireStoreHelper.addUser(
                            name: name!,
                            email: email!,
                            contact: contact!,
                          );

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
