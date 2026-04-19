import 'package:calculations/features/slips/domain/entities/slip_entity.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_bloc.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_event.dart';
import 'package:calculations/features/slips/presentation/pages/slip.dart';
import 'package:calculations/features/slips/presentation/pages/slip_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SlipCard extends StatelessWidget {
  final SlipEntity slipEntity;
  const SlipCard({
    super.key,
    required this.slipEntity,
  });

  @override
  Widget build(BuildContext context) {
    void deleteSlip() {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              "Are you sure you want to delete this Slip?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Text('Cancel')
              ),
              TextButton(
                onPressed: () {
                  context.read<SlipBloc>().add(
                    SlipDeleteEvent(id: slipEntity.id!, dateTime: DateTime.now())
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "DELETE",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }
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
                slipEntity.employee.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              Container(
                height: 30, // fixed height, or use double.infinity to fill
                width: 200,
                alignment: Alignment.centerLeft,
                child: Text(
                  "${DateFormat('dd/MM/yy').format(slipEntity.dateTime)} - ${
                    (slipEntity.note != null && slipEntity.note!.length > 15) 
                      ? '${slipEntity.note!.substring(0, 15)}...' 
                      : (slipEntity.note ?? '')
                  }"
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${slipEntity.total.floor()} TK",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Slip(
                            note: slipEntity.note != null? slipEntity.note!: "",
                            total: slipEntity.total.floor().toString(),
                            steps: slipEntity.slipItems,
                            employee: slipEntity.employee,
                            dateTime: slipEntity.dateTime,
                          )
                        ));
                      },
                      child: Icon(
                        Icons.remove_red_eye_rounded,
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SlipForm(id: slipEntity.id)));
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
                      onTap: deleteSlip,
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
