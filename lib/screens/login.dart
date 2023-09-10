import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_16/screens/config.dart';
import 'package:flutter_application_16/screens/doctors.dart';
import 'package:flutter_application_16/screens/home.dart';
import 'package:http/http.dart'as http;

class Login extends StatefulWidget {
  static const routeName = "/";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Widget mainBody = Container();
  final _formkey = GlobalKey<FormState>();
  Users user = Users();


  Future<void> login(Users user) async{
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(Configure.server, "users", params);
    var resp = await http.get(url);
    print(resp.body);

    List<Users> login_result = usersFromJson(resp.body);
    print(login_result.length);
    
    if(login_result.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("username or password invalid")
      ));
      } else {
      Configure.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20), // ระยะห่างด้านบน
              Text(
                "ยินดีต้อนรับสู่\n"
                "ระบบจัดการข้อมูลผู้ป่วย",
                style: TextStyle(
                  fontSize: 20, // ปรับขนาดตัวอักษร
                  fontFamily: 'PK_Uttaradit-Medium', // เปลี่ยนฟอนต์
                ),
                textAlign: TextAlign.center, // จัดข้อความตรงกลาง
              ),
              SizedBox(height: 20), // ระยะห่างระหว่างข้อความและรูป
              Container(
                width: 130, // ขนาดกว้างของวงกลม
                height: 130, // ขนาดสูงของวงกลม
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://i.pinimg.com/564x/82/df/bb/82dfbb3acad23cf9af41be6055668154.jpg', // URL ของรูปภาพจากอินเทอร์เน็ต
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmailInputField(),
                      PasswordInputField(),
                      SizedBox(height: 20.0,),
                    ],
                  )
                ),
              ),
              Container(
              alignment: Alignment.center, // จัดให้อยู่กึ่งกลาง
              child: Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กึ่งกลาง
                  children: [
                    loginButton()
                    ],

                  ))
                ),
            ],
          ),
        ),
      ),
    );
  }    
  Widget EmailInputField (){
      return TextFormField(
        initialValue: "chalemchai.doc@gmail.com",
        decoration: InputDecoration(
          labelText: 'อีเมล',
          icon: Icon(Icons.email),
        ),
        validator: (value) {
          if(value!.isEmpty){
            return "This field is required";
          }
          if(!EmailValidator.validate(value)){
            return "This field is required";
          }
          return null;
        },
        onSaved: (newValue) => user.email = newValue,
      );
    }
    Widget PasswordInputField(){
      return TextFormField(
        initialValue: "cha123",
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'รหัสผ่าน',
          icon: Icon(Icons.password)
        ),
        validator: (value) {
          if(value!.isEmpty){
            return "This field is required";
          }
          return null;
    },
    onSaved: (newValue) => user.password = newValue,
    );
    }
  Widget loginButton(){
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: (){
          if (_formkey.currentState!.validate()){
          _formkey.currentState!.save();  
          print(user.toJson().toString());
          login(user);
          }
          
        }, 
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("เข้าสู่ระบบ"),
        ),
        ),
    );
  }
}
