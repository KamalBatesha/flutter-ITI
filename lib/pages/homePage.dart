// HomePage.dart

import 'package:app/pages/doctorPage.dart';
import 'package:app/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Stream<QuerySnapshot> getDoctorsStream() {
    print("=========================================");
    print(FirebaseFirestore.instance.collection('doctors').snapshots());
    return FirebaseFirestore.instance.collection('doctors').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.grid_view_rounded, size: 28),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed: () => logout(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 18),
                            Gap(0, 5),
                            const Text("15 Oct, 2020"),
                            Gap(0, 5),
                            const Icon(Icons.keyboard_arrow_down, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Gap(20, 0),
              Text("Let's find doctor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Gap(20, 0),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Gap(20, 0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const CategoryItem(
                      icon: Icons.medical_services,
                      label: "Dental",
                      color: Color(0xffffe4dd),
                      textColor: Color(0xfffe6636),
                    ),
                    Gap(0, 15),
                    const CategoryItem(
                      icon: Icons.favorite,
                      label: "Heart",
                      color: Color(0xffDAE9FE),
                      textColor: Color(0xff4185F9),
                    ),
                    Gap(0, 15),
                    const CategoryItem(
                      icon: Icons.psychology,
                      label: "Brain",
                      color: Color(0xffCFFFE9),
                      textColor: Color(0xff22C877),
                    ),
                  ],
                ),
              ),
              Gap(20, 0),
              Text("Top Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Gap(10, 0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getDoctorsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No doctors available.'));
                    }

                    final doctors = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doc = doctors[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return DoctorCard(
                          name: data['name'] ?? '',
                          speciality: data['speciality'] ?? '',
                          hospital: data['hospital'] ?? '',
                          location: data['location'] ?? '',
                          time: data['time'] ?? '',
                          fees: "\$${data['fees'] ?? 0}",
                          rating: data['rating'] ?? 0,
                          imagePath: 'images/doctor.png',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔽 هذه الكلاسات يجب أن تكون خارج HomePage:

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Color? textColor;

  const CategoryItem({super.key, required this.icon, required this.label, this.textColor, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      padding: EdgeInsets.symmetric(vertical: 21),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, size: 45, color: textColor),
          Gap(10, 0),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name, speciality, hospital, location, time, fees, imagePath;
  final int rating;

  const DoctorCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.hospital,
    required this.location,
    required this.time,
    required this.fees,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorPage())),
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Gap(0, 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(speciality, style: TextStyle(color: Colors.grey[800])),
                    Text(hospital, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                    Gap(6, 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[800]),
                            Gap(0, 5),
                            Text(location, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                          ],
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 14,
                              color: index < rating ? Colors.orange : Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(5, 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text("Clinic Fees: $fees", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
