import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupporterScreen extends StatefulWidget {
  @override
  _SupporterScreenState createState() => _SupporterScreenState();
}

class _SupporterScreenState extends State<SupporterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false; // Track if email is being sent

  Future<void> _sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true; // Show loading indicator
      });

      final String name = _nameController.text;
      final String email = _emailController.text;
      final String feedback = _feedbackController.text;

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'ali.320230101@ejust.edu.eg', // Receiver email
        queryParameters: {
          'subject': 'Feedback/Problem Report from $name',
          'body': 'Name: $name\nEmail: $email\n\nFeedback/Problem:\n$feedback',
        },
      );

      try {
        if (await canLaunch(emailUri.toString())) {
          await launch(emailUri.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No email client found. Please install an email app.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to launch email client. Error: $e'),
            duration: Duration(seconds: 5),
          ),
        );
      } finally {
        setState(() {
          _isSending = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make the screen full screen
      extendBody: true,
      appBar: AppBar(
        title: Text('Supporter Team'),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // Remove app bar shadow
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background.jpg'), // Add your JPG background
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
          ),

          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.7), // Adjust opacity for better visibility
          ),

          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 20, // Add padding for app bar
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              children: [
                // Header Image or Illustration
                
                SizedBox(height: 20),

                // Feedback Form Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.color1.withOpacity(0.8), // Use #FFE1FF with opacity
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(Icons.person, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Your Email',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(Icons.email, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Feedback Field
                          TextFormField(
                            controller: _feedbackController,
                            decoration: InputDecoration(
                              labelText: 'Feedback or Ask',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(Icons.feedback, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your feedback or problem';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Send Feedback Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.color2, AppColors.color3], // Use #E4B1F0 and #7E60BF
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: _isSending ? null : _sendFeedback, // Disable button when sending
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isSending
                                  ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                                  : Text(
                                      'Send Feedback',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF); // #FFE1FF
  static const Color color2 = Color(0xFFE4B1F0); // #E4B1F0
  static const Color color3 = Color(0xFF7E60BF); // #7E60BF
}