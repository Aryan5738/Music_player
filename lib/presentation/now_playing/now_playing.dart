import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/application/favorite/favorite_bloc.dart';
import 'package:music_player/core/constants.dart';
import 'package:music_player/domain/model/data_model.dart';
import 'package:music_player/presentation/home/widgets/songs_list.dart';
import 'package:music_player/presentation/playlist/widgets/add_playlist.dart';
import 'package:music_player/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';

final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

//Current Playing Song at Home screen Bottom
class crntplayinghom extends StatefulWidget {
  const crntplayinghom({Key? key}) : super(key: key);

  @override
  State<crntplayinghom> createState() => _crntplayinghomState();
}

class _crntplayinghomState extends State<crntplayinghom> {
  bool songSkip = true;

  Widget audioImage(RealtimePlayingInfos realtimePlayingInfos) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: QueryArtworkWidget(
            keepOldArtwork: true,
            nullArtworkWidget: const Icon(
              Icons.music_note,
              color: white,
              size: 40,
            ),
            id: int.parse(realtimePlayingInfos.current!.audio.audio.metas.id!),
            type: ArtworkType.AUDIO));
  }

  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
            width: screenwidth - 25,
            height: 73,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: nowplayingbtm,
            ),
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: audioPlayer.builderRealtimePlayingInfos(
                builder: (context, realtimePlayingInfos) {
              if (realtimePlayingInfos != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const NowPlaying();
                              }));
                            },
                            child: Row(
                              children: [
                                audioImage(realtimePlayingInfos),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        audioPlayer.getCurrentAudioTitle,
                                        style: whitetxt15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        audioPlayer.getCurrentAudioArtist,
                                        style: white30txt12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0, right: 0),
                          child: Row(
                            children: [
                              realtimePlayingInfos.current!.audio.audio !=
                                      audioPlayer.playlist!.audios[0]
                                  ? IconButton(
                                      constraints: const BoxConstraints(),
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      onPressed: () async {
                                        if (songSkip) {
                                          songSkip = false;
                                          await audioPlayer.previous();
                                          songSkip = true;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                        color: white,
                                        size: 50,
                                      ))
                                  : IconButton(
                                      constraints: const BoxConstraints(),
                                      padding:
                                          const EdgeInsets.only(bottom: 25),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.skip_previous_rounded,
                                        color: Colors.grey.withOpacity(0.5),
                                        size: 50,
                                      )),
                              const SizedBox(
                                width: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: IconButton(
                                    // constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      realtimePlayingInfos.isPlaying
                                          ? audioPlayer.pause()
                                          : audioPlayer.play();
                                    },
                                    icon: Icon(
                                      realtimePlayingInfos.isPlaying
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      color: white,
                                      size: 55,
                                    )),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              realtimePlayingInfos.current!.audio.audio !=
                                      audioPlayer.playlist!.audios[(audioPlayer
                                              .playlist!.audios.length) -
                                          1]
                                  ? IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.only(
                                          right: 18, bottom: 25),
                                      onPressed: () async {
                                        if (songSkip) {
                                          songSkip = false;
                                          await audioPlayer.next();
                                          songSkip = true;
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.skip_next_rounded,
                                        color: white,
                                        size: 50,
                                      ))
                                  : IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.only(
                                          right: 18, bottom: 25),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.skip_next_rounded,
                                        color: Colors.grey.withOpacity(0.5),
                                        size: 50,
                                      )),
                            ],
                          ),
                        )
                      ],
                    ),
                    LinearProgressIndicator(
                      minHeight: 2,
                      value: audioPlayer.currentPosition.value.inSeconds /
                          realtimePlayingInfos.duration.inSeconds,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation(white),
                    ),
                  ],
                );
              } else {
                return Column();
              }
            })));
  }
}

// Seek to another position
seekplayer(int sec) {
  Duration position = Duration(seconds: sec);
  audioPlayer.seek(position);
}

// Get Time In Min:Sec
String getTimeString(int second) {
  String minutes =
      '${(second / 60).floor() < 10 ? 0 : ''}${(second / 60).floor()}';
  String seconds = '${second % 60 < 10 ? 0 : ''}${second % 60}';
  return '$minutes:$seconds';
}

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late BuildContext ctx;

  // Remove Song
  removeFav(List<audioModel> favSongsDatas) async {
    late int index;

    for (var element in favSongsDatas) {
      if (audioPlayer.getCurrentAudioTitle == element.songname) {
        index = favSongsDatas.indexOf(element);
        break;
      }
    }
    BlocProvider.of<FavoriteBloc>(context).add(DeleteFavSong(index: index));
  }

  addFav() async {
    late int index;
    for (var element in dbsongs) {
      if (audioPlayer.getCurrentAudioTitle == element.songname) {
        index = dbsongs.indexOf(element);
        break;
      }
    }
    BlocProvider.of<FavoriteBloc>(ctx)
        .add(AddFavToDb(songData: dbsongs[index]));
  }

  bool songSkip = true;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return audioPlayer.builderRealtimePlayingInfos(
        builder: (context, realtimePlayingInfos) {
      return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pexels-negative-space-97077.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.screen),
                opacity: 0.7)),
        child: BackdropFilter(
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
              body: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    //Song Image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            nullArtworkWidget: const SizedBox(
                              width: 300,
                              height: 300,
                              child: Icon(
                                Icons.music_note,
                                color: white,
                                size: 150,
                              ),
                            ),
                            artworkHeight: 300,
                            artworkWidth: 300,
                            id: int.parse(realtimePlayingInfos
                                .current!.audio.audio.metas.id!),
                            type: ArtworkType.AUDIO)),
                    const SizedBox(height: 30),
                    //Songs Name
                    SizedBox(
                      width: 200,
                      child: Text(
                        audioPlayer.getCurrentAudioTitle,
                        style: whitetxt22,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 30),

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
                            const SizedBox(
                              height: 20,
                            ),
                            //Favourites and playlists adding button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BlocBuilder<FavoriteBloc, FavoriteState>(
                                  builder: (context, state) {
                                    return IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            checkAdded(
                                                    audioPlayer
                                                        .getCurrentAudioTitle,
                                                    state.favSongList)
                                                ? removeFav(state.favSongList)
                                                : addFav();
                                          });
                                        },
                                        icon: checkAdded(
                                                audioPlayer
                                                    .getCurrentAudioTitle,
                                                state.favSongList)
                                            ? const Icon(
                                                Icons.favorite_rounded,
                                                color: Colors.red,
                                                size: 30,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline_rounded,
                                                color: white,
                                                size: 30,
                                              ));
                                  },
                                ),
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      int index;
                                      for (var element in dbsongs) {
                                        if (audioPlayer.getCurrentAudioTitle ==
                                            element.songname) {
                                          index = dbsongs.indexOf(element);
                                          addToPlaylist(
                                              context, dbsongs[index]);
                                          break;
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.playlist_play_rounded,
                                      color: white,
                                      size: 40,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),

                            //Slider bar
                            Slider(
                                max: realtimePlayingInfos.duration.inSeconds
                                    .toDouble(),
                                value: audioPlayer
                                    .currentPosition.value.inSeconds
                                    .toDouble(),
                                onChanged: (double value) {
                                  setState(() {
                                    seekplayer(value.toInt());
                                  });
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
                            const SizedBox(
                              height: 40,
                            ),
                            //Music Controllers

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                realtimePlayingInfos.current!.audio.audio !=
                                        audioPlayer.playlist!.audios[0]
                                    ? IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          if (songSkip) {
                                            songSkip = false;
                                            await audioPlayer.previous();
                                            songSkip = true;
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.skip_previous_rounded,
                                            color: white,
                                            size: 60))
                                    : IconButton(
                                        constraints: const BoxConstraints(),
                                        // padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.skip_previous_rounded,
                                          color: Colors.grey.withOpacity(0.5),
                                          size: 60,
                                        )),
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      realtimePlayingInfos.isPlaying
                                          ? audioPlayer.pause()
                                          : audioPlayer.play();
                                    },
                                    icon: Icon(
                                        realtimePlayingInfos.isPlaying
                                            ? Icons.pause_circle
                                            : Icons.play_circle_fill_rounded,
                                        color: white,
                                        size: 60)),
                                realtimePlayingInfos.current!.audio.audio !=
                                        audioPlayer.playlist!.audios[
                                            (audioPlayer
                                                    .playlist!.audios.length) -
                                                1]
                                    ? IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          if (songSkip) {
                                            songSkip = false;
                                            await audioPlayer.next();
                                            songSkip = true;
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.skip_next_rounded,
                                            color: white,
                                            size: 60))
                                    : IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {},
                                        icon: Icon(Icons.skip_next_rounded,
                                            color: Colors.grey.withOpacity(0.5),
                                            size: 60)),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }
}