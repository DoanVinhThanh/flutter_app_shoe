import 'package:flutter/material.dart';
import 'package:flutter_/widget/choice_chip.dart';
import 'package:flutter_/widget/title_container.dart';



class ColorAndSizeData extends StatefulWidget {
  final List<String>? colors;
  final List<String>? sizes;

  const ColorAndSizeData({
    super.key,
    this.colors,
    this.sizes,
  });

  @override
  _ColorAndSizeDataState createState() => _ColorAndSizeDataState();
}

class _ColorAndSizeDataState extends State<ColorAndSizeData> {
  String? selectedColor; // Track selected color
  String? selectedSize;  // Track selected size

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleContainer(title: "Màu", showActionButton: true),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: widget.colors != null && widget.colors!.isNotEmpty
              ? widget.colors!.map((color) {
                  return ChoiceChipWidget(
                    text: color,
                    selected: selectedColor == color, // Check if this color is selected
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedColor = color; // Update selected color
                        });
                      }
                    },
                  );
                }).toList()
              : [const ChoiceChipWidget(text: "No Colors Available", selected: false, onSelected: null)],
        ),
        const SizedBox(height: 20),
        const TitleContainer(title: "Kích thước", showActionButton: true),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: widget.sizes != null && widget.sizes!.isNotEmpty
              ? widget.sizes!.map((size) {
                  return ChoiceChipWidget(
                    text: size,
                    selected: selectedSize == size, // Check if this size is selected
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          selectedSize = size; // Update selected size
                        });
                      }
                    },
                  );
                }).toList()
              : [const ChoiceChipWidget(text: "No Sizes Available", selected: false, onSelected: null)],
        ),
      ],
    );
  }
}
