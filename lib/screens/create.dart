import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/config.dart';
import 'package:flutter_application_16/screens/data.dart';
import 'package:flutter_application_16/screens/patients.dart';
import 'package:http/http.dart' as http;

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formkey = GlobalKey<FormState>();
  late Patients patients;

  Future<void> addNewUser(user) async {
    var url = Uri.http(Configure.server, "user");
    var resp = await http.post(url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(patients.toJson()));
    var rs = patientsFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> updateData(user) async {
    var url = Uri.http(Configure.server, "user/${user.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(user.toJson()));
    var rs = patientsFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    //return;
  }

  @override
  Widget build(BuildContext context) {
    try {
      patients = ModalRoute.of(context)!.settings.arguments as Patients;
      print(patients.name);
    } catch (e) {
      patients = Patients();
    }

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 185, 233, 202),
            border: Border.all(
                width: 2.0, color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          constraints: BoxConstraints(maxWidth: 400),
          height: 500,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "เพิ่มข้อมูลผู้ป่วย",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  nameInputField(),
                  genderFormInput(),
                  symtomsInputField(),
                  doctorInputField(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          // ใช้ Row เพื่อจัดวางปุ่มในบรรทัดเดียวกัน
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // ปุ่มที่ 1
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Data()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 173, 232, 196)), // เปลี่ยนสีปุ่มที่นี่
                minimumSize: MaterialStateProperty.all(
                    Size(120, 40)), // เพิ่มขนาดปุ่มที่นี่
              ),
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            SizedBox(width: 50), // ระยะห่างระหว่างปุ่ม
            ElevatedButton(
              // ปุ่มที่ 2
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  print(patients.toJson().toString());
                  if (patients.id == null) {
                    await addNewUser(patients);
                  } else {
                    await updateData(patients);
                  }
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Data()));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 176, 232, 198)), // เปลี่ยนสีปุ่มที่นี่
                minimumSize: MaterialStateProperty.all(
                    Size(120, 40)), // เพิ่มขนาดปุ่มที่นี่
              ),
              child: Text(
                "บันทึก",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nameInputField() {
    return TextFormField(
      initialValue: patients.name,
      decoration: InputDecoration(
          labelText: "ชื่อผู้ป่วย:",
          labelStyle: TextStyle(color: Colors.black),
          icon: Icon(Icons.person)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => patients.name = newValue,
    );
  }

  Widget genderFormInput() {
    var initGen = "ไม่ระบุ";
    try {
      if (!patients.gender!.isEmpty) {
        initGen = patients.gender!;
      }
    } catch (e) {
      initGen = "ไม่ระบุ";
    }

    return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: "เพศ:",
            labelStyle: TextStyle(color: Colors.black),
            icon: Icon(Icons.man)),
        value: "ไม่ระบุ",
        items: Configure.gender.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (value) {
          patients.gender = value;
        },
        onSaved: (newValue) => patients.gender = newValue
        );
  }

  Widget symtomsInputField() {
    return TextFormField(
      initialValue: patients.symtoms,
      decoration: InputDecoration(
          labelText: "อาการ:",
          labelStyle: TextStyle(color: Colors.black),
          icon: Icon(Icons.healing)),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => patients.symtoms = newValue,
    );
  }

  Widget doctorInputField() {
    var initGen = "นายเเพทย์เฉลิมชัย สุขสันต์";
    try {
      if (!patients.doctor!.isEmpty) {
        initGen = patients.doctor!;
      }
    } catch (e) {
      initGen = "นายเเพทย์เฉลิมชัย สุขสันต์";
    }

    return DropdownButtonFormField(
        decoration: InputDecoration(
            labelText: "แพทย์ผู้รับผิดชอบ:",
            labelStyle: TextStyle(color: Colors.black),
            icon: Icon(Icons.man)),
        value: "นายเเพทย์เฉลิมชัย สุขสันต์",
        items: Configure.doctor.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (value) {
          patients.doctor = value;
        },
        onSaved: (newValue) => patients.doctor = newValue
        );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formkey.currentState!.validate()) {
          _formkey.currentState!.save();
          print(patients.toJson().toString());
          if (patients.id == null) {
            await addNewUser(patients);
          } else {
            await updateData(patients);
          }
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Data()));
        }
      },
      child: Text("Save"),
    );
  }
}
