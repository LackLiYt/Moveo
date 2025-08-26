import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:moveo/features/account/edit_character_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/theme/theme.dart';
import 'package:moveo/features/post/widgets/account_post_list.dart';

class ModelCache {
  static String selectedModelPath = 'assets/models/Duck.glb';
}

Widget _buildStatItem(String count, String label, BuildContext context) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

Widget _buildDivider(BuildContext context) {
  final theme = Theme.of(context);
  return SizedBox(
    height: 30,
    child: VerticalDivider(
      color: theme.dividerColor,
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
  String _selectedModelPath = 'assets/models/Duck.glb';
  final DraggableScrollableController _controller = DraggableScrollableController();
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _selectedModelPath = ModelCache.selectedModelPath;
  }

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
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    final currentUserAccount = ref.watch(currentUserAccountProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // 3D Model Background
          Positioned.fill(
            child: ModelViewer(
              key: ValueKey(_selectedModelPath),
              src: _selectedModelPath,
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
                  color: theme.scaffoldBackgroundColor,
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
                                  color: theme.dividerColor,
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
                                        ? Icon(Icons.person, size: 50, color: theme.iconTheme.color)
                                        : null,
                                  ),
                                  _buildStatItem(user?.followers.length.toString() ?? '0', 'Followers', context),
                                  _buildDivider(context),
                                  _buildStatItem(user?.following.length.toString() ?? '0', 'Following', context),
                                  _buildDivider(context),
                                  _buildStatItem(user?.level.toString() ?? '1', 'Level', context),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const EditCharacterPage()),
                                  );

                                  if (result != null && result is String) {
                                    setState(() {
                                      _selectedModelPath = result;
                                      ModelCache.selectedModelPath = result;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.blueColor,
                                  foregroundColor: Pallete.whiteColor,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadowColor: Pallete.blueColor.withOpacity(0.3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit, color: Pallete.whiteColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Customize Character",
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: Pallete.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? 'No name',
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (user?.bio.isNotEmpty == true) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      user!.bio,
                                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(color: theme.dividerColor),
                            Text(
                              'Recent Posts',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            AccountPostList()
                          ],
                        ),
                        loading: () => Center(child: CircularProgressIndicator(color: theme.primaryColor)),
                        error: (e, st) => Center(child: Text('Error: $e', style: theme.textTheme.bodyMedium)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor, size: 28),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


