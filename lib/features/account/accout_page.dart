import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/theme/theme.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/features/post/widgets/account_post_list.dart';

Widget _buildStatItem(String count, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}

Widget _buildDivider() {
  return SizedBox(
    height: 30,
    child: VerticalDivider(
      color: Colors.white54,
      thickness: 1,
      width: 30,
    ),
  );
}

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const AccountPage(),
      );

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final DraggableScrollableController _controller = DraggableScrollableController();
  bool _isExpanded = false;

  void _toggleSheet() async {
    final targetSize = _isExpanded ? 0.3 : 0.85;
    setState(() => _isExpanded = !_isExpanded);
    await _controller.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    final currentUserAccount = ref.watch(currentUserAccountProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 3D Model Background
          const Positioned.fill(
            child: ModelViewer(
              src: 'assets/models/hatsune_miku_colorfull_stage_the_movie_ver2.glb',
              alt: "A 3D background model",
              autoRotate: true,
              cameraControls: true,
              disableZoom: true,
              ar: false,
              backgroundColor: Colors.transparent,
            ),
          ),

          // Draggable scrollable sheet over the 3D background
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Pallete.darkGreyColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggleSheet,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: currentUserAsync.when(
                        data: (user) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: user?.profilePic.isNotEmpty == true
                                        ? NetworkImage(user!.profilePic)
                                        : null,
                                    child: user?.profilePic.isEmpty == true
                                        ? const Icon(Icons.person, size: 50)
                                        : null,
                                  ),
                                  _buildStatItem(user?.followers.length.toString() ?? '0', 'Followers'),
                                  _buildDivider(),
                                  _buildStatItem(user?.following.length.toString() ?? '0', 'Following'),
                                  _buildDivider(),
                                  _buildStatItem(user?.level.toString() ?? '1', 'Level'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? 'No name',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user?.bio.isNotEmpty == true) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      user!.bio,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const Text(
                              'Recent Posts',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            AccountPostList()
                          ],
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text('Error: $e')),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


