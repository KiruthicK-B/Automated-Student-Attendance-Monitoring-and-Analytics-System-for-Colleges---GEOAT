import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String user;
  final String skin;
  final List<String> questions;

  const TakePictureScreen({
    super.key,
    required this.cameras,
    required this.user,
    required this.skin,
    required this.questions,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

// Simulating a CameraDescription class
class CameraDescription {}

class TakePictureScreenState extends State<TakePictureScreen>
    with TickerProviderStateMixin {
  bool isInitialized = false;
  int indicator = 0;

  @override
  void initState() {
    super.initState();
    // Simulate camera initialization
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isInitialized = true;
      });
      _autoCaptureImage();
    });
  }

  void _autoCaptureImage() async {
    setState(() {
      indicator = 1;
    });
    // Simulating an image path after "capture"
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowImage(
            imagePath: "assets/employee.png",
            userType: widget.user,
            skin: widget.skin,
            questions: widget.questions,
          ),
        ));
        setState(() {
          indicator = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'Camera Preview',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: (indicator == 1)
            ? SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              )
            : SizedBox(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Placeholder widget to display the "captured" image
class ShowImage extends StatelessWidget {
  final String imagePath;
  final String userType;
  final String skin;
  final List<String> questions;

  const ShowImage({
    super.key,
    required this.imagePath,
    required this.userType,
    required this.skin,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User: $userType, Skin: $skin'),
            SizedBox(height: 20),
            Image.asset(imagePath), // Display placeholder image
            SizedBox(height: 20),
            Text('Questions: ${questions.join(", ")}'),
          ],
        ),
      ),
    );
  }
}
