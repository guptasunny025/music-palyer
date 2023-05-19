import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/login_screen.dart';
import 'package:music_player/provider/auth.dart';
import 'package:music_player/provider/songsProvider.dart';
import 'package:provider/provider.dart';

String status = 'hidden';
// AudioPlayer audioPlayer;

typedef void OnError(Exception exception);

class MusicPlayer extends StatefulWidget {
  final dynamic catID;

  MusicPlayer({this.catID});
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double currentValue = 0.0;
  double minimumValue = 00.0;
  Duration duration;
  double maximumValue = 10.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  int playindex;
  AudioPlayer player = AudioPlayer();
  bool isloop = false;
  List songs = [];
  String trackname;
  String tracklength;
  bool isStartPlating = false;
  bool playAll = false;
  var isLoad = true;
  var isLoading = true;
  var songLoading = true;
  AudioPlayer audioPlayer = AudioPlayer();

  List songslength = [];
  // getsongslength() async {
  //   for (int i = 0; i > songs.length; i++) {
  //     await audioPlayer.setUrl(
  //         'http://yudoo.in/musicapp/uploads/Tune/' + songs[0]['tune_file']);
  //     // audioPlayer.durationStream.listen((Duration d) async {
  //     //   print(d.inMinutes);
  //     //   await songslength.add(d.inMinutes);
  //     //   // audioPlayer.stop();
  //     //   print(songslength);
  //     // });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //   return songslength;
  // }

