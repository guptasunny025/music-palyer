// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:music_player/music_player.dart';

// class Tracks extends StatefulWidget {
//   _TracksState createState() => _TracksState();
// }

// class _TracksState extends State<Tracks> {
//   final FlutterAudioQuery audioQuery = FlutterAudioQuery();
//   List songs = [
//     {
//       'artist': 'sunny',
//       'songname': 'song 1',
//       'track': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       'image':
//           'https://c1.wallpaperflare.com/preview/73/599/584/headphones-music-ear-defender-yellow.jpg'
//     },
//     {
//       'artist': 'sunny1',
//       'songname': 'song 2',
//       'track':
//           'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_5MG.mp3',
//       'image':
//           'https://c1.wallpaperflare.com/preview/73/599/584/headphones-music-ear-defender-yellow.jpg'
//     }
//   ];

//   int currentIndex = 0;
//   final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
//   void initState() {
//     super.initState();
//     //  getTracks();
//   }

//   // void getTracks() async {
//   //   songs = await audioQuery.getSongs();
//   //   setState(() {
//   //     songs = songs;
//   //   });
//   // }

//   void changeTrack(bool isNext) {
//     if (isNext) {
//       if (currentIndex != songs.length - 1) {
//         currentIndex++;
//       }
//     } else {
//       if (currentIndex != 0) {
//         currentIndex--;
//       }
//     }
//     key.currentState.setSong(songs[currentIndex]['track']);
//   }

//   Widget build(context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: Icon(Icons.music_note, color: Colors.black),
//           title: Text('Music App', style: TextStyle(color: Colors.black)),
//         ),
//         body: Container(
//           width: double.infinity,
//           height: 400,
//           child: ListView.separated(
//             separatorBuilder: (context, index) => Divider(),
//             itemCount: songs.length,
//             itemBuilder: (context, index) => ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: songs[index]['image'] == null
//                     ? AssetImage('assets/images/music_gradient.jpg')
//                     : NetworkImage((songs[index]['image'])),
//               ),
//               title: Text(songs[index]['songname']),
//               subtitle: Text(songs[index]['artist']),
//               onTap: () {
//                 currentIndex = index;
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => MusicPlayer(
//                         changeTrack: changeTrack,
//                         songInfo: songs[currentIndex]['track'],
//                         key: key)));
//               },
//             ),
//           ),
//         ));
//   }
// }
// //
