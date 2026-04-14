import 'package:flutter/material.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (value){

      },
      children: [
        Container(color: Colors.red,),
        Container(color: Colors.yellow,),
        Container(color: Colors.blue,),
        IconButton(onPressed: (){
          Navigator.of(context).pushReplacementNamed("/RootPage");
        }, icon: Icon(Icons.next_plan))
      ],
    );
  }
}
class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

