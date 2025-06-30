import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});


  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@triplefun.com',
      query: 'subject=App Support&body=Please describe your issue here...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+6012 345 6789');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: GoogleFonts.ubuntu()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Welcome to TripleFun Support!',
            style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'If you have questions or need assistance, check out the FAQs below or contact our support team.',
            style: GoogleFonts.ubuntu(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _faqItem(
            question: '1. How do I book a Flight or Hotel?',
            answer: 'Go to the "Home" section, click the "Flight" or "Hotel" button, choose the information on the location of the trip, and follow the booking steps.',
          ),
          _faqItem(
            question: '2. Can I cancel or reschedule my trip?',
            answer: 'Yes, Please contact our customer service by phone or e-mail in time, we will communicate with you about the procedures.',
          ),
          _faqItem(
            question: '3. Is my payment secure?',
            answer: 'Yes, we use industry-standard encryption and secure payment gateways.',
          ),
          _faqItem(
            question: '4. How do I update my profile?',
            answer: 'Navigate to the "Profile" tab, then tap modify icon to make changes.',
          ),
          const SizedBox(height: 24),
          Text(
            'Still need help?',
            style: GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.blue),
            title: Text('Email Us', style: GoogleFonts.ubuntu(fontSize: 16)),
            subtitle: Text('support@triplefun.com', style: GoogleFonts.ubuntu(fontSize: 14)),
            onTap: _launchEmail,
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text('Call Us', style: GoogleFonts.ubuntu(fontSize: 16)),
            subtitle: Text('+6012 345 6789', style: GoogleFonts.ubuntu(fontSize: 14)),
            onTap: _launchPhone,
          ),
        ],
      ),
    );
  }

  Widget _faqItem({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(answer, style: GoogleFonts.ubuntu()),
        ],
      ),
    );
  }
}