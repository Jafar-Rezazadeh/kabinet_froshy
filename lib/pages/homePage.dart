import 'package:fluent_ui/fluent_ui.dart'
    hide TextButton
    hide IconButton
    hide Colors
    hide Divider
    hide Scrollbar
    hide FilledButton;
import 'package:flutter/material.dart' hide Card hide showDialog;
import 'package:kabinet_froshy/classes/db_class.dart';
import 'package:kabinet_froshy/pages/widget/bottomsheet_Models.dart';
import 'package:kabinet_froshy/pages/widget/sell_ui_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  double _offset = 0;

  bool upDownButtonVisibility = true;
  final ScrollController _controller = ScrollController();

// list items

  //? custom card widget
  Widget cards(context, index, List<KabinetModels> snapshot) {
    // Convert to UriData
    return Stack(
      children: [
        Card(
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            children: [
              //* card details
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MediaQuery.of(context).size.width > 750
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                                width: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(snapshot[index].picture),
                                )))
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(snapshot[index].picture),
                                ))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(snapshot[index].name),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("موجود: ${snapshot[index].stock}"),
                        Text("قیمت: ${snapshot[index].price} تومان ",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // *action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //update
                  IconButton(
                    splashRadius: 20,
                    hoverColor: Colors.grey,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.black87,
                        context: context,
                        builder: (context) {
                          return Updatekab(kmodel: snapshot[index]);
                        },
                      ).whenComplete(() {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.update),
                  ),
                  //delele
                  IconButton(
                      hoverColor: Colors.red,
                      splashRadius: 20,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDeleteDialog(context, index, snapshot);
                      }),
                  //sell
                  IconButton(
                    hoverColor: Colors.blueAccent,
                    splashRadius: 20,
                    icon: const Icon(Icons.sell),
                    onPressed: () {
                      showSellDialog(context, index, snapshot[index]);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDeleteDialog(context, i, List<KabinetModels> snapshot) async {
    await showDialog<String>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: ContentDialog(
          title: const Text('فایل را برای همیشه حذف می کنید?'),
          content: const Text(
              'اگر این مدل را حذف کنید، نمی توانید آن را بازیابی کنید. میخوای حذفش کنی'),
          actions: [
            FilledButton(
              child: const Text('حذف'),
              onPressed: () {
                database_K().deleteKM(snapshot[i].id!);
                Navigator.pop(context, 'User deleted file');

                // Delete file here
              },
            ),
            Button(
              child: const Text('لغو'),
              onPressed: () => Navigator.pop(context, 'User canceled dialog'),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() {});
    });
  }

  //
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // database_K().insertKabinetModels(const KabinetModels(
    //     name: "jaa", price: "akjhd", stock: "ahjgd", id: 1));

    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.black87,
              context: context,
              builder: (context) {
                return const Addkab();
              },
            ).whenComplete(() {
              setState(() {});
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,

      key: _scaffoldkey,
      //our main home page screen
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: FutureBuilder(
              future: database_K().getKmodels(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                            ".لطفا با استفاده از دکمه (افزودن) مدلی را اضافه کنید"));
                  }
                  return Scrollbar(
                    thickness: 20,
                    controller: _controller,
                    thumbVisibility: true,
                    radius: const Radius.circular(20),
                    child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return cards(context, index, snapshot.data!);
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
