import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class EditCharacterPage extends StatefulWidget {
  const EditCharacterPage({super.key});

  @override
  State<EditCharacterPage> createState() => _EditCharacterPageState();
}

class _EditCharacterPageState extends State<EditCharacterPage> {
  final List<String> characterModels = [
    'assets/models/Duck.glb',
    'assets/models/hatsune_miku_colorfull_stage_the_movie_ver2.glb',
    'assets/models/chicken_little_rig_mixamo_v2.glb',
  ];

  int selectedModelIndex = 0;

  void _saveChanges() {
    Navigator.pop(context, characterModels[selectedModelIndex]);
  }

  void _cancelChanges() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Character"),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _cancelChanges,
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 3D Model
          Expanded(
            child: ModelViewer(
              key: ValueKey(characterModels[selectedModelIndex]),
              src: characterModels[selectedModelIndex],
              alt: "3D Character",
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),

          // Divider between model and buttons
          const Divider(
            color: Colors.white24,
            height: 1,
            thickness: 1,
          ),

          const SizedBox(height: 12),

          // Horizontal list of model buttons
          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SizedBox(
    height: 100,
    child: Center( // <--- Center the ListView itself
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: characterModels.length,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: selectedModelIndex == index
                  ? Colors.blueAccent
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedModelIndex = index;
                });
              },
              child: Center(
                child: Text(
                  'Model ${index + 1}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    ),
  ),
),


          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
