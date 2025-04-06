import 'package:flutter/material.dart';
import 'package:movie_collections/app/components/index.dart';
import 'package:movie_collections/app/models/tag_model.dart';
import 'package:movie_collections/app/services/tag_services.dart';
import 'package:movie_collections/app/widgets/core/index.dart';

class TagFormDialog extends StatefulWidget {
  String values;
  void Function(String values) onSubmited;
  TagFormDialog({
    super.key,
    required this.values,
    required this.onSubmited,
  });

  @override
  State<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends State<TagFormDialog> {
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = 'Untitled';
    super.initState();
    existsList =
        widget.values.split(',').where((name) => name.isNotEmpty).toList();
    init();
  }

  List<TagModel> list = [];
  List<String> existsList = [];
  String? errorText;

  void init() async {
    list = await TagServices.instance.getList();
    list = list.map((tg) {
      if (existsList.contains(tg.name)) {
        tg.isSelected = true;
      }
      return tg;
    }).toList();
    if (!mounted) return;
    setState(() {});
  }

  void _selectItem(TagModel tag, bool isChecked) {
    list = list.map((tg) {
      if (tg.name == tag.name) {
        tg.isSelected = isChecked;
      }
      return tg;
    }).toList();
    setState(() {});
  }

  void _addTag() async {
    try {
      if (titleController.text.isEmpty) return;
      final tag = TagModel(name: titleController.text);
      list.insert(0, tag);
      await TagServices.instance.add(tag);
      if (!mounted) return;
      showMessage(context, 'Added');
      titleController.text = '';
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _form() {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: TTextField(
            controller: titleController,
            label: Text('Title...'),
            isSelectedAll: true,
            onSubmitted: (val) => _addTag(),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  errorText = 'value is empty';
                });
                return;
              }
              if (value.isNotEmpty) {}
              setState(() {
                errorText = null;
              });
            },
            errorText: errorText,
          ),
        ),
        IconButton(
          onPressed: _addTag,
          icon: Icon(Icons.add_rounded),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      // contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      content: SizedBox(
        height: size.height * 0.4,
        width: size.width * 0.6,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _form()),
            SliverList.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final tag = list[index];
                return GestureDetector(
                  onTap: () {
                    _selectItem(tag, !tag.isSelected);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: tag.isSelected,
                        onChanged: (value) {
                          _selectItem(tag, value!);
                        },
                      ),
                      Text(tag.name),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmited(
              list
                  .where((tg) => tg.isSelected)
                  .map((tg) => tg.name)
                  .toList()
                  .join(','),
            );
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}

/*
CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(child: _form()),
            SliverList.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final tag = list[index];
                return Row(
                  children: [
                    Checkbox(
                      value: tag.isSelected,
                      onChanged: (value) {
                        _selectItem(tag, value!);
                      },
                    ),
                    Text(tag.name),
                  ],
                );
              },
            ),
          ],
        ),

        */
