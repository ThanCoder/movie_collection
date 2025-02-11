import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_collections/app/widgets/t_text_field.dart';

class YearComponent extends StatefulWidget {
  int year;
  void Function(int year) onChanged;
  YearComponent({
    super.key,
    required this.year,
    required this.onChanged,
  });

  @override
  State<YearComponent> createState() => _YearComponentState();
}

class _YearComponentState extends State<YearComponent> {
  TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    yearController.text = widget.year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TTextField(
      label: Text('Year'),
      controller: yearController,
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        if (value.isEmpty || int.tryParse(value) == null) return;
        widget.onChanged(int.parse(value));
      },
    );
  }
}
