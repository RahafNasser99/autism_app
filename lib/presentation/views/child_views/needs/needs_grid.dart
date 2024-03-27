import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:autism_mobile_app/domain/models/need_expression_models/need.dart';

class NeedsGrid extends StatefulWidget {
  NeedsGrid({
    Key? key,
    required this.needs,
    required this.width,
    required this.selectNeeds,
    required this.getNeeds,
  }) : super(key: key);

  final List<Need> needs;
  final double width;
  final Function selectNeeds;
  final Function getNeeds;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  State<NeedsGrid> createState() => _NeedsGridState();
}

class _NeedsGridState extends State<NeedsGrid> {
  Widget _gridTile(Need need) {
    return GridTile(
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2.0,
                blurRadius: 1.0,
              )
            ],
            image: need.needContent.content.contains('.')
                ? DecorationImage(
                    image: NetworkImage(need.needContent.content),
                    fit: BoxFit.fill)
                : null,
          ),
          child: !need.needContent.content.contains('.')
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: Center(
                      child: AutoSizeText(
                        need.needContent.content,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
        onTap: () async {
          widget.selectNeeds(need);
          if (need.soundNeedContent != null) {
            await widget.audioPlayer.setUrl(need.soundNeedContent!.content);
            await widget.audioPlayer.play(need.soundNeedContent!.content);
          }
          widget.getNeeds(need.needId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(10.0),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: widget.needs.length,
        itemBuilder: (ctx, index) => _gridTile(widget.needs[index]));
  }
}
