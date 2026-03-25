import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  static MaterialPageRoute route() => MaterialPageRoute(builder: (context) => const Setting());
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/language.png"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                        Text('English'),
                      ],
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(255, 212, 212, 212),
                  ),
                  child: GestureDetector(
                    child: Row(
                      children: [
                          Text('Change', style: TextStyle(fontWeight: FontWeight.w900),), 
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.edit)
                        ]
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
