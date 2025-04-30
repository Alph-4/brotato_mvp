import 'package:flutter/material.dart';
import '../models/player_class.dart';

class ClassSelectionScreen extends StatefulWidget {
  final Function(PlayerClassDetails) onClassSelected;
  static const id = 'ClassSelectionID';

  const ClassSelectionScreen({Key? key, required this.onClassSelected})
      : super(key: key);

  @override
  _ClassSelectionScreenState createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  PlayerClassDetails? _selectedClass;

  @override
  Widget build(BuildContext context) {
    final classes = PlayerClassDetails.classes;

    return Scaffold(
        appBar: AppBar(title: const Text("Choisir une classe")),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            "Sélectionnez une classe pour commencer le jeu.",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...classes.entries.map((entry) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedClass = entry.value;
                      });
                    },
                    child: Container(
                      width: 150,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                entry.value.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedClass == entry.value
                                        ? Colors.blue
                                        : Colors.black),
                              ),
                              Text(
                                entry.value.description,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: _selectedClass == entry.value
                                        ? Colors.white
                                        : Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        color: _selectedClass == entry.value
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: _selectedClass == entry.value
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2,
                            )),
                        elevation: 4,
                      ),
                    ));
              }).toList(),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedClass != null
                ? () => widget.onClassSelected(_selectedClass!)
                : null,
            child: const Text("Confirmer"),
          ),
        ]));
  }
}
