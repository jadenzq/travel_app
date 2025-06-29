import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'English';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Language', style: GoogleFonts.ubuntu()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('English', style: GoogleFonts.ubuntu()),
                value: 'English',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('中文', style: GoogleFonts.ubuntu()),
                value: '中文',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('Malay', style: GoogleFonts.ubuntu()),
                value: 'Malay',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
    );
  }

  void _navigateToPrivacy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacySettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.ubuntu(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notifications', style: GoogleFonts.ubuntu(fontSize: 18)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _navigateToNotifications,
          ),
          ListTile(
            title: Text('Privacy', style: GoogleFonts.ubuntu(fontSize: 18)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _navigateToPrivacy,
          ),
          ListTile(
            title: Text('Language', style: GoogleFonts.ubuntu(fontSize: 18)),
            subtitle: Text(_language, style: GoogleFonts.ubuntu()),
            trailing: const Icon(Icons.language),
            onTap: _showLanguageDialog,
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushEnabled = true;
  bool _promoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings', style: GoogleFonts.ubuntu(fontSize: 24)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Enable Push Notifications', style: GoogleFonts.ubuntu()),
            value: _pushEnabled,
            onChanged: (v) => setState(() => _pushEnabled = v),
          ),
          SwitchListTile(
            title: Text('Promotional Notifications', style: GoogleFonts.ubuntu()),
            value: _promoEnabled,
            onChanged: (v) => setState(() => _promoEnabled = v),
          ),
        ],
      ),
    );
  }
}

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _dataCollection = true;
  bool _personalizedAds = false;
  bool _locationAccess = true;
  bool _cameraAccess = true;
  bool _micAccess = false;
  bool _albumAccess = true;
  bool _thirdPartySharing = false;
  bool _findableByPhone = true;
  bool _findableByEmail = true;
  bool _personalizedNotifications = true;

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy', style: GoogleFonts.ubuntu()),
        content: Text(
          'We collect usage data to improve the app experience. Your data is never sold to third parties.',
          style: GoogleFonts.ubuntu(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.ubuntu()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings', style: GoogleFonts.ubuntu(fontSize: 24)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Allow Data Collection', style: GoogleFonts.ubuntu()),
            subtitle: Text('Usage behavior, device info', style: GoogleFonts.ubuntu(fontSize: 12)),
            value: _dataCollection,
            onChanged: (v) => setState(() => _dataCollection = v),
          ),
          SwitchListTile(
            title: Text('Personalized Ads/Recommendations', style: GoogleFonts.ubuntu()),
            value: _personalizedAds,
            onChanged: (v) => setState(() => _personalizedAds = v),
          ),
          SwitchListTile(
            title: Text('Location Access', style: GoogleFonts.ubuntu()),
            value: _locationAccess,
            onChanged: (v) => setState(() => _locationAccess = v),
          ),
          SwitchListTile(
            title: Text('Camera Access', style: GoogleFonts.ubuntu()),
            value: _cameraAccess,
            onChanged: (v) => setState(() => _cameraAccess = v),
          ),
          SwitchListTile(
            title: Text('Microphone Access', style: GoogleFonts.ubuntu()),
            value: _micAccess,
            onChanged: (v) => setState(() => _micAccess = v),
          ),
          SwitchListTile(
            title: Text('Album Access', style: GoogleFonts.ubuntu()),
            value: _albumAccess,
            onChanged: (v) => setState(() => _albumAccess = v),
          ),
          SwitchListTile(
            title: Text('Allow Third-Party Sharing', style: GoogleFonts.ubuntu()),
            value: _thirdPartySharing,
            onChanged: (v) => setState(() => _thirdPartySharing = v),
          ),
          SwitchListTile(
            title: Text('Findable by Phone Number', style: GoogleFonts.ubuntu()),
            value: _findableByPhone,
            onChanged: (v) => setState(() => _findableByPhone = v),
          ),
          SwitchListTile(
            title: Text('Findable by Email', style: GoogleFonts.ubuntu()),
            value: _findableByEmail,
            onChanged: (v) => setState(() => _findableByEmail = v),
          ),
          SwitchListTile(
            title: Text('Personalized Notifications', style: GoogleFonts.ubuntu()),
            value: _personalizedNotifications,
            onChanged: (v) => setState(() => _personalizedNotifications = v),
          ),
          ListTile(
            title: Text('View Privacy Policy', style: GoogleFonts.ubuntu(fontSize: 16)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showPrivacyPolicyDialog,
          ),
        ],
      ),
    );
  }
}