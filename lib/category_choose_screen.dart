import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:music_player/provider/songsProvider.dart';
import 'package:provider/provider.dart';

class CategoryChooseScreen extends StatefulWidget {
  @override
  _CategoryChooseScreenState createState() => _CategoryChooseScreenState();
}

class _CategoryChooseScreenState extends State<CategoryChooseScreen> {
  int _groupValue = -1;
  dynamic id;
  bool choosedvalue = false;
  List category = [
    {'Answer': 'Film Music', 'CheckBox': 0},
    {'Answer': 'Meditation', 'CheckBox': 1},
    {'Answer': 'Ram Raksha', 'CheckBox': 2},
  ];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            color: Color(0xFFBEB1FF),
            width: double.infinity,
            height: deviceSize.height / 4 * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: deviceSize.width / 2 * .9,
                  height: deviceSize.height / 4 / 4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 2,
                      left: deviceSize.width / 3 * .9,
                      right: deviceSize.width / 3 * .9),
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text('Music Category',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceSize.height / 4 / 4 / 2,
          ),
          FutureBuilder(
              future: Provider.of<SongsProvider>(context, listen: false)
                  .getcategory(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.length == 0) {
                  return Container(
                    height: deviceSize.height / 4 / 2,
                    child: Center(
                      child: Text('No Category Found'),
                    ),
                  );
                }
                print(snapshot.data['category_details']);
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data['category_details'].length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index1) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: deviceSize.width / 4 / 4, top: 8),
                        child: RadioListTile(
                            activeColor: Color(0xFF1E18CA),
                            title: Text(snapshot.data['category_details']
                                [index1]['cat_name']),
                            value: 0,
                            groupValue: _groupValue,
                            onChanged: (_value) {
                              setState(() {
                                _groupValue = _value;
                                choosedvalue = true;
                                // snapshot.data['category_details'][index1] =
                                //     true;
                                id = snapshot.data['category_details'][index1]
                                    ['cat_id'];
                              });
                            }),
                      );
                    });
              }),
          Container(
            margin: EdgeInsets.only(top: deviceSize.height / 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Card(
                    elevation: 2,
                    color: Color(0xFFFFA6A6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      width: deviceSize.width / 4 * .9,
                      height: deviceSize.height / 4 / 4 * .8,
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  onTap: () async {
                    if (_groupValue != -1) {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) {
                        return MusicPlayer(catID: id);
                      }));
                    }
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
