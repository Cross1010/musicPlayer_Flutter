import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new AudioPlayerModel()),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Background(),
              Column(
                children: [
                  CustomAppBar(),
                  _ImageDiskRotation(),
                  //Button and Title
                  TitleButton(),

                  SizedBox(height: 10),
                  Expanded(child: ListItems()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [
              Color(0xff33333E),
              Color(0xff201E28),
            ],
          )),
    );
  }
}

class ListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lyrics = getLyrics();

    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: size.height * 0.06,
        diameterRatio: 2,
        children: lyrics
            .map((e) => Text(
                  e,
                  style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: Colors.white.withOpacity(0.6)),
                ))
            .toList(),
      ),
    );
  }
}

class _ImageDiskRotation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      margin: EdgeInsets.only(top: size.height * 0.1),
      child: Row(
        children: [
          //Disk Image
          _ImageDisk(),
          Spacer(),
          //Progress Bar
          _ProgressBar(),
        ],
      ),
    );
  }
}

class TitleButton extends StatefulWidget {
  @override
  _TitleButtonState createState() => _TitleButtonState();
}

class _TitleButtonState extends State<TitleButton>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;

  AnimationController? playAnimation;

  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    playAnimation!.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer.open(Audio('Breaking-Benjamin-Far-Away.mp3'));

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    // assetAudioPlayer.current.listen((playingAudio) {
    //   if (playingAudio != null) {
    //     audioPlayerModel.songDuration = playingAudio.audio.duration;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      margin: EdgeInsets.only(top: size.width * 0.04),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far Away',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '-Breaking Benjamin-',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: Colors.white.withOpacity(0.4),
                ),
              )
            ],
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation!,
            ),
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerModel =
                  Provider.of<AudioPlayerModel>(context, listen: false);

              print(this.isPlaying);

              if (this.isPlaying) {
                this.isPlaying = false;
                playAnimation!.reverse();
                audioPlayerModel.controller!.stop();
              } else {
                playAnimation!.forward();
                this.isPlaying = true;
                audioPlayerModel.controller!.repeat();
              }

              if (firstTime) {
                this.open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
          )
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final textStyle = TextStyle(
        color: Colors.white.withOpacity(0.4), fontSize: size.width * 0.07);

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcent = audioPlayerModel.porcent;

    return Container(
      child: Column(
        children: [
          Text('${audioPlayerModel.songTotalDuration}', style: textStyle),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 200 * porcent,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('${audioPlayerModel.currentSecond}', style: textStyle),
        ],
      ),
    );
  }
}

class _ImageDisk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      height: 250,
      width: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              animate: false,
              controller: (animation) =>
                  audioPlayerModel.controller = animation,
              duration: Duration(seconds: 10),
              infinite: true,
              child: Image(image: AssetImage('assets/aurora.jpg')),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
    );
  }
}
