import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/patients.dart';

class EachPatient extends StatelessWidget {
  const EachPatient({super.key});

  @override
  Widget build(BuildContext context) {
    Patients patients = Patients();
    patients = ModalRoute.of(context)!.settings.arguments as Patients;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลผู้ป่วย"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(title: Text("ชื่อ-สกุล"), subtitle: Text("${patients.name}"),),
            ListTile(title: Text("เพศ"), subtitle: Text("${patients.gender}"),),
            ListTile(title: Text("อาการ"), subtitle: Text("${patients.symtoms}"),),
            ListTile(title: Text("แพทย์ผู้รับผิดชอบ"), subtitle: Text("${patients.doctor}"),),

          ],
        ),
      ),
    );
  }
}