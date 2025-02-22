import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:sklyit_business/api/register/register_business_api.dart';
import 'package:sklyit_business/screens/auth/register_screen.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'LoginPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage();

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final apiService = RegisterBusiness();

  // Controllers
  TextEditingController clientNameController = TextEditingController();
  TextEditingController domainNameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopDescController = TextEditingController();
  TextEditingController shopEmailController = TextEditingController();
  TextEditingController shopMobileController = TextEditingController();
  TextEditingController shopOpenTimeController = TextEditingController();
  TextEditingController shopClosingTimeController = TextEditingController();
  final mainTagController = StringTagController();
  final subTagController = StringTagController();
  List<String> mainTags = [];
  List<String> subTags = [];
  List<Map<String, TextEditingController>> addresses = [];
  final storage = FlutterSecureStorage();

  bool isDomainAvailable = false;
  bool isDomainChecked = false;

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final mobileRegex = RegExp(r'^[0-9]{10}$');
  final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):([0-5][0-9])$');

  @override
  void dispose() {
    clientNameController.dispose();
    domainNameController.dispose();
    shopNameController.dispose();
    shopDescController.dispose();
    shopEmailController.dispose();
    shopMobileController.dispose();
    shopOpenTimeController.dispose();
    shopClosingTimeController.dispose();
    mainTags.clear();
    subTags.clear();
    addresses.clear();
    super.dispose();
  }

  void addMainTag(String tag) {
    if (tag.isNotEmpty && !mainTags.contains(tag) && mainTags.length < 2) {
      setState(() {
        mainTags.add(tag);
      });
    }
    print(mainTags);
  }
  void addSubTag(String tag) {
    if (tag.isNotEmpty && !subTags.contains(tag) && subTags.length < 9) {
      setState(() {
        subTags.add(tag);
      });
    }
    print(subTags);
  }

  Future<void> checkDomainAvailability(String domain) async {
    if (domain.isEmpty) return;

    final response = await apiService.checkDomain('$domain.com');
    setState(() {
      isDomainAvailable = false;
      isDomainChecked = true;
    });
    print(response);
    if (response == "true") {
      setState(() {
        isDomainAvailable = true;
        isDomainChecked = true;
      });
    }

    print("Domain Available: $isDomainAvailable");
  }

  void addAddress() {
    setState(() {
      addresses.add({
        "street": TextEditingController(),
        "city": TextEditingController(),
        "district": TextEditingController(),
        "state": TextEditingController(),
        "pincode": TextEditingController(),
      });
    });
    print(addresses);
  }

  // Remove an address field dynamically
  void removeAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }

  Future<void> pickTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        controller.text = convertTo24HourFormat(pickedTime);
      });
    }
  }

  // Converts TimeOfDay to 24-hour format (HH:mm)
  String convertTo24HourFormat(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes"; // Format as HH:mm
  }

  List<Map<String, String>> getFormattedAddresses() {
    return addresses.map((address) {
      return {
        "street": address["street"]!.text,
        "city": address["city"]!.text,
        "district": address["district"]!.text,
        "state": address["state"]!.text,
        "pincode": address["pincode"]!.text,
      };
    }).toList();
  }

  Future<void> registerBusiness() async {
    final userId = await storage.read(key: 'userId');
    if (_formKey.currentState!.validate()) {
      final data = {
        'Clientname': clientNameController.text,
        'domainname': '${domainNameController.text}.com',
        'shopname': shopNameController.text,
        'shopdesc': shopDescController.text,
        'shopemail': shopEmailController.text,
        'shopmobile': shopMobileController.text,
        'shopOpenTime': shopOpenTimeController.text,
        'shopClosingTime': shopClosingTimeController.text,
        'addresses' : getFormattedAddresses(),
        'BusinessMainTags': mainTags,
        'BusinessSubTags': subTags,
        'userId': userId
      };

      try {
        final response = await apiService.registerBusiness(data);
        print(response);
        if (response == 'Business Registered Successfully') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response),
              backgroundColor: Colors.teal.shade700,
            ),
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route)=>false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff4c345),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: ()  {
            Navigator.of(context).pop();
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft03,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        title: Text(
          'Register Business',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2f4757),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField("Business Name", clientNameController),
                buildDomainField(),
                buildTextField("Shop Name", shopNameController),
                buildTextField("Shop Description", shopDescController),
                buildTextField("Shop Email", shopEmailController, keyboardType: TextInputType.emailAddress),
                buildTextField("Shop Mobile", shopMobileController, keyboardType: TextInputType.phone),
                buildTimePickerField("Opening Time (HH:mm)", shopOpenTimeController),
                buildTimePickerField("Closing Time (HH:mm)", shopClosingTimeController),
                Text(
                  'Main Tags',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF028F83),
                  ),
                ),
                TextFieldTags<String>(
                  textfieldTagsController: mainTagController,
                  initialTags: mainTags,
                  textSeparators: const [' ', ','],
                  validator: (String tag) {
                    if(tag.length > 10) {
                      return 'Max length is 10 characters';
                    }
                    if (mainTags.length < 2) {
                      addMainTag(tag); // Add main tag when it's valid
                    }
                    else {
                      return 'You can add only 2 main tags';
                    }
                    return null;
                  },
                  inputFieldBuilder: (context, inputFieldValues) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        onTap: () {
                          mainTagController.getFocusNode?.requestFocus();
                        },
                        controller: inputFieldValues.textEditingController,
                        focusNode: inputFieldValues.focusNode,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF028F83),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF028F83),
                            ),
                          ),
                          hintText: inputFieldValues.tags.isNotEmpty
                              ? ''
                              : "Enter main tags",
                          errorText: inputFieldValues.error,
                          prefixIcon: inputFieldValues.tags.isNotEmpty
                              ? SingleChildScrollView(
                            controller: inputFieldValues.tagScrollController,
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 8,
                              ),
                              child: Wrap(
                                  runSpacing: 4.0,
                                  spacing: 4.0,
                                  children:
                                  inputFieldValues.tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color:
                                        Color(0xFF028F83),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                              mainTags.remove(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                            ),
                          )
                              : null,
                        ),
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Sub Tags',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF028F83),
                  ),
                ),
                SizedBox(height: 10),
                TextFieldTags<String>(
                  textfieldTagsController: subTagController,
                  initialTags: subTags,
                  textSeparators: const [' ', ','],
                  validator: (String tag) {
                    if(tag.length > 10) {
                      return 'Max length is 10 characters';
                    }
                    if (subTags.length < 9) {
                      addSubTag(tag);
                    }
                    else {
                      return 'You can add only 10 sub tags';
                    }
                    return null;
                  },
                  inputFieldBuilder: (context, inputFieldValues) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        onTap: () {
                          subTagController.getFocusNode?.requestFocus();
                        },
                        controller: inputFieldValues.textEditingController,
                        focusNode: inputFieldValues.focusNode,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF028F83),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF028F83),
                            ),
                          ),
                          hintText: inputFieldValues.tags.isNotEmpty
                              ? ''
                              : "Enter sub tags",
                          errorText: inputFieldValues.error,
                          prefixIcon: inputFieldValues.tags.isNotEmpty
                              ? SingleChildScrollView(
                            controller: inputFieldValues.tagScrollController,
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 8,
                              ),
                              child: Wrap(
                                  runSpacing: 4.0,
                                  spacing: 4.0,
                                  children:
                                  inputFieldValues.tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color:
                                        Color(0xFF028F83),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              //print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                              subTags.remove(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                            ),
                          )
                              : null,
                        ),
                        onChanged: inputFieldValues.onTagChanged,
                        onSubmitted: inputFieldValues.onTagSubmitted,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text("Addresses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...addresses.asMap().entries.map((entry) {
                  int index = entry.key;
                  var address = entry.value;
                  return Column(
                    children: [
                      buildTextField("Street", address["street"]!),
                      buildTextField("City", address["city"]!),
                      buildTextField("District", address["district"]!),
                      buildTextField("State", address["state"]!),
                      buildTextField("Pincode", address["pincode"]!, keyboardType: TextInputType.number),
                      ElevatedButton(
                        onPressed: () => removeAddress(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 8,
                        ),
                        child: Text("Remove Address", style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: addAddress,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text("Add Address", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        await registerBusiness();
                      }
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                      color: Colors.amber,
                      size: 24.0,
                    ),
                    label: Text("Register", style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      shadowColor: Colors.amber,
                      elevation: 8,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedEdit02, color: Colors.grey, size: 20.0),
        ),
        keyboardType: keyboardType,
        validator: (text) => text!.isEmpty ? "$label is required" : null,
      ),
    );
  }

  Widget buildDomainField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: domainNameController,
        decoration: InputDecoration(
          labelText: "Domain Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedEdit02, color: Colors.grey, size: 20.0),
          suffixIcon: isDomainChecked
              ? Icon(
            !isDomainAvailable ? Icons.check_circle : Icons.cancel,
            color: !isDomainAvailable ? Colors.green : Colors.red,
          )
              : null,
        ),
        onChanged: (value) {
          setState(() => isDomainChecked = false);
          Future.delayed(Duration(milliseconds: 500), () {
            checkDomainAvailability(value.trim());
          });
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) return "Domain name is required";
          if (isDomainAvailable) return "Domain name is not available";
          return null;
        },      ),
    );
  }

  Widget buildTimePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () => pickTime(context, controller),
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) return "Please select a valid time";
          return null;
        },
      ),
    );
  }
}
