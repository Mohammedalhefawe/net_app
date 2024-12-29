import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web1/constants/icons_svg.dart';
import 'package:web1/services/auth_service.dart';

class InfoSectionWidget extends StatelessWidget {
  final bool showStorageInfo;
  const InfoSectionWidget({
    super.key,
    this.showStorageInfo = true,
  });

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final token = prefs.getString('auth_token') ?? '';

    if (userId == null) {
      throw Exception('User ID not found');
    }

    final ApiService apiService = ApiService();
    return await apiService.getUserInfo(userId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userData = snapshot.data!['data'];

              return ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: SvgPicture.string(
                        userIcon,
                        width: 20,
                        height: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(userData['name'] ?? 'N/A'),
                    subtitle: Text(
                      userData['email'] ?? 'N/A',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  if (showStorageInfo)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'storage_info'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.grey[300],
                          color: Theme.of(context).primaryColor,
                          minHeight: 8,
                        ),
                        const SizedBox(height: 5),
                        const Text('70% of 100GB used'),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey[300], thickness: 0.5),
                            const SizedBox(height: 10),
                            ListTile(
                              contentPadding:
                                  const EdgeInsetsDirectional.only(start: 0),
                              leading: SvgPicture.string(
                                fileIcon,
                                width: 20,
                                height: 20,
                                color: Colors.amber,
                              ),
                              title: Text('files'.tr),
                              trailing: const Text('32 MB'),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsetsDirectional.only(start: 0),
                              leading: SvgPicture.string(
                                imageIcon,
                                width: 20,
                                height: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text('images'.tr),
                              trailing: const Text('32 MB'),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsetsDirectional.only(start: 0),
                              leading: SvgPicture.string(
                                videoIcon,
                                width: 20,
                                height: 20,
                                color: Colors.blue,
                              ),
                              title: Text('videos'.tr),
                              trailing: const Text('32 MB'),
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsetsDirectional.only(start: 0),
                              leading: SvgPicture.string(
                                otherIcon,
                                width: 20,
                                height: 20,
                                color: Colors.red,
                              ),
                              title: Text('others'.tr),
                              trailing: const Text('32 MB'),
                            ),
                          ],
                        )
                      ],
                    )
                ],
              );
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }
}
