import 'package:flutter/material.dart';

class SlipCard extends StatelessWidget {
  const SlipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // make children full height
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "25/06/25",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              Container(
                height: 30, // fixed height, or use double.infinity to fill
                width: 100,
                alignment: Alignment.centerLeft,
                child: Text('Sumon'),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#wrw6gsif',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)
              ),
              Text(
                "860 TK",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        print('click');
                      },
                      child: Icon(
                        Icons.edit,
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        print('click');
                      },
                      child: Icon(
                        Icons.delete,
                        size: 32,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
