import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {required this.label,
      required this.onChanged,
      this.keyboardType = TextInputType.number,
      super.key});
  final String label;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.height * 0.015,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: ShapeDecoration(
            color: const Color(0xFFDDDDDD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Center(
            child: TextField(
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              cursorColor: const Color(0xFFCE0014),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
