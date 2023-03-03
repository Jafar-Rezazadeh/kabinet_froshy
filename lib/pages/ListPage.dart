import 'package:fluent_ui/fluent_ui.dart'
    hide Colors
    hide TextButton
    hide FilledButton;
import 'package:flutter/material.dart' hide showDialog;
import 'package:kabinet_froshy/classes/db_class.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 33, 33, 33),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () async {
                await showDialog<String>(
                  context: context,
                  builder: (context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: ContentDialog(
                        title: const Text('سابقه را برای همیشه پاک می کنید?'),
                        content: const Text(
                            'اگر سابقه را پاک کنید، نمی توانید آن را بازیابی کنید. میخوای پاکش کنی'),
                        actions: [
                          FilledButton(
                            child: const Text('حذف'),
                            onPressed: () {
                              database_K().deleteTbSold();
                              Navigator.pop(
                                context,
                              );

                              // Delete file here
                            },
                          ),
                          Button(
                            child: const Text('لغو'),
                            onPressed: () => Navigator.pop(
                              context,
                            ),
                          ),
                        ],
                      )),
                ).whenComplete(() {
                  setState(() {});
                });
              },
              child: const Text('پاک کردن سابقه'),
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "فروش ها",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // showing the sale history

              //Todo: change the datetime to local
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: FutureBuilder(
                      future: database_K().getTbSold(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Text("هنوز فروشی صورت نگرفته است.");
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black),
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                              child: DataTable(
                                border: TableBorder.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                columns: const [
                                  DataColumn(
                                      label: Expanded(child: Text("نام"))),
                                  DataColumn(
                                      label: Expanded(child: Text("تاریخ"))),
                                  DataColumn(
                                      label: Expanded(child: Text("تعداد"))),
                                  DataColumn(
                                      label: Expanded(child: Text("قیمت کل"))),
                                ],
                                rows: List.generate(snapshot.data!.length,
                                    (index) {
                                  //Todo: adding the shamsi package to change the date to shamsi
                                  DateTime dt = snapshot.data![index].date;
                                  final dtn = dt.toJalali();

                                  return DataRow(cells: [
                                    //name
                                    DataCell(
                                      Text(snapshot.data![index].name),
                                    ),
                                    //date
                                    DataCell(
                                      Text(
                                        "${dtn.formatter.yyyy}/${dtn.formatter.mm}/${dtn.formatter.dd}",
                                      ),
                                    ),
                                    //count
                                    DataCell(
                                      Text(snapshot.data![index].stock),
                                    ),
                                    //price
                                    DataCell(
                                      Text(snapshot.data![index].price),
                                    ),
                                  ]);
                                }),
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: Text("فروشی صورت نگرفته"),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
