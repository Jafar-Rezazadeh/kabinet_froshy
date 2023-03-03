import 'package:fluent_ui/fluent_ui.dart' hide Colors hide FilledButton;
import 'package:flutter/material.dart' hide showDialog hide ButtonStyle;
import 'package:flutter/services.dart';
import 'package:kabinet_froshy/classes/db_class.dart';

void showSellDialog(BuildContext context, i, KabinetModels kmodel) async {
  String price = "";
  String stock = "";

  final formKey = GlobalKey<FormState>();
  await showDialog<String>(
    context: context,
    builder: (context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 400, vertical: 150),
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black87,
      ),
      alignment: Alignment.center,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // contents
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    kmodel.picture,
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(width: 20),
                //price and stock
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //price
                      InfoLabel(
                        label: "قیمت",
                        child: SizedBox(
                          width: 100,
                          child: TextFormBox(
                            placeholder: "قیمت را وارد کنید",
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "فیلد خالی است";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              price = newValue!;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      //stock
                      InfoLabel(
                        label: "تعداد",
                        child: SizedBox(
                          width: 100,
                          child: TextFormBox(
                            placeholder: "تعداد را وارد کنید",
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "فیلد خالی است";
                              }
                              int stk = int.parse(kmodel.stock);
                              if (int.parse(value) > stk) {
                                return "$stk عدد ${kmodel.name} موجود است";
                              }
                              if (stk == 0) {
                                return "${kmodel.name} موجود نیست";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              stock = newValue!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //*action buttons
            SizedBox(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //submit
                    FilledButton(
                      onPressed: (() {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          database_K().insertTbSold(kSold(
                              name: kmodel.name,
                              price: (int.parse(price) * int.parse(stock))
                                  .toString(),
                              stock: stock,
                              date: DateTime.now().toLocal()));
                          int a = int.parse(kmodel.stock) - int.parse(stock);

                          database_K().updateKbDb(KabinetModels(
                              id: kmodel.id,
                              name: kmodel.name,
                              price: kmodel.price,
                              stock: a.toString(),
                              picture: kmodel.picture));
                          Navigator.pop(context);
                        }
                      }),
                      child: const Text("فروش"),
                    ),
                    const SizedBox(width: 40),
                    //cancel
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("لغو"),
                      onPressed: () {
                        //...
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
