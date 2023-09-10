import 'package:flutter_application_16/screens/doctors.dart';
import 'package:flutter_application_16/screens/patients.dart';

class Configure{
  static const server = "192.168.0.38:3000";
  static Users login = Users();
  static Patients data = Patients();
  static List<String> gender = [
    "ไม่ระบุ",
    "ชาย",
    "หญิง",
  ];
  static List<String> doctor = [
    "นายเเพทย์เฉลิมชัย สุขสันต์",
    "เเพทย์หญิงสุขใจ รักงาน",
    "นายเเพทย์สมศักดิ์ ใจภักดี",
    "เเพทย์หญิงชูใจ สู่ขวัญ"
  ];
}