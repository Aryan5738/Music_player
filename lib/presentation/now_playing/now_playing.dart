import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants.dart';
import 'package:music_player/presentation/now_playing/widgets/add_fav_button.dart';
import 'package:music_player/presentation/now_playing/widgets/add_playlist_button.dart';
import 'package:music_player/presentation/now_playing/widgets/song_controllers.dart';
import 'package:music_player/presentation/now_playing/widgets/song_image.dart';
import 'package:on_audio_query/on_audio_query.dart';

final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

// Seek to another position
seekplayer(int sec) async {
  Duration position = Duration(seconds: sec);
  await audioPlayer.seek(position);
}

// Get Time In Min:Sec
String getTimeString(int second) {
  String minutes =
      '${(second / 60).floor() < 10 ? 0 : ''}${(second / 60).floor()}';
  String seconds = '${second % 60 < 10 ? 0 : ''}${second % 60}';
  return '$minutes:$seconds';
}

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return audioPlayer.builderRealtimePlayingInfos(
        builder: (context, realtimePlayingInfos) {
      return Stack(
        children: [
          QueryArtworkWidget(
              keepOldArtwork: true,
              nullArtworkWidget: Container(),
              artworkHeight: double.infinity,
              artworkWidth: double.infinity,
              id: int.parse(
                  realtimePlayingInfos.current!.audio.audio.metas.id!),
              type: ArtworkType.AUDIO),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Scaffold(
                backgroundColor: Colors.transparent,

                //Appbar
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: const Text('Now Playing'),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ),
                body: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.04),

                      // Song Image
                      SongImageWidget(
                        realtimePlayingInfos: realtimePlayingInfos,
                      ),

                      SizedBox(height: screenSize.height * 0.035),

                      //Songs Name
                      SizedBox(
                        width: 200,
                        child: Text(
                          audioPlayer.getCurrentAudioTitle,
                          style: whitetxt22,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.035),

                      //Bottom controls Container
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: cardshomecolor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.025,
                              ),
                              //Favourites and playlists adding button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Add Favorites Button
                                  AddFavButtonWidget(),

                                  // Add Playlist Button
                                  const AddPlaylistButtonWidget()
                                ],
                              ),
                              SizedBox(
                                height: screenSize.height * 0.045,
                              ),

                              //Slider bar
                              Slider(
                                  max: realtimePlayingInfos.duration.inSeconds
                                      .toDouble(),
                                  value: audioPlayer
                                      .currentPosition.value.inSeconds
                                      .toDouble(),
                                  onChanged: (double value) {
                                    seekplayer(value.toInt());
                                  }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        getTimeString(realtimePlayingInfos
                                            .currentPosition.inSeconds),
                                        style: white54txt14),
                                    Text(
                                      getTimeString(realtimePlayingInfos
                                          .duration.inSeconds),
                                      style: white54txt14,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.045,
                              ),
                              //Music Controllers

                              SongControllerWidget(
                                  realtimePlayingInfos: realtimePlayingInfos)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      );
    });
  }
}
