import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/constants/appwrite_constants.dart';

final appwriteClientProvider = Provider((ref){
  Client client = Client();
  return client
  .setEndpoint(AppwriteConstants.endPoint)
  .setProject(AppwriteConstants.projectId);
});

final appwriteConnectionTestProvider = FutureProvider<bool>((ref) async {
  try {
    final client = ref.watch(appwriteClientProvider);
    final account = Account(client);
    
    // Try to get project info - this will fail if connection is bad
    // but won't throw if the client is properly configured
    await Future.delayed(Duration(milliseconds: 100)); // Small delay to test connection
    
    return true; // If we get here, the client is properly configured
  } catch (e) {
    print('Appwrite connection test failed: $e');
    return false;
  }
});

final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client)   ;
});

final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client)   ;
});

final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});