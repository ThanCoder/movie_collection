import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class TCoverComponents extends StatefulWidget {
  String coverPath;
  TCoverComponents({super.key, required this.coverPath});

  @override
  State<TCoverComponents> createState() => _CoverComponentsState();
}

class _CoverComponentsState extends State<TCoverComponents> {
  bool isLoading = false;
  late String imagePath;

  @override
  void initState() {
    imagePath = widget.coverPath;
    super.initState();
  }

  void _downloadUrl() {
    showDialog(
      context: context,
      builder: (context) => TRenameDialog(
        renameLabelText: Text('Download From Url'),
        submitText: 'Download',
        text: '',
        onCancel: () {},
        onSubmit: (url) async {
          try {
            setState(() {
              isLoading = true;
            });
            await Dio().download(url, widget.coverPath);

            if (!mounted) return;
            setState(() {
              isLoading = false;
            });
          } catch (e) {
            if (!mounted) return;
            setState(() {
              isLoading = false;
            });
          }
        },
      ),
    );
  }

  void _addFromPath() async {
    try {
      setState(() {
        isLoading = true;
      });
      final files = await openFiles(
        acceptedTypeGroups: [
          XTypeGroup(mimeTypes: [
            'image/png',
            'image/jpg',
            'image/webp',
            'image/jpeg'
          ]),
        ],
      );
      if (files.isNotEmpty) {
        final path = files.first.path;
        final file = File(path);
        if (widget.coverPath.isNotEmpty) {
          await file.copy(widget.coverPath);
          // clear image cache
          await AppUtil.instance.clearImageCache();
        }
        imagePath = path;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onDrop(DropDoneDetails details) async {
    if (details.files.isEmpty) return;
    final path = details.files.first.path;
    final mime = lookupMimeType(path) ?? '';
    if (!mime.startsWith('image')) return;
    setState(() {
      isLoading = true;
    });
    final file = File(path);
    if (widget.coverPath.isNotEmpty) {
      await file.copy(widget.coverPath);
      // clear image cache
      await AppUtil.instance.clearImageCache();
    }
    imagePath = path;
    setState(() {
      isLoading = false;
    });
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _addFromPath();
                },
                leading: const Icon(Icons.add),
                title: const Text('Add From Path'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _downloadUrl();
                },
                leading: const Icon(Icons.add),
                title: const Text('Add From Url'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: _onDrop,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _showMenu,
          child: SizedBox(
            width: 150,
            height: 150,
            child: isLoading
                ? TLoader()
                : TImageFile(
                    path: imagePath,
                    borderRadius: 5,
                  ),
          ),
        ),
      ),
    );
  }
}
