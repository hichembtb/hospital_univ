import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gestion_hopital/models/rdv_model.dart';

import '../models/drdv_model.dart';

class Doctorpage extends StatefulWidget {
  const Doctorpage({super.key});

  @override
  State<Doctorpage> createState() => _DoctorpageState();
}

class _DoctorpageState extends State<Doctorpage> {
  //! REQUET SUR LES DEMANDES DE RENDEZ-VOUS
  CollectionReference drdvRef = FirebaseFirestore.instance.collection('drdv');
  List<QueryDocumentSnapshot<Object?>> drdvDocs = [];
  List<DrdvModel> drdvInstance = [];
  Future<List<DrdvModel>> getDemandRdv() async {
    drdvInstance.clear();

    QuerySnapshot<Object?> drdvQuery = await drdvRef.get();
    drdvDocs = drdvQuery.docs;
    for (QueryDocumentSnapshot<Object?> drdv in drdvDocs) {
      Map<String, dynamic> drdvData = drdv.data() as Map<String, dynamic>;

      drdvInstance.add(DrdvModel.fromJson(drdvData));
    }

    return drdvInstance;
  }

//! REFUSER UNE DEMANDE DE RENDEZ VOUS
  Future<void> deleteDrdv(int drdvIndex) async {
    EasyLoading.show();
    QuerySnapshot<Object?> drdvQuery = await drdvRef
        .where('userId', isEqualTo: drdvInstance[drdvIndex].userId)
        .get();
    for (QueryDocumentSnapshot<Object?> drdv in drdvQuery.docs) {
      await drdvRef.doc(drdv.id).delete();
      setState(() {
        drdvInstance.removeAt(drdvIndex);
      });
    }
    EasyLoading.dismiss();
  }

  //! ACCEPTER UNE DEAMANDEDE RANDEZ VOUS
  Future<void> acceptRdv(int drdvIndex) async {
    CollectionReference rdvRef = FirebaseFirestore.instance.collection('rdv');
    RdvModel rdvModel = RdvModel(
      email: drdvInstance[drdvIndex].email,
      name: drdvInstance[drdvIndex].name,
      phone: drdvInstance[drdvIndex].phone,
      userId: drdvInstance[drdvIndex].userId,
      dateTime: DateTime.now(),
    );
    EasyLoading.show();
    await rdvRef.add(rdvModel.toJson());
    EasyLoading.dismiss();
    deleteDrdv(drdvIndex);
    setState(() {
      drdvInstance.removeAt(drdvIndex);
    });
    EasyLoading.showSuccess("Rendez vous accepter");
  }

  @override
  void initState() {
    drdvInstance.clear();
    getDemandRdv();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("Image/doctor1.jpg"),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7165D6),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF7165D6),
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Clinic Visit",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Make an appointment",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EEFA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.home_filled,
                          color: Color(0xFF7165D6),
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Home Visit",
                        style: TextStyle(
                          fontSize: 18,
                          // color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Call the doctor home",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Patients",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          FutureBuilder(
              future: getDemandRdv(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("INTERNT PROBLEM"),
                  );
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: drdvInstance.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage("Image/iiiiimage.jpg"),
                            ),
                            Text(
                              drdvInstance[index].name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              drdvInstance[index].phone,
                              style: const TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => deleteDrdv(index),
                                  child: const Icon(
                                    Icons.cancel_outlined,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => acceptRdv(index),
                                  child: const Icon(
                                    Icons.check,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Unknown problem"));
                }
              }),
        ],
      ),
    );
  }
}
