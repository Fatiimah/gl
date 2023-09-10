import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/config.dart';
import 'package:flutter_application_16/screens/data.dart';
import 'package:flutter_application_16/screens/patients.dart';
import 'package:http/http.dart' as http;

class PatientsForm extends StatefulWidget {
  const PatientsForm({super.key});

  @override
  State<PatientsForm> createState() => _PatientsFormState();
}

class _PatientsFormState extends State<PatientsForm> {
  final _formkey = GlobalKey<FormState>();
  late Patients patients;

  Future<void> addNewPatient(patients) async {
    var url = Uri.http(Configure.server, "patients");
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patients.toJson()));
    var rs = patientsFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> updateData(patients) async {
    var url = Uri.http(Configure.server, "patients/${patients.id}");
    var resp = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patients.toJson()));
    var rs = patientsFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
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
      appBar: AppBar(
        title: const Text("User Form"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              genderFormInput(),
              symInputField(),
              doctorFormInput(),

              SizedBox(
                height: 10,
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: patients.name,
      decoration:
          InputDecoration(labelText: "ชื่อ-สกุล", icon: Icon(Icons.person)),
      onSaved: (newValue) => patients.name = newValue,
    );
  }

  Widget genderFormInput() {
    var initGen = patients.gender ?? "ไม่ระบุ";

    return DropdownButtonFormField(
      value: initGen,
      decoration: InputDecoration(labelText: "เพศ:", icon: Icon(Icons.man)),
      items: Configure.gender.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (value) {
        patients.gender = value;
      },
      onSaved: (newValue) => patients.gender = newValue,
    );
  }

  Widget symInputField() {
    return TextFormField(
      initialValue: patients.symtoms,
      decoration: InputDecoration(
        labelText: "อาการ:",
        icon: Icon(Icons.message),
      ),
      onSaved: (newValue) => patients.symtoms = newValue,
    );
  }

  Widget doctorFormInput() {
    var initGen = patients.doctor ?? "ไม่ระบุ";

    return DropdownButtonFormField(
      value: initGen,
      decoration: InputDecoration(labelText: "แพทย์ผู้รับผิดชอบ:", icon: Icon(Icons.check_box)),
      items: Configure.doctor.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (value) {
        patients.doctor = value;
      },
      onSaved: (newValue) => patients.doctor = newValue,
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(patients.toJson().toString());
            if (patients.id == null) {
              await addNewPatient(patients);
            } else {
              await updateData(patients);
            }
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Data(),
            ));
          }
        },
        child: Text("Save"));
  }
}
