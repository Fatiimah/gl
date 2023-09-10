import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/config.dart';
import 'package:flutter_application_16/screens/create.dart';
import 'package:flutter_application_16/screens/doctors.dart';
import 'package:flutter_application_16/screens/each.dart';
import 'package:flutter_application_16/screens/patients.dart';
import 'package:flutter_application_16/screens/form.dart';
import 'package:http/http.dart' as http;

class Data extends StatelessWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: PatientsInfo());
  }
}

class PatientsInfo extends StatefulWidget {
  const PatientsInfo({super.key});

  @override
  State<PatientsInfo> createState() => _PatientsInfoState();
}

class _PatientsInfoState extends State<PatientsInfo> {
  Widget mainBody = Container();

  @override
  void initState() {
    super.initState();
    Users users = Configure.login;
    if (users.email != null) {
      getPatients();
    }
  }

  Widget showPatients() {
    return ListView.builder(
      itemCount: _patientsList.length,
      itemBuilder: (context, index) {
        Patients patients = _patientsList[index];
        return Dismissible(
          key: UniqueKey(),
          //direction: DismissDirection.endToStart,
          child: Card(
            child: ListTile(
              title: Text("${patients.id}"),
              subtitle: Text(
                  "${patients.name},\n ${patients.gender},\n ${patients.symtoms},\n ${patients.doctor}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EachPatient(),
                        settings: RouteSettings(arguments: patients)));
              }, //to show info
              trailing: IconButton(
                onPressed: () async {
                  String result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientsForm(),
                          settings: RouteSettings(arguments: patients)));
                  if (result == "refresh") {
                    getPatients();
                  }
                }, //to edit
                icon: Icon(Icons.edit),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ข้อมูลผู้ป่วย"),
        ),
        body: mainBody,
        
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Create(),
                ));
            if (result == "refresh") {
              getPatients();
            }
          },
          child: const Icon(Icons.person_add_alt_1),
        ));
  }

  List<Patients> _patientsList = [];
  Future<void> getPatients() async {
    var url = Uri.http(Configure.server, "patients");
    var resp = await http.get(url);
    setState(() {
      _patientsList = patientsFromJson(resp.body);
      mainBody = showPatients();
    });
    return;
  }

  // Future<void> removePatients(Patients) async{
  //   var url = Uri.http(Configure.server, "patients/${patients.id}");
  //   var resp = await http.delete(url);
  //   print(resp.body);
  // }
}