  getSongList() async {
    await Provider.of<SongsProvider>(context, listen: false)
        .getsong(widget.catID);
    if (Provider.of<SongsProvider>(context, listen: false).isSOng == true) {
      songs =
          await Provider.of<SongsProvider>(context, listen: false).getsonglist;
    } else {
      songs.length = 0;
    }

    setState(() {
      songLoading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () async {
        setState(() {
          MediaNotification.hideNotification();
        });
        // Navigator.pop(context);
        await SystemChannels.platform
            .invokeMethod<void>('SystemNavigator.pop')
            .then((value) => Navigator.pop(context));
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        // await SystemNavigator.pop().then((value) => AppLifecycleState.detached);
        await MinimizeApp.minimizeApp();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Are you want to play music in background"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void initState() {
    super.initState();
    //s initAudioPlayer();
    getSongList();
    //  getsongslength();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff1c252a),
      statusBarColor: Colors.transparent,
    ));

    MediaNotification.setListener('play', () {
      status = 'play';
      player.play();
      setState(() {
        isPlaying = !isPlaying;
      });
    });

    MediaNotification.setListener('pause', () {
      status = 'pause';
      player.pause();
      setState(() {
        isPlaying = !isPlaying;
      });
    });

    MediaNotification.setListener("close", () {
      // audioPlayer.stop();
      // dispose();

      MediaNotification.hideNotification();
    });
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(index) async {
    // widget.songInfo=songInfo;
    await player.setUrl(
        'http://yudoo.in/musicapp/uploads/Tune/' + songs[index]['tune_file']);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();

    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
      MediaNotification.showNotification(
          title: songs[playindex]['tun_name'],
          author: songs[playindex]['tun_name'],
          artUri:
              'https://c1.wallpaperflare.com/preview/73/599/584/headphones-music-ear-defender-yellow.jpg',
          isPlaying: true);
    } else {
      player.pause();
      MediaNotification.showNotification(
          title: songs[playindex]['tun_name'],
          author: songs[playindex]['tun_name'],
          artUri:
              'https://c1.wallpaperflare.com/preview/73/599/584/headphones-music-ear-defender-yellow.jpg',
          isPlaying: false);
    }
  }

  String getDuration(double value) {
    duration = Duration(milliseconds: value.roundToDouble().round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (playindex != songs.length - 1) {
        playindex++;
      }
    } else {
      if (playindex != 0) {
        playindex--;
      }
    }
    // key.currentState.setSong(songs[currentIndex]['track']);
  }

  Widget build(context) {
    final deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        return showAlertDialog(context);
      },
      child: Scaffold(
          body: SafeArea(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
              child: Card(
                elevation: 3,
                color: Color(0xFFFCA6A5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(
                    right: deviceSize.width / 4 / 4,
                    top: deviceSize.height / 4 / 4 / 4),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text('LogOut',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              onTap: () async {
                await Provider.of<Auth>(context, listen: false).logout();

                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx) {
                  return LoginScreen();
                }));
              },
            )
          ]),
          Container(
            margin: EdgeInsets.only(
                // left: deviceSize.width / 4 / 4,
                // right: deviceSize.width / 4 / 4,
                top: deviceSize.width / 4 / 4),
            //color: Colors.yellow,
            child: isPlaying == true
                ? Image.asset(
                    "assets/visualizer.gif",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    repeat: ImageRepeat.repeat,
                  )
                : Image.asset(
                    'assets/static.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
            width: deviceSize.width * .7,
            height: deviceSize.width / 2 * .6,
          ),
          Container(
            margin: EdgeInsets.only(top: deviceSize.width / 4 / 4),
            child: Text(trackname == null ? 'Play Now' : trackname),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: deviceSize.width / 4 / 4,
                  right: deviceSize.width / 4 / 4,
                  top: deviceSize.width / 4 / 4 / 2),
              child: Slider(
                inactiveColor: Colors.black12,
                activeColor: Colors.black,
                min: minimumValue,
                max: duration != null
                    ? maximumValue
                    : isPlaying == true
                        ? duration.inMilliseconds.toDouble()
                        : maximumValue,
                value: currentValue,
                onChanged: (value) {
                  currentValue = value;
                  // player.playerStateStream.listen((state) {
                  //   if (state.playing) {
                  //     state.processingState == ProcessingState.completed
                  //         ? isPlaying = !isPlaying
                  //         : null;
                  //   }
                  // });
                  return player
                      .seek(Duration(milliseconds: currentValue.round()));
                },
              )),
          Container(
            transform: Matrix4.translationValues(0, -15, 0),
            margin: EdgeInsets.fromLTRB(
                deviceSize.width / 4 / 3,
                deviceSize.width / 4 / 4 / 2,
                deviceSize.width / 4 / 3,
                deviceSize.width / 4 / 4 / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text(endTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child:
                      Icon(Icons.skip_previous, color: Colors.black, size: 50),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    changeTrack(false);
                    setSong(playindex);
                    setState(() {
                      trackname = songs[playindex]['songname'];
                    });
                  },
                ),
                GestureDetector(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: Colors.black,
                      size: 70),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (isStartPlating == true) {
                      changeStatus();
                    }
                  },
                ),
                GestureDetector(
                  child: Icon(Icons.skip_next, color: Colors.black, size: 50),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    changeTrack(true);
                    setSong(playindex);
                    setState(() {
                      trackname = songs[playindex]['songname'];
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: deviceSize.width / 4 / 4 / 2,
            ),
            width: double.infinity,
            height: deviceSize.width / 4 * .7,
            alignment: Alignment.center,
            color: Color(0xFFF0E8F2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(songs.length.toString() + ' tracks'),
                IconButton(
                    icon: isloop == true
                        ? Icon(Icons.repeat_one)
                        : Icon(Icons.loop),
                    onPressed: () async {
                      setState(() {
                        isloop = !isloop;
                      });
                      print(isloop);
                      isloop == true
                          ? player.playerStateStream.listen((state) {
                              if (state.playing) {
                                state.processingState ==
                                        ProcessingState.completed
                                    ? setSong(playindex)
                                    : null;
                              }
                            })
                          : null;
                    }),
                GestureDetector(
                  child: Card(
                    color: Color(0xFFFF8A01),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      width: deviceSize.width / 3,
                      alignment: Alignment.center,
                      height: deviceSize.width / 4 / 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'Play All',
                        style: TextStyle(
                            color: playAll == false
                                ? Colors.white
                                : Colors.green[700],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      playAll = !playAll;
                    });
                    playAll == true
                        ? player.playerStateStream.listen((state) {
                            if (state.playing) {
                              state.processingState == ProcessingState.completed
                                  ? setSong(playindex)
                                  : null;
                            }
                          })
                        : null;
                  },
                )
              ],
            ),
          ),
          Expanded(
              child: Stack(children: [
            Container(
              width: double.infinity,
              child: Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: deviceSize.width / 2,
                      color: Colors.white,
                    ),
                    Container(
                      width: deviceSize.width / 2,
                      color: Color(0xFFE4EEFD),
                    )
                  ],
                ),
              ),
            ),
            songLoading == false
                ? songs.length == 0
                    ? Center(
                        child: Text('No Songs Found'),
                      )
                    : ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (ctx, index) {
                          print(songslength);
                          int count = index;
                          //print(songlist);
                          return Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                isPlaying == false
                                    ? Container(
                                        width: deviceSize.width / 4 / 2,
                                        height: deviceSize.width / 4 / 2,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            top: 10,
                                            left: deviceSize.width / 4 / 4,
                                            right: deviceSize.width / 4 / 4),
                                        child: Text(
                                          ('0${count + 1}').toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF01A2FF),
                                            shape: BoxShape.circle),
                                      )
                                    : Container(
                                        width: deviceSize.width / 4 / 2,
                                        height: deviceSize.width / 4 / 2,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            top: 10,
                                            left: deviceSize.width / 4 / 4,
                                            right: deviceSize.width / 4 / 4),
                                        child: Image.asset(
                                          "assets/visualizer.gif",
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          repeat: ImageRepeat.repeat,
                                        ),
                                      ),
                                Expanded(
                                    child: Stack(
                                  overflow: Overflow.visible,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            deviceSize.width / 4 / 4,
                                            10,
                                            0,
                                            10),
                                        //width: double.infinity,
                                        height: deviceSize.height / 4 / 2 * .8,
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              //  direction: Axis.vertical,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: deviceSize.width /
                                                            4 /
                                                            2,
                                                        top: 7),
                                                    child: Text(
                                                      songs[index]['tun_name'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: deviceSize.width /
                                                            4 /
                                                            2,
                                                        top: 7),
                                                    child: Text(
                                                      duration == null
                                                          ? ''
                                                          : endTime,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )),
                                              ],
                                            ),
                                            Container(
                                                margin: EdgeInsets.all(10),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFCCDEFC),
                                            border:
                                                Border.all(color: Colors.blue),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                topLeft: Radius.circular(15))),
                                      ),
                                      onTap: () async {
                                        setSong(index);
                                        isStartPlating = true;
                                        playindex = index;
                                        setState(() {
                                          trackname = songs[index]['tun_name'];
                                        });
                                      },
                                    ),
                                    Positioned(
                                      left: -5,
                                      top: deviceSize.width / 4 / 4 * .9,
                                      child: Container(
                                        width: deviceSize.width / 4 * .7,
                                        height: deviceSize.height / 4 / 3 * .9,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(songs[index]
                                                          ['tun_icon'] ==
                                                      ""
                                                  ? 'https://songdewnetwork.com/sgmedia/assets/images/default-album-art.png'
                                                  : 'http://yudoo.in/musicapp/uploads/icon/' +
                                                      songs[index]['tun_icon']),
                                              fit: BoxFit.fill),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        padding: EdgeInsets.only(right: 10),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          );
                        })
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ])),
        ],
      ))),
    );
  }
}
