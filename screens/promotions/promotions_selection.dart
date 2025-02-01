import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sklyit_business/screens/promotions/select_customers.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  _PromotionsPageState createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  final TextEditingController messageController = TextEditingController();
  String? imageUrl;
  String? generatedImageUrl;
  bool isSMSSelected = false;

  List<PromotionType> selectedPromotions = [];

  void _viewImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(imagePath),
                fit: BoxFit.cover), // Use Image.file for local file paths
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: const Text(
          'Promotions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platforms ::',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildPromotionOption(
                PromotionType.sms, 'SMS', HugeIcons.strokeRoundedBubbleChat),
            _buildPromotionOption(PromotionType.whatsapp, 'WhatsApp',
                HugeIcons.strokeRoundedWhatsapp),
            _buildPromotionOption(PromotionType.sklyIt, 'Skly It',
                HugeIcons.strokeRoundedCheckmarkCircle01),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                labelText: 'Promotion Message',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMagicWand03,
                    color: Colors.deepPurple,
                    size: 24.0,
                  ),
                  onPressed: () {
                    _enhanceMessage();
                  },
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            if (!isSMSSelected) _buildImageUploadSection(),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xfff4c345)),
                ),
                label: const Text(
                  'Promote',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: _promote,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionOption(
      PromotionType type, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedPromotions.contains(type)) {
            selectedPromotions.remove(type);
          } else {
            selectedPromotions.add(type);
          }
          if (selectedPromotions.contains(PromotionType.sms) &&
              selectedPromotions.length == 1) {
            isSMSSelected = true;
          } else if (selectedPromotions.contains(PromotionType.sms) &&
              selectedPromotions.length != 1) {
            isSMSSelected = false;
          } else
            isSMSSelected = false;
        });
      },
      child: Card(
        elevation: 4,
        color: selectedPromotions.contains(type)
            ? const Color(0xFF2f4757)
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon,
                  size: 30,
                  color:
                      selectedPromotions.contains(type) ? Colors.white : null),
              const SizedBox(width: 16),
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      color: selectedPromotions.contains(type)
                          ? Colors.white
                          : null)),
              const Spacer(),
              Icon(Icons.check,
                  color: selectedPromotions.contains(type)
                      ? Colors.white
                      : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (imageUrl != null)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _viewImage(context, imageUrl!),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'View Image',
                                style: TextStyle(
                                  color: Color(0xFF028F83),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 10),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedView,
                                color: Colors.black,
                                size: 24.0,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () => setState(() => imageUrl = null),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const HugeIcon(
                              icon: HugeIcons.strokeRoundedDelete02,
                              color: Colors.red,
                              size: 22.0,
                            ))
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _uploadImage,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color(0xFF2f4757)),
                    child: Text('Upload Image',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 5),
                  const Text('OR',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _generateImage,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color(0xFF2f4757)),
                    child: Text('Generate Image',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ])),
        if (generatedImageUrl != null)
          Image.network(generatedImageUrl!, height: 150, fit: BoxFit.cover),
      ],
    );
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Open gallery to pick an image

    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Use the path of the picked file
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image uploaded!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected.')));
    }
  }

  void _generateImage() {
    setState(() {
      //Generate Image Logic here
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Image generated!')));
  }

  void _enhanceMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Message enhanced!')));
  }

  void _promote() {
    String message = messageController.text;
    List<HugeIcon> icons = [];
    if (selectedPromotions.contains(PromotionType.sms)) {
      icons.add(const HugeIcon(
        icon: HugeIcons.strokeRoundedBubbleChat,
        color: Colors.black,
        size: 24.0,
      ));
    }
    if (selectedPromotions.contains(PromotionType.whatsapp)) {
      icons.add(const HugeIcon(
        icon: HugeIcons.strokeRoundedWhatsapp,
        color: Colors.black,
        size: 24.0,
      ));
    }
    if (selectedPromotions.contains(PromotionType.sklyIt)) {
      icons.add(const HugeIcon(
        icon: HugeIcons.strokeRoundedCheckmarkCircle01,
        color: Colors.black,
        size: 24.0,
      ));
    }
    if (selectedPromotions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a promotion method.')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectCustomersPage(
                platformIcons: icons,
              )),
    );
  }
}

enum PromotionType { sms, whatsapp, sklyIt }
