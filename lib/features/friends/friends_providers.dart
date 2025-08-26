import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../../apis/friend_service.dart';
import '../../models/friend.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../core/providers.dart';

final friendServiceProvider = Provider<FriendService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return FriendService(client);
});

final friendsProvider = FutureProvider<List<Friend>>((ref) async {
  final friendService = ref.watch(friendServiceProvider);
  final currentUser = await ref.watch(currentUserAccountProvider.future);
  if (currentUser == null) return [];
  return friendService.getFriends(currentUser.$id);
});

final pendingRequestsProvider = FutureProvider<List<Friend>>((ref) async {
  final friendService = ref.watch(friendServiceProvider);
  final currentUser = await ref.watch(currentUserAccountProvider.future);
  if (currentUser == null) return [];
  return friendService.getPendingRequests(currentUser.$id);
}); 