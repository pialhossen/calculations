import 'package:calculations/features/products/domain/entities/product.dart';
import 'package:calculations/features/products/presentation/bloc/product_bloc.dart';
import 'package:calculations/features/products/presentation/bloc/product_event.dart';
import 'package:calculations/features/products/presentation/bloc/product_state.dart';
import 'package:calculations/features/slips/data/model/slip_item_model.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_bloc.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_event.dart';
import 'package:calculations/features/slips/presentation/bloc/slip_state.dart';
import 'package:calculations/features/slips/presentation/pages/slip.dart';
import 'package:calculations/features/slips/presentation/widget/calculation_step.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SlipForm extends StatefulWidget {
  final int? id;
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const SlipForm());
  const SlipForm({super.key, this.id});

  @override
  State<SlipForm> createState() => _SlipFormState();
}

class _SlipFormState extends State<SlipForm> {
  List<SlipItemModel> steps = [];
  List<Product>? products;

  double get grandTotal {
    return steps.fold(0, (sum, item) => sum + item.rowTotal);
  }

  @override
  void initState() {
    super.initState();
    // nameController = TextEditingController();
    // perKgController = TextEditingController();
    context.read<ProductBloc>().add(LoadProductsEvent());
    if (widget.id != null) {
      context.read<SlipBloc>().add(LoadSingleSlipEvent(widget.id!));
      //   nameController.text = "";
      //   perKgController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    void createNewSlip() {
      Navigator.pop(context);
      context.read<SlipBloc>().add(
        SlipCreateEvent(
          employeeId: 1,
          slipItems: steps,
          totalAmount: grandTotal,
          note: "",
        ),
      );
    }

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
            "Create New Slip", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state.products.isNotEmpty) {
              setState(() {
                products = state.products;
              });
            }
          },
          child: BlocConsumer<SlipBloc, SlipState>(
            listenWhen: (previous, current) =>
                previous.selectedSlip != current.selectedSlip,
            listener: (context, state) {
              if (state.selectedSlip != null) {
                steps = state.selectedSlip!.slipItems;
              } else if (state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: const CircularProgressIndicator());
              }
              return Column(
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
                                color: Colors.white,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text('Rofik'),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            ...steps.asMap().entries.map((entry) {
                              int idx = entry.key;
                              return CalculationStep(
                                key: ValueKey(steps[idx]),
                                products: products ?? [],
                                delete: () {
                                  setState(() {
                                    steps.removeAt(idx);
                                  });
                                },
                                onProductChange: (Product product) {
                                  steps[idx].productName = product.name;
                                },
                                onCalculationChanged:
                                    ({
                                      required double total,
                                      required double perKg,
                                      required double kg,
                                    }) {
                                      setState(() {
                                        steps[idx].rowTotal = total;
                                        steps[idx].kg = kg;
                                        steps[idx].perKg = perKg;
                                      });
                                    },
                              );
                            }),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            steps = [
                              ...steps,
                              SlipItemModel(
                                productName: '',
                                kg: 0,
                                perKg: 0,
                                rowTotal: 0,
                              ),
                            ];
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 50,
                              height: 50,
                              child: Icon(
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // width: 120,
                            alignment: Alignment.center,
                            // height: 30,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Total = ${grandTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        // 1. Set the 10px margin on each side
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          // 2. Setting maxLines to null makes it grow vertically as you type
                          maxLines: null,
                          // 3. This ensures the 'Enter' key creates a new line instead of submitting
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Enter your text here...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            // Adjust this to control the "starting" height
                            contentPadding: EdgeInsets.all(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: createNewSlip,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const Slip(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Text("View"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
