import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/data.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Patients Information\nManagement System',
                style: TextStyle(
                  fontSize: 23, // ปรับขนาดตัวอักษรตามความเหมาะสม
                  fontWeight: FontWeight.bold, // กำหนดความหนาของตัวอักษร
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                // เพิ่มเนื้อหาหรือวิดเจ็ตอื่น ๆ ของหน้านี้ที่นี่
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Data(), // เปลี่ยน YourNextPage() เป็นหน้าที่คุณต้องการแสดงหลังจากการตรวจสอบรหัสผ่าน
                              ),
                            );
                          },
                          child: Text("คลิ๊กเพื่อดูข้อมูลผู้ป่วย")),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
