import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<Map<String, dynamic>> {
  UserNotifier() : super({});

  void setUser(
      {required String id,
      required String name,
      required String email,
      String? phone,
      String? address,
      String? imageUrl,
      bool? isAdmin}) {
    state = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone ?? "",
      'address': address ?? "",
      'image_url': imageUrl ?? "",
      'isAdmin': isAdmin ?? false
    };
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, Map<String, dynamic>>((ref) {
  return UserNotifier();
});
