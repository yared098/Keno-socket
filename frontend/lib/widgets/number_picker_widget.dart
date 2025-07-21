import 'package:flutter/material.dart';

typedef OnNumbersPicked = void Function(List<int> pickedNumbers);

class NumberPickerWidget extends StatefulWidget {
  final List<int> initialSelection;
  final OnNumbersPicked onNumbersPicked;
  final int maxPick;

  const NumberPickerWidget({
    Key? key,
    this.initialSelection = const [],
    required this.onNumbersPicked,
    this.maxPick = 4,
  }) : super(key: key);

  @override
  State<NumberPickerWidget> createState() => _NumberPickerWidgetState();
}

class _NumberPickerWidgetState extends State<NumberPickerWidget> {
  late List<int> _selectedNumbers;

  @override
  void initState() {
    super.initState();
    _selectedNumbers = List.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const Text(
              'Pick up to 4 numbers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: 80,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  final number = index + 1;
                  final isSelected = _selectedNumbers.contains(number);
                  final isMaxReached = _selectedNumbers.length >= widget.maxPick;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedNumbers.remove(number);
                        } else if (!isMaxReached) {
                          _selectedNumbers.add(number);
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green
                            : (isMaxReached ? Colors.grey[300] : Colors.grey[200]),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$number',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_selectedNumbers.isNotEmpty && _selectedNumbers.length <= widget.maxPick) {
                  widget.onNumbersPicked(_selectedNumbers);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Select between 1 and ${widget.maxPick} numbers.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
