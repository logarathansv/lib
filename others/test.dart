import 'package:flutter/material.dart';

void main() {
  runApp(const SklyitApp());
}

class SklyitApp extends StatefulWidget {
  const SklyitApp({super.key});

  @override
  _SklyitAppState createState() => _SklyitAppState();
}

class _SklyitAppState extends State<SklyitApp> {
  Color _themeColor = Colors.amberAccent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sklyit - Business Page',
      theme: ThemeData(
        primaryColor: _themeColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          headlineLarge: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: PersonalCareBusinessPage(
        onThemeColorChanged: (color) {
          setState(() {
            _themeColor = color;
          });
        },
      ),
    );
  }
}

// Main business page with customizable elements
class PersonalCareBusinessPage extends StatefulWidget {
  final Function(Color) onThemeColorChanged;

  const PersonalCareBusinessPage(
      {super.key, required this.onThemeColorChanged});

  @override
  _PersonalCareBusinessPageState createState() =>
      _PersonalCareBusinessPageState();
}

class _PersonalCareBusinessPageState extends State<PersonalCareBusinessPage> {
  int _currentIndex = 0;
  bool _isEditMode = false;

  String _welcomeMessage = 'Welcome to Our Personal Care Shop';
  String _description =
      'Discover our range of premium services crafted just for you!';
  final List<String> _services = [
    "Hair Styling",
    "Facial Treatments",
    "Massage Therapy"
  ];

  // Pages for BottomNavigationBar
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ShowcaseSection(),
      const Center(child: Text("Orders Section")),
      const ProfilePage(),
      SettingsPage(
        onThemeColorChanged: (color) {
          widget.onThemeColorChanged(color);
        },
      ),
    ];
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _addService() {
    setState(() {
      _services.add("New Service");
    });
  }

  void _confirmDeleteService(int index) async {
    final bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
        ],
      ),
    );

    if (deleteConfirmed == true) {
      setState(() {
        _services.removeAt(index);
      });
    }
  }

  Future<String?> _showEditDialog(
      BuildContext context, String initialText) async {
    TextEditingController controller = TextEditingController(text: initialText);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new text'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Digital Shop',
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.save : Icons.edit,
                color: Colors.white),
            tooltip:
                _isEditMode ? 'Save Customizations' : 'Customize Your Page',
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isEditMode
                        ? () async {
                            final newMessage =
                                await _showEditDialog(context, _welcomeMessage);
                            if (newMessage != null) {
                              setState(() => _welcomeMessage = newMessage);
                            }
                          }
                        : null,
                    child: Container(
                      decoration: _isEditMode
                          ? BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : null,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _welcomeMessage,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isEditMode
                        ? () async {
                            final newDescription =
                                await _showEditDialog(context, _description);
                            if (newDescription != null) {
                              setState(() => _description = newDescription);
                            }
                          }
                        : null,
                    child: Container(
                      decoration: _isEditMode
                          ? BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : null,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _description,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _services.length + (_isEditMode ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isEditMode && index == _services.length) {
                          return IconButton(
                            icon: Icon(Icons.add_circle,
                                color: Theme.of(context).primaryColor,
                                size: 40),
                            onPressed: _addService,
                          );
                        }
                        return GestureDetector(
                          onTap: _isEditMode
                              ? () async {
                                  final newService = await _showEditDialog(
                                      context, _services[index]);
                                  if (newService != null) {
                                    setState(
                                        () => _services[index] = newService);
                                  }
                                }
                              : null,
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                _services[index],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              trailing: _isEditMode
                                  ? IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _confirmDeleteService(index),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Sample Showcase Section (Shop page)
class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Welcome to the Shop Section!"));
  }
}

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _emailController =
      TextEditingController(text: 'johndoe@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+1 234 567 890');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(height: 16),
          _buildProfileField('Name', _nameController),
          const SizedBox(height: 16),
          _buildProfileField('Email', _emailController),
          const SizedBox(height: 16),
          _buildProfileField('Phone', _phoneController),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}

// Settings Page with Theme Color Change
class SettingsPage extends StatefulWidget {
  final Function(Color) onThemeColorChanged;

  const SettingsPage({super.key, required this.onThemeColorChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        SwitchListTile(
          title: const Text('Dark Theme'),
          value: _darkThemeEnabled,
          onChanged: (value) {
            setState(() {
              _darkThemeEnabled = value;
              if (_darkThemeEnabled) {
                // Update theme to dark mode if needed
              }
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        ListTile(
          title: const Text('Choose theme color'),
          trailing:
              CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
          onTap: () async {
            // Implement color picker dialog
            Color? selectedColor = await showDialog<Color>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Select Theme Color'),
                  content: Wrap(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(Colors.red),
                        child: const CircleAvatar(backgroundColor: Colors.red),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(Colors.green),
                        child:
                            const CircleAvatar(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            );
            if (selectedColor != null) {
              widget.onThemeColorChanged(selectedColor); // Update theme color
            }
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Privacy policy logic
          },
        ),
        ListTile(
          title: const Text('Terms and Conditions'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Terms and conditions logic
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Log Out'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Log Out'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Logged out successfully!')),
                      );
                    },
                    child: const Text('Log Out',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
