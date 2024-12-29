import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web1/class/handlingdataview.dart';
import 'package:web1/features/home/controller/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsController controller = Get.put(NotificationsController());
    return GetBuilder(
        initState: (state) {
          controller.getNotification();
        },
        init: controller,
        builder: (controller) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: controller.notificationsList.isEmpty
                      ? const Center(child: Text('No notifications available.'))
                      : ListView.builder(
                          itemCount: controller.notificationsList.length,
                          itemBuilder: (context, index) {
                            final notification =
                                controller.notificationsList[index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: const Icon(Icons.notifications,
                                    color: Colors.blue),
                                title: Text(notification.content),
                                subtitle: Text(
                                  'Created: ${notification.createdAt}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                )),
          );
        });
  }
}
