import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const AccountPage(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    final currentUserAccount = ref.watch(currentUserAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authController = ref.read(authControllerProvider.notifier);
              authController.logoutAndNavigate(context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (currentUser) {
          if (currentUser == null) {
            return currentUserAccount.when(
              data: (account) => account == null
                ? const Center(
                    child: Text('Please log in to view your account'),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Center(
                child: Text('Please log in to view your account'),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(currentUser.profilePic),
                  radius: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  'Name: ${currentUser.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${currentUser.email}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Bio: ${currentUser.bio}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}