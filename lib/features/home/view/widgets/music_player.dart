import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_frontend/core/providers/current_song_notifier.dart';
import 'package:spotify_clone_frontend/core/theme/app_pallete.dart';
import 'package:spotify_clone_frontend/core/utils.dart';
import 'package:spotify_clone_frontend/features/home/viewmodel/home_viewmodel.dart';

class MusicPlayer extends ConsumerWidget {
  // final SongModel song;
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hexToColor(currentSong!.hex_code),
            const Color(0xFF121212),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: "music-image",
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          currentSong.thumbnail_url,
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () async {
                          await ref.read(homeViewModelProvider.notifier).favSong(
                                songId: currentSong.id,
                              );
                        },
                        icon: const Icon(CupertinoIcons.heart),
                        color: Pallete.whiteColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                      stream: songNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox();
                          // return const LinearProgressIndicator(
                          //   value: 0.5,
                          //   backgroundColor: Pallete.whiteColor.withOpacity(0.117),
                          // );
                        }
                        final position = snapshot.data;
                        final duration = songNotifier.audioPlayer!.duration;
                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue = position.inMilliseconds / duration.inMilliseconds;
                        }
                        return Column(
                          children: [
                            // StatefulBuilder(
                            //   builder: (context, setState) => SliderTheme(
                            //     data: SliderTheme.of(context).copyWith(
                            //       activeTrackColor: Pallete.whiteColor,
                            //       inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                            //       thumbColor: Pallete.whiteColor,
                            //       trackHeight: 4,
                            //       overlayShape: SliderComponentShape.noOverlay,
                            //     ),
                            //     child: Slider(
                            //       value: sliderValue,
                            //       min: 0,
                            //       max: 1,
                            //       onChanged: (val) {
                            //         sliderValue = val;
                            //         setState(() {});
                            //       },
                            //       onChangeEnd: songNotifier.seek,
                            //     ),
                            //   ),
                            // ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Pallete.whiteColor,
                                inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                                thumbColor: Pallete.whiteColor,
                                trackHeight: 4,
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value: sliderValue,
                                min: 0,
                                max: 1,
                                onChanged: (val) {
                                  sliderValue = val;
                                },
                                onChangeEnd: songNotifier.seek,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${position?.inMinutes}:${(position?.inSeconds ?? 0) % 60 < 10 ? "0${position!.inSeconds % 60}" : position!.inSeconds % 60}",
                                  style: const TextStyle(color: Pallete.subtitleText, fontSize: 13, fontWeight: FontWeight.w300),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  "${duration?.inMinutes}:${(duration?.inSeconds ?? 0) % 60 < 10 ? "0${duration!.inSeconds % 60}" : duration!.inSeconds % 60}",
                                  style: const TextStyle(color: Pallete.subtitleText, fontSize: 13, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/shuffle.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/previus-song.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                          songNotifier.isPlaying ? CupertinoIcons.pause_circle_fill : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 80,
                        color: Pallete.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/next-song.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/repeat.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/connect-device.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/playlist.png",
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
