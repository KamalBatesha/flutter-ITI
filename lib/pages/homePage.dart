import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/pages/loginPage.dart';
import 'package:app/pages/addOrEditDoctorPage.dart';

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
    return FirebaseFirestore.instance.collection('doctors').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrEditDoctorPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Top Doctors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
                          docId: doc.id,
                          name: data['name'] ?? '',
                          speciality: data['speciality'] ?? '',
                          hospital: data['hospital'] ?? '',
                          location: data['location'] ?? '',
                          time: data['time'] ?? '',
                          fees: "\$${data['fees'] ?? 0}",
                          rating: data['rating'] ?? 0,
                          likes: data['likes'] ?? 0,
                          imagePath: 'images/doctor.png',
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddOrEditDoctorPage(
                                  docId: doc.id,
                                  existingData: data,
                                ),
                              ),
                            );
                          },
                          onLike: () async {
                            await FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(doc.id)
                                .update({'likes': FieldValue.increment(1)});
                          },
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

class DoctorCard extends StatelessWidget {
  final String docId;
  final String name, speciality, hospital, location, time, fees, imagePath;
  final int rating;
  final int likes;
  final VoidCallback onEdit;
  final VoidCallback onLike;

  const DoctorCard({
    super.key,
    required this.docId,
    required this.name,
    required this.speciality,
    required this.hospital,
    required this.location,
    required this.time,
    required this.fees,
    required this.rating,
    required this.imagePath,
    required this.likes,
    required this.onEdit,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(speciality, style: TextStyle(color: Colors.grey[800])),
                  Text(hospital, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
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
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text("Fees: $fees", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: onLike,
                          ),
                          Text("$likes likes"),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
