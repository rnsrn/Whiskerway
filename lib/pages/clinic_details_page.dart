import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/widgets/button_widget.dart';
import 'package:flutter_mobile_whiskerway/widgets/text_widget.dart';

class ClinicDetailsPage extends StatefulWidget {
  const ClinicDetailsPage({super.key});

  @override
  State<ClinicDetailsPage> createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<ClinicDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9f1fd),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget(
                        text: 'Clinic Details',
                        fontSize: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'images/image 10.png',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: 'Veterinary Clinic Name',
                  fontSize: 18,
                  color: Colors.black,
                ),
                TextWidget(
                  text: 'Veterinary Clinic Address',
                  fontSize: 14,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: '0923 425 6793',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: 'vetclinic@gmail.com',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: 'Always open',
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
                TextWidget(
                  text: 'Parking not available',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: 'Services offered',
                  fontSize: 18,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: SizedBox(
                          height: 90,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Neutering',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  text: '100.00 to 150.00',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  text: 'Dr. Menchielou Reyes',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'Follow us on:',
                  fontSize: 18,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset(
                          'images/Vector (${i + 2}).png',
                          width: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ButtonWidget(
                    label: 'Locate',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
