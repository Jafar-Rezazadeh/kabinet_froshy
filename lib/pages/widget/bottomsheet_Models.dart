import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' hide ButtonState hide Colors;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kabinet_froshy/classes/db_class.dart';

//adding the kad model
class Addkab extends StatefulWidget {
  const Addkab({super.key});

  @override
  State<Addkab> createState() => _AddkabState();
}

class _AddkabState extends State<Addkab> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _stock = '';
  String _price = '';
  Uint8List? _imgsrc;

  FilePickerResult? result;

  Color elevatedBtnColor = const Color.fromARGB(255, 105, 240, 206);

  bool _imgreceived = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      margin: MediaQuery.of(context).size.width > 750
          ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("اضافه کردن مدل جدید"),
            //* model name
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "نام مدل",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _name = value.toString();
                        if (kDebugMode) {
                          print("name:$_name");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //* model count
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "تعداد",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _stock = value.toString();
                        if (kDebugMode) {
                          print("count:$_stock");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //*model price
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "قیمت",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _price = value.toString();
                        if (kDebugMode) {
                          print("price:$_price");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //* model picture
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: [
                //selecting image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: elevatedBtnColor),
                  onPressed: () async {
                    // Directory.current.delete();
                    result = await FilePicker.platform
                        .pickFiles(type: FileType.image, withData: true);

                    if (result != null) {
                      setState(() {
                        _imgreceived = true;
                        _imgsrc =
                            File(result!.files.single.path!).readAsBytesSync();
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text("اتخاب عکس"),
                ),

                //showing the img
                _imgreceived == true
                    ? Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.memory(_imgsrc!),
                        ),
                      )
                    : const Placeholder(
                        fallbackHeight: 200,
                        fallbackWidth: 200,
                      )
              ],
            ),
            //*submit button
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && result != null) {
                      _formKey.currentState?.save();

                      database_K().insertKabinetModels(KabinetModels(
                          name: _name,
                          price: _price,
                          stock: _stock,
                          picture: _imgsrc!.buffer.asUint8List()));

                      Navigator.pop(context);
                      //Todo
                    } else {
                      setState(() {
                        elevatedBtnColor = Colors.red;
                      });
                    }
                  },
                  child: const Text('اضافه کردن'),
                ),
                //*cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('لغو'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//

//updating the kad model
class Updatekab extends StatefulWidget {
  final KabinetModels kmodel;
  const Updatekab({super.key, required this.kmodel});

  @override
  _UpdatekabState createState() => _UpdatekabState();
}

class _UpdatekabState extends State<Updatekab> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _stock = '';
  String _price = '';
  Uint8List? _imgsrc;

  FilePickerResult? result;

  Color elevatedBtnColor = const Color.fromARGB(255, 105, 240, 206);

  bool _imgreceived = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      margin: MediaQuery.of(context).size.width > 750
          ? const EdgeInsets.symmetric(horizontal: 200, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("بروزرسانی مدل "),
            //* model name
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "نام مدل",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    placeholder: "نام مدل را وارد کنید...",
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _name = value.toString();
                        if (kDebugMode) {
                          print("name:$_name");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //* model stock
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "تعداد",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    placeholder: "تعداد را وارد کنید",
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _stock = value.toString();
                        if (kDebugMode) {
                          print("count:$_stock");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //*model price
            Directionality(
              textDirection: TextDirection.rtl,
              child: InfoLabel(
                label: "قیمت",
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormBox(
                    placeholder: "قیمت را وارد کنید",
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "فیلد متن خالی است";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _price = value.toString();
                        if (kDebugMode) {
                          print("price:$_price");
                        }
                      });
                    },
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            //* model picture
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: [
                //selecting image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: elevatedBtnColor),
                  onPressed: () async {
                    result = await FilePicker.platform
                        .pickFiles(type: FileType.image, withData: true);

                    if (result != null) {
                      setState(() {
                        _imgreceived = true;
                        _imgsrc =
                            File(result!.files.single.path!).readAsBytesSync();
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text("اتخاب عکس"),
                ),

                //showing the img
                _imgreceived == true
                    ? Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.memory(_imgsrc!),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.memory(widget.kmodel.picture),
                        ),
                      )
              ],
            ),
            //*submit button
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    if (result == null) {
                      _imgsrc = widget.kmodel.picture;
                    }
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();

                      database_K().updateKbDb(KabinetModels(
                          id: widget.kmodel.id,
                          name: _name,
                          price: _price,
                          stock: _stock,
                          picture: _imgsrc!.buffer.asUint8List()));

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('بروزرسانی'),
                ),
                //*cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('لغو'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
