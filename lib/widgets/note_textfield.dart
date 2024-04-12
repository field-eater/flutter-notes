import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note_model.dart';

class NoteTextfield extends StatefulWidget {
  const NoteTextfield({super.key, this.note, required this.controller});

  final Note? note;
  final TextEditingController controller;

  @override
  _NoteTextfieldState createState() => _NoteTextfieldState();
}

class _NoteTextfieldState extends State<NoteTextfield> {
  late int _counterText = 0;
  var date = DateFormat.yMMMMd('en_US').format(DateTime.now()).toString();
  var updatedAt = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      widget.controller.text = widget.note!.description;
      _counterText = widget.note!.description.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (updatedAt.isNotEmpty) {
      updatedAt = DateFormat.yMMMMd('en_US')
          .format(DateTime.parse(updatedAt))
          .toString();
    }
    return Container(
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text("$date | ${_counterText.toString()} Characters"),
              ],
            ),
            TextField(
              controller: widget.controller,
              onChanged: (value) {
                setState(() {
                  _counterText = value.length;
                });
              },
              maxLines: null,
              maxLength: 5000,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            )
          ],
        ),
      ),
    );
  }
}
