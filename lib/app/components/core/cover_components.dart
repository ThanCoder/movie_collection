import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:movie_collections/app/components/drop_filepath_container.dart';

import '../../dialogs/core/index.dart';
import '../../services/core/app_services.dart';
import '../../widgets/index.dart';
import '../index.dart';

class CoverComponents extends StatefulWidget {
  String coverPath;
  CoverComponents({super.key, required this.coverPath});

  @override
  State<CoverComponents> createState() => _CoverComponentsState();
}

class _CoverComponentsState extends State<CoverComponents> {
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
      builder: (context) => RenameDialog(
        renameLabelText: Text('Download From Url'),
        submitText: 'Download',
        renameText: '',
        onCancel: () {},
        onSubmit: (url) async {
          try {
            setState(() {
              isLoading = true;
            });
            await Dio().download(url, widget.coverPath);

            setState(() {
              isLoading = false;
            });
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            _showMsg(e.toString());
          }
        },
      ),
    );
  }

  void _showMsg(String msg) {
    showDialogMessage(context, msg);
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
      if (files.isEmpty) return;

      final path = files.first.path;
      final file = File(path);
      if (widget.coverPath.isNotEmpty && await file.exists()) {
        await file.copy(widget.coverPath);
        // clear image cache
        await clearAndRefreshImage();
        await Future.delayed(Duration(seconds: 1));

        imagePath = path;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void _delete() async {
    setState(() {
      isLoading = true;
    });

    if (widget.coverPath.isNotEmpty) {
      final file = File(widget.coverPath);
      if (!await file.exists()) return;

      await file.delete();
      // clear image cache
      await clearAndRefreshImage();
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
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
            ListTile(
              onTap: () {
                Navigator.pop(context);
                _delete();
              },
              iconColor: Colors.red,
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropFilepathContainer(
      onDroped: (items) async {
        setState(() {
          isLoading = true;
        });
        final path = items.first.path;
        final mime = lookupMimeType(path);
        if (mime == null || !mime.startsWith('image')) return;
        final file = File(path);
        if (widget.coverPath.isNotEmpty && await file.exists()) {
          await file.copy(widget.coverPath);
          // clear image cache
          await clearAndRefreshImage();
          await Future.delayed(Duration(seconds: 1));

          imagePath = path;
          setState(() {
            isLoading = false;
          });
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _showMenu,
          child: SizedBox(
            width: 150,
            height: 150,
            child: isLoading
                ? TLoader()
                : MyImageFile(
                    path: imagePath,
                    borderRadius: 5,
                  ),
          ),
        ),
      ),
    );
  }
}
