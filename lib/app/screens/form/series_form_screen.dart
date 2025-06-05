import 'package:flutter/material.dart';
import 'package:mc_v2/app/components/t_cover_components.dart';
import 'package:mc_v2/app/models/video_item.dart';
import 'package:mc_v2/app/screens/content/season_viewer.dart';
import 'package:mc_v2/app/screens/form/season_form/season_form_screen.dart';
import 'package:t_widgets/widgets/index.dart';

class SeriesFormScreen extends StatefulWidget {
  VideoItem video;
  SeriesFormScreen({
    super.key,
    required this.video,
  });

  @override
  State<SeriesFormScreen> createState() => _SeriesFormScreenState();
}

class _SeriesFormScreenState extends State<SeriesFormScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  late VideoItem video;

  @override
  void initState() {
    video = widget.video;
    super.initState();
    init();
  }

  void init() {
    titleController.text = video.title;
    descController.text = video.description;
  }

  void _save() async {
    video.title = titleController.text;
    video.description = descController.text;
    video.date = DateTime.now();
    //update
    await widget.video.update(video);

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _addSeason() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeasonFormScreen(
          video: video,
          onRefersh: (video) {
            this.video = video;
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Series Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            // cover
            SliverToBoxAdapter(
              child: TCoverComponents(coverPath: video.coverPath),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverToBoxAdapter(
              child: Column(
                spacing: 5,
                children: [
                  TTextField(
                    label: Text('Title'),
                    controller: titleController,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            // season
            SliverToBoxAdapter(
              child: SeasonViewer(video: video),
            ),

            SliverToBoxAdapter(
              child: IconButton.filled(
                // color: Colors.green,
                onPressed: _addSeason,
                icon: Icon(Icons.add),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            // desc
            SliverToBoxAdapter(
              child: TTextField(
                label: Text('Description'),
                controller: descController,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: Icon(Icons.save),
      ),
    );
  }
}
