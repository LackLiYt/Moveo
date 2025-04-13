import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/constants/constants.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/theme/pallete.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  void onPickImages() async {
    await pickMultiImages();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    final currentUserAccount = ref.watch(currentUserAccountProvider);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
           icon: const Icon(Icons.close, size: 30,)
           ),
           actions: [
            RoundedSmallButton(onTap: () {},
             label: 'Post')
           ],
      ),
      body: currentUserAsync.when(
        data: (currentUser) {
          if (currentUser == null) {
            return currentUserAccount.when(
              data: (account) => account == null
                ? const Center(
                    child: Text('Please log in to create a post'),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Center(
                child: Text('Please log in to create a post'),
              ),
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.profilePic),
                        radius: 30,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: postTextController,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Write something fun!",
                            hintStyle: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                  if(images.isNotEmpty)
                  CarouselSlider(
                    items: images
                    .map(
                      (file) { return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Image.file(file));},
                   )
                   .toList(),
                   options: CarouselOptions(
                    height: 400,
                    enableInfiniteScroll: false,
                   )
                   ),
                ],
              ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            )
          )
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector( 
                onTap: onPickImages ,
                child: SvgPicture.asset(AssetsConstants.SearchIcon)),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.UpIcon),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.DownIcon),
            )
          ],
        ),
      ),
    );
  }
}