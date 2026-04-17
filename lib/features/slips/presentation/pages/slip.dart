import 'package:calculations/features/slips/domain/entities/slip_entity.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Slip extends StatelessWidget {
  static MaterialPageRoute route(SlipEntity slip) => MaterialPageRoute(builder: (context) => const Slip());
  const Slip({
    super.key,
  });
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8), // adjust this
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Transform.translate(
          offset: Offset(-10, 0),
          child: Text(
            "10/11/25 Rofik", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT SIDE — white box with date & time
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("10/11/25"),
                          SizedBox(height: 4),
                          Text("10:15 AM"),
                        ],
                      ),
                    ),

                    // RIGHT SIDE — white box with icon
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Rofik'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Row(children: [Text('Iron')]),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_forward, size: 16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('2.7'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(Icons.close, size: 15),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('2.7'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(FontAwesomeIcons.equals, size: 13),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('20.7'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Row(children: [Text('Iron')]),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(Icons.arrow_forward, size: 16),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('2.7'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(Icons.close, size: 15),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('2.7'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Icon(FontAwesomeIcons.equals, size: 13),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text('20.7'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[300], // Line color
                thickness: 2, // The thickness of the line
                indent: 20, // Empty space to the left of the line
                endIndent: 20, // Empty space to the right of the line
                height: 50, // The total space the divider occupies
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    // width: 120,
                    alignment: Alignment.center,
                    // height: 30,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Total = 550",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: Text("Any Notes"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
