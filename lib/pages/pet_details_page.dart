import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/widgets/button_widget.dart';
import 'package:flutter_mobile_whiskerway/widgets/text_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PetDetailsPage extends StatelessWidget {
  Map data;

  PetDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: TextWidget(
          text: 'Details',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/dog1.jpg'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Pet Name: ${data['name']}',
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Bold',
              ),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: 'Type',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Medium',
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextWidget(
                  text: data['type'],
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Regular',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: 'Bio',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Medium',
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextWidget(
                  text: data['bio'],
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Regular',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: 'Personality',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Medium',
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextWidget(
                  text: data['personality'],
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Regular',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: ButtonWidget(
                  label: 'View QR',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [QrImageView(data: data['qr'])],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
