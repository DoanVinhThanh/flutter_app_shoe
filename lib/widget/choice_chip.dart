import 'package:flutter/material.dart';

class ChoiceChipWidget extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  const ChoiceChipWidget({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(text), // Always display the text
      selected: selected,
      onSelected: onSelected, // Trigger the callback
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      selectedColor: Colors.blue, // Change this color to your preference
      backgroundColor: Colors.grey[300], // Background color when not selected
    );
  }
}
