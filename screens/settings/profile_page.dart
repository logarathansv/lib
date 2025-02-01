import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Mobile number related
  String selectedCountryCode = '+91';
  TextEditingController mobileController = TextEditingController();
  String? mobileError;
  List<Service> services = [];
  // Pricing related
  TextEditingController pricingController = TextEditingController();
  String selectedPricingUnit = 'Rs/hour';
  String selectedPricingUnit1 = 'Rs/hour';
  File? _profilePicture; // Holds the profile picture
  final ImagePicker _picker = ImagePicker();
  // Availability related
  Map<String, bool> daysSelected = {
    'M': false,
    'Tu': false,
    'W': false,
    'Th': false,
    'F': false,
    'Sa': false,
    'Su': false,
  };
  Map<String, TextEditingController> timingControllers = {
    'start': TextEditingController(),
    'end': TextEditingController(),
  };
  String startMeridian = 'AM';
  String endMeridian = 'AM';

  // File upload functionality
  String? uploadedFile;
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture =
            File(image.path); // Set the picked image as profile picture
      });
    }
  }

  void _removeProfilePicture() {
    setState(() {
      _profilePicture = null; // Remove the profile picture
    });
  }

  // Validate mobile number
  void validateMobileNumber() {
    setState(() {
      String number = mobileController.text.trim();
      mobileError = number.length == 10 && RegExp(r'^[0-9]+$').hasMatch(number)
          ? null
          : 'Please enter a valid 10-digit number';
    });
  }

  void CheckProfile() {
    if (_profilePicture == null) {
      _pickImage();
    } else {
      // If there's a profile picture, show options to delete or add a new one
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add options to delete or change the profile picture
              TextButton(
                onPressed: _pickImage,
                child: const Text('Change Picture'),
              ),
              TextButton(
                onPressed: _removeProfilePicture,
                child: const Text('Remove Picture'),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Open file picker
  void handleFileUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Only images allowed
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        uploadedFile = result.files.first.name; // Display selected file name
      });
    }
  }

  void addService() {
    setState(() {
      services.add(Service(
        description: '',
        pricing: '',
        unit: selectedPricingUnit1,
      ));
    });
  }

  // Remove a service
  void removeService(int index) {
    setState(() {
      services.removeAt(index);
    });
  }

  void editService(int index) {
    TextEditingController descriptionController =
        TextEditingController(text: services[index].description);
    TextEditingController pricingController =
        TextEditingController(text: services[index].pricing);
    ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit Service'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: descriptionController,
              placeholder: 'Service Description',
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: pricingController,
              placeholder: 'Pricing',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0xFF028F83),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedPricingUnit1,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    size: 18,
                  ), // Downward arrow icon for better UX
                ],
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text('Select Pricing Unit'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            selectedPricingUnit1 = 'Rs/hour'; // Update state
                          });
                          Navigator.pop(context); // Close action sheet
                        },
                        child: const Text('Per Hour'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            selectedPricingUnit1 = 'Rs/day'; // Update state
                          });
                          Navigator.pop(context); // Close action sheet
                        },
                        child: const Text('Per Day'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0xFF028F83),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    services[index].imagePath != ''
                        ? 'Change Image'
                        : 'Add Image',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 18,
                  ), // Downward arrow icon for better UX
                ],
              ),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    services[index].imagePath = pickedFile.path;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              setState(() {
                services[index].description = descriptionController.text;
                services[index].pricing = pricingController.text;
                services[index].unit = selectedPricingUnit1;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        leading: Padding(
            padding: const EdgeInsets.all(2),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF2F4757), size: 20),
            )),
        middle: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: 20,
            color: Color(0xFF2F4757),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => CheckProfile(),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF028F83),
                          backgroundImage: _profilePicture != null
                              ? FileImage(
                                  _profilePicture!) // Show the profile picture if selected
                              : null,
                          child: _profilePicture == null
                              ? const Icon(
                                  Icons.person_2_outlined,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : null, // Show icon only if no profile picture is set
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Parkinsans',
                            color: Color(0xFF2F4757),
                            decorationThickness: 0),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Service Area: New York, NY',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Parkinsans',
                            color: Color(0xFF028F83),
                            fontWeight: FontWeight.normal,
                            decorationThickness: 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Mobile Number Field
                const Text(
                  'Mobile Number',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF2F4757),
                      fontWeight: FontWeight.normal,
                      decorationThickness: 0),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.grey[200],
                      child: Text(selectedCountryCode,
                          style: const TextStyle(color: Color(0xFF028F83))),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Select Country Code'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => selectedCountryCode = '+91');
                                  Navigator.pop(context);
                                },
                                child: const Text('+91 (India)'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => selectedCountryCode = '+81');
                                  Navigator.pop(context);
                                },
                                child: const Text('+81 (Japan)'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CupertinoTextField(
                        controller: mobileController,
                        placeholder: 'Enter mobile number',
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF028F83)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onChanged: (_) => validateMobileNumber(),
                      ),
                    ),
                  ],
                ),
                if (mobileError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      mobileError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF2F4757),
                      fontWeight: FontWeight.normal,
                      decorationThickness: 0),
                ),
                const SizedBox(height: 5),
                CupertinoTextField(
                  placeholder: 'johndoe@example.com',
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF028F83)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  style: const TextStyle(color: Color(0xFF2F4757)),
                ),
                const SizedBox(height: 20),
                // Pricing Field
                const Text(
                  'Pricing',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF2F4757),
                      fontWeight: FontWeight.normal,
                      decorationThickness: 0),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: pricingController,
                        placeholder: 'Enter amount',
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF028F83)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: const Color(0xFF028F83),
                      child: Text(selectedPricingUnit),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Select Pricing Unit'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(
                                      () => selectedPricingUnit = 'Rs/hour');
                                  Navigator.pop(context);
                                },
                                child: const Text('Per Hour'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(
                                      () => selectedPricingUnit = 'Rs/day');
                                  Navigator.pop(context);
                                },
                                child: const Text('Per Day'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Availability',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2F4757),
                      decorationThickness: 0),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Wrap(
                    spacing: MediaQuery.of(context).size.width * 0.04,
                    children: daysSelected.keys.map((day) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          backgroundColor: daysSelected[day]!
                              ? const Color(0xFF028F83)
                              : const Color(0xFFF4C345), // Button color
                          minimumSize: const Size(40, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          elevation: 2,
                          alignment:
                              Alignment.center, // Shadow effect for elevation
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 18, // Font size (same as before)
                            color: Colors.white, // Text color
                          ),
                        ),
                        onPressed: () {
                          setState(
                              () => daysSelected[day] = !daysSelected[day]!);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Start Time
                    Expanded(
                      child: CupertinoTextField(
                        controller: timingControllers['start'],
                        placeholder: 'Start Time',
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF028F83)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton(
                      padding: const EdgeInsets.all(2),
                      color: const Color(0xFF028F83),
                      child: Text(startMeridian),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Select Meridian'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => startMeridian = 'AM');
                                  Navigator.pop(context);
                                },
                                child: const Text('AM'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => startMeridian = 'PM');
                                  Navigator.pop(context);
                                },
                                child: const Text('PM'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    // End Time
                    Expanded(
                      child: CupertinoTextField(
                        controller: timingControllers['end'],
                        placeholder: 'End Time',
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF028F83)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton(
                      padding: const EdgeInsets.all(2),
                      color: const Color(0xFF028F83),
                      child: Text(endMeridian),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('Select Meridian'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => endMeridian = 'AM');
                                  Navigator.pop(context);
                                },
                                child: const Text('AM'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(() => endMeridian = 'PM');
                                  Navigator.pop(context);
                                },
                                child: const Text('PM'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Services Provided',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF2F4757),
                      fontWeight: FontWeight.normal,
                      decorationThickness: 0),
                ),
                const SizedBox(height: 10),

                // Add Service Button
                ElevatedButton(
                  onPressed: addService,
                  child: const Text(
                    '+ Add Service',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2F4757),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Display Services List
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners for the card
                      ),
                      elevation:
                          5, // Shadow effect to make the card more prominent
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2F4757), // Border color
                            width: 2, // Border width
                          ),
                          color: Colors.white, // Card background color
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Service #${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Parkinsans',
                                        fontWeight: FontWeight
                                            .bold, // Bold for the title
                                        color: Color(0xFF2F4757),
                                      ),
                                    ),
                                  ),

                                  CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    color: Colors
                                        .transparent, // Button background color
                                    borderRadius: BorderRadius.circular(
                                        8), // Rounded corners for buttons
                                    child: const Icon(Icons.create_outlined,
                                        size: 18, color: Colors.black),
                                    onPressed: () => editService(index),
                                  ),
                                  const SizedBox(
                                      width: 5), // Space between the buttons
                                  CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    color: Colors
                                        .transparent, // Button background color
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Icon(Icons.close_outlined,
                                        size: 18, color: Colors.black),
                                    onPressed: () => removeService(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Description: ${services[index].description}',
                                style: const TextStyle(
                                    fontSize: 18, color: Color(0xFF555555)),
                              ),
                              Text(
                                'Pricing: ${services[index].pricing} ${services[index].unit}',
                                style: const TextStyle(
                                    fontSize: 18, color: Color(0xFF555555)),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // File Upload Section
                const Text(
                  'Portfolio or Certificates',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Parkinsans',
                      color: Color(0xFF2F4757),
                      fontWeight: FontWeight.normal,
                      decorationThickness: 0),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: handleFileUpload,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Upload here',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2F4757),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                if (uploadedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Uploaded: $uploadedFile',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF028F83),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Your save action
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Save',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xfff4c345),
                        padding: const EdgeInsets.all(10),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4), // Smaller curve
                        ), // Icon and Text color
                      ),
                    ),
                    const SizedBox(width: 10), // Space between the buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        // Your discard action
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text('Discard',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF036C7B),
                        padding: const EdgeInsets.all(10),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(4), // Smaller curve
                        ), // Icon and Text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on ImagePicker {
  getImage({required ImageSource source}) {}
}

class Service {
  String description;
  String pricing;
  String unit;
  String imagePath;

  Service({
    required this.description,
    required this.pricing,
    required this.unit,
    this.imagePath = '',
  });
}
