import 'package:flutter/material.dart';
import 'package:music/data/api/music_api_retrieve_json.dart';
import 'package:music/data/db/data_request.dart';
import 'package:music/domain/music.dart';
import 'package:music/domain/playlist.dart';
import 'package:music/pages/music_playlist.dart';
import 'package:music/widget/genre_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMusic extends StatefulWidget {
  const HomeMusic({Key? key}) : super(key: key);
  @override
  _HomeMusic createState() => _HomeMusic();
}

class _HomeMusic extends State <HomeMusic> {
  @override
  Future<List<Music>> musicList = DataRequest().buildDatabase();
  Future<List> musicGenreList = DataRequest().retrieveGenreDatas();
  Future<List<Playlist>> musicJSONS = PlaylistAPI().listDatas();

  Future<void> launchUrlMusic({required String urlString}) async{
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color(0xFF9F9F9F),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    AspectRatio(
                      aspectRatio: 7/3,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('https://miro.medium.com/max/1400/0*FjF2hZ8cJQN9aBxk.jpg'),
                        child: Text(""),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            returnListTile(genreName: "Lofi", size: 24),
            returnListTile(genreName: "Hip Hop", size: 24),
            returnListTile(genreName: "Pop", size: 24),
            returnListTile(genreName: "Electronic", size: 24),
            returnListTile(genreName: "My Playlist", size: 24),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF9F9F9F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F4F4F),
        title: returnText(text: "Study Musics", size: 24, color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          FutureBuilder <List>(
            future: musicGenreList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List presentMusicGenreList = snapshot.data ?? [];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 64,
                    child: Row(
                      children: [
                        ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 16);
                          },
                          itemBuilder: (context, index) {
                            List lista = presentMusicGenreList[index];
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                children: [
                                  returnElevatedButton(list: lista, genreName: lista[0].genreName, size: 18, color: Color(0xFF000000))
                                ],
                              ),
                            );
                            },
                          itemCount: presentMusicGenreList.length,
                        ),
                        FutureBuilder<List>(
                          future: musicJSONS,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List playlistJSON = snapshot.data ?? [];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () => onPressedJSON(musicsJSON: playlistJSON),
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                      primary: Color(0xFF777777),
                                    ),
                                    child: Text(
                                      "Playlist",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0,3.0,18.0,18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      border: Border.all(color: Color(0xFF000000)),
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    width: MediaQuery.of(context).size.width - 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        returnIcon(icon: Icons.book, size: 50),
                        returnIcon(icon: Icons.play_arrow, size: 50),
                        returnIcon(icon: Icons.pause_circle, size: 50),
                      ],
                    ),
                  ),
                ),
                FutureBuilder <List<Music>>(
                    future: musicList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Music> musics = snapshot.data ?? [];
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: musics.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 36);
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF000000)),
                                color: Color(0xFFEEEEEE),
                              ),
                              height: 460,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 260,
                                    child: AspectRatio(
                                      aspectRatio: 4/3,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(musics[index].imageLink),
                                        child: const Text(""),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      child: Container(
                                        height: 95,
                                        width: MediaQuery.of(context).size.width - 16,
                                        color: Color(0xFF777777),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            returnIcon(icon: Icons.music_note, size: 50),
                                            returnText(text: musics[index].name, size: 36, color: Colors.white),
                                          ],
                                        ),
                                      ),
                                      onTap: () => launchUrlMusic(urlString: musics[index].link),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                ),
              ],
            ),
          ),

          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF000000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                returnText(text: "Enjoy Your Study Music!", size: 23, color: Colors.white),
                returnText(text: "Copyright Ⓒ2022, All Rights Reserved.", size: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  returnText({required String text, required double size, required Color color}){
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size,
        color: color,
      ),
    );
  }

  returnIcon({required IconData icon, required double size}){
    return Icon(
      icon,
      size: size,
    );
  }

  returnListTile({required String genreName, required double size}){
    return ListTile(
      title: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFFEEEEEE),
        ),
        child: returnText(text: genreName, size: size, color: Color(0xFF000000)),
        onPressed: onPressed1,
      ),
    );
  }

  returnElevatedButton({required List list, required String genreName, required double size, required Color color}){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFFEEEEEE),
      ),
      child: returnText(text: genreName, size: size, color: Color(0xFF000000)),
      onPressed: () => onPressed(genreList: list),
    );
  }

  onPressed({
    required List genreList,
  }){
    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) {
            return GenrePage(musicGenreList: genreList);
          }
      ),
    );
  }

  onPressed1(){}

  onPressedJSON({required List musicsJSON}){
    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) {
            return JsonMusic(musicJSONsObjects: musicsJSON);
          }
      ),
    );
  }
}