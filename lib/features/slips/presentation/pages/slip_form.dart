import 'package:calculations/core/widgets/employee_select.dart';
import 'package:calculations/features/employees/domain/entities/employee.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_bloc.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_event.dart';
import 'package:calculations/features/employees/presentation/bloc/employee_state.dart';
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
import 'package:intl/intl.dart';

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
  List<Employee>? employees;
  Employee? selectedEmployee;
  TextEditingController noteController = TextEditingController();

  double get grandTotal {
    return steps.fold(0, (sum, item) => sum + item.rowTotal);
  }

  void handleEmployeeChange(Employee? employee) {
    if (employee == null) return;
    setState(() {
      selectedEmployee = employee;
    });
  }

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController();
    // perKgController = TextEditingController();
    context.read<ProductBloc>().add(LoadProductsEvent());
    context.read<EmployeeBloc>().add(LoadEmployeesEvent(q: null));
    if (widget.id != null) {
      context.read<SlipBloc>().add(LoadSingleSlipEvent(widget.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    void createNewSlip() {
      Navigator.pop(context);
      context.read<SlipBloc>().add(
        SlipCreateEvent(
          employeeId: selectedEmployee!.id ?? 1,
          slipItems: steps,
          totalAmount: grandTotal,
          note: noteController.text.trim(),
        ),
      );
    }

    void updateSlip() {
      Navigator.pop(context);
      if (widget.id != null) {
        context.read<SlipBloc>().add(
          SlipUpdateEvent(
            id: widget.id!,
            employeeId: selectedEmployee?.id ?? 1,
            slipItems: steps,
            totalAmount: grandTotal,
            note: noteController.text.trim(),
          ),
        );
      }
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
            widget.id != null
                ? "Update Slip"
                : "Create New Slip", // use the passed title
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state.employees.isNotEmpty) {
              setState(() {
                employees = state.employees;

                // If we are CREATING (id == null) and haven't picked anyone yet
                if (widget.id == null && selectedEmployee == null) {
                  selectedEmployee = state.employees.first;
                }
                // If we are UPDATING, we usually wait for SlipBloc to provide the employee
              });
            }
          },
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
              // Inside BlocConsumer<SlipBloc, SlipState> listener
              listener: (context, state) {
                if (state.selectedSlip != null && steps.isEmpty) {
                  setState(() {
                    steps = state.selectedSlip!.slipItems;
                    noteController.text = state.selectedSlip?.note ?? '';
                    selectedEmployee = state.selectedSlip!.employee;
                  });
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: const CircularProgressIndicator());
                }
                if (employees == null || products == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Loading data..."),
                        ],
                      ),
                    ),
                  );
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
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yy').format(
                                        widget.id != null
                                            ? state.selectedSlip!.dateTime
                                            : DateTime.now(),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat('hh:mm a').format(
                                        widget.id != null
                                            ? state.selectedSlip!.dateTime
                                            : DateTime.now(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              EmployeeSelect(
                                employees: employees!,
                                onChange: handleEmployeeChange,
                                initialValue:
                                    selectedEmployee?.id?.toString() ??
                                    employees!.first.id.toString(),
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
                                  slipItem: steps[idx],
                                  key: ValueKey(steps[idx]),
                                  products: products ?? [],
                                  delete: () {
                                    setState(() {
                                      steps.removeAt(idx);
                                    });
                                  },
                                  onProductChange: (Product product) {
                                    steps[idx].product = product;
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
                                  product: products!.first,
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
                                "Total = ${grandTotal.floor()}",
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
                            controller: noteController,
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
                              onTap: widget.id != null
                                  ? updateSlip
                                  : createNewSlip,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.id != null ? "Update" : "Save",
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
                                    builder: (BuildContext context) => Slip(
                                      note: noteController.text.trim(),
                                      total: grandTotal.floor().toString(),
                                      steps: steps,
                                      employee: selectedEmployee!,
                                      dateTime: widget.id != null
                                          ? state.selectedSlip!.dateTime
                                          : DateTime.now(),
                                    ),
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
      ),
    );
  }
}
