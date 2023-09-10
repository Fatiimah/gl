// To parse this JSON data, do
//
//     final patients = patientsFromJson(jsonString);

import 'dart:convert';

List<Patients> patientsFromJson(String str) => List<Patients>.from(json.decode(str).map((x) => Patients.fromJson(x)));

String patientsToJson(List<Patients> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Patients {
    int? id;
    String? name;
    String? gender;
    String? symtoms;
    String? doctor;

    Patients({
        this.id,
        this.name,
        this.gender,
        this.symtoms,
        this.doctor,
    });

    factory Patients.fromJson(Map<String, dynamic> json) => Patients(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        symtoms: json["symtoms"],
        doctor: json["doctor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "symtoms": symtoms,
        "doctor": doctor,
    };
}
