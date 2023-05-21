import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pchat/helper/route_helper.dart';
import 'package:pchat/widgets/app_input_field.dart';
import 'package:pchat/widgets/app_text.dart';

Future showAppDilog(BuildContext context,
    {double height = 150, Widget? child}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          width: 270,
          height: height,
          child:
              Material(borderRadius: BorderRadius.circular(10), child: child),
        ),
      );
    },
  );
}

Future<String> showAddGroupDilog(BuildContext context) async {
  String groupName = "";
  await showAppDilog(
    context,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AppTextField(
            lableText: "Group Name",
            onChange: (value) => groupName = value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    goBack(context);
                  },
                  child: const AppText(
                    text: "Cancel",
                  )),
              ElevatedButton(
                  onPressed: () {
                    goBack(context);
                  },
                  child: const AppText(
                    text: "Create",
                  ))
            ],
          )
        ],
      ),
    ),
  );
  return groupName;
}

Future<Color> showColorPickerDilog(
    {required BuildContext context, required Color curentColor}) async {
  Color color = curentColor;
  await showAppDilog(
    context,
    height: 550,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ColorPicker(
            onColorChanged: (value) => color = value,
            pickerColor: color,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                goBack(context);
              },
              child: const AppText(
                text: "Take",
              ))
        ],
      ),
    ),
  );
  return color;
}
