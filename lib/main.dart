import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const SketchSoundboardApp());
}

class SoundItem {
  final int id;
  final String title;
  final String character;
  final String file;
  final Color color;

  const SoundItem({
    required this.id,
    required this.title,
    required this.character,
    required this.file,
    required this.color,
  });
}

class SketchSoundboardApp extends StatelessWidget {
  const SketchSoundboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sketch FX',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const SoundboardScreen(),
    );
  }
}

class SoundboardScreen extends StatefulWidget {
  const SoundboardScreen({super.key});

  @override
  State<SoundboardScreen> createState() => _SoundboardScreenState();
}

class _SoundboardScreenState extends State<SoundboardScreen> {
  // Pool de reproductores activos para permitir solapamiento y corte general
  final List<AudioPlayer> _activePlayers = [];

  final List<SoundItem> _sounds = const [
    SoundItem(
      id: 1,
      title: 'Canción Inicio (All Star)',
      character: 'Escena General',
      file: 'sfx_1_inicio.mp3',
      color: Color(0xFF2E7D32),
    ),
    SoundItem(
      id: 2,
      title: 'Pedorreta Larga',
      character: 'Shrek (Baño)',
      file: 'sfx_2_pedo.mp3',
      color: Color(0xFF558B2F),
    ),
    SoundItem(
      id: 3,
      title: 'Carrera Apurada',
      character: 'Burro',
      file: 'sfx_3_carrera.mp3',
      color: Color(0xFF6D4C41),
    ),
    SoundItem(
      id: 4,
      title: 'Entrada Dramática',
      character: 'Gato con Botas',
      file: 'sfx_4_entrada.mp3',
      color: Color(0xFFE65100),
    ),
    SoundItem(
      id: 5,
      title: 'Ruidos Estómago',
      character: 'Shrek (Baño)',
      file: 'sfx_5_estomago.mp3',
      color: Color(0xFF455A64),
    ),
    SoundItem(
      id: 6,
      title: 'Desenvaine Espada',
      character: 'Gato con Botas',
      file: 'sfx_6_espada.mp3',
      color: Color(0xFFF57C00),
    ),
    SoundItem(
      id: 7,
      title: 'Confeti + Magia',
      character: 'Hada Madrina',
      file: 'sfx_7_confeti.mp3',
      color: Color(0xFFAD1457),
    ),
    SoundItem(
      id: 8,
      title: 'Toque de Varita',
      character: 'Hada Madrina',
      file: 'sfx_8_varita.mp3',
      color: Color(0xFFC2185B),
    ),
    SoundItem(
      id: 9,
      title: 'Rugido + Fuego',
      character: 'Dragona',
      file: 'sfx_9_dragona.mp3',
      color: Color(0xFFC62828),
    ),
    SoundItem(
      id: 10,
      title: 'Videollamada',
      character: 'Farquaad',
      file: 'sfx_10_llamada.mp3',
      color: Color(0xFF1565C0),
    ),
    SoundItem(
      id: 11,
      title: 'Caballo Épico',
      character: 'Farquaad',
      file: 'sfx_11_caballo.mp3',
      color: Color(0xFF0D47A1),
    ),
    SoundItem(
      id: 12,
      title: 'Cadena Inodoro',
      character: 'Shrek (Baño)',
      file: 'sfx_12_inodoro.mp3',
      color: Color(0xFF00695C),
    ),
    SoundItem(
      id: 13,
      title: 'Fanfarria Héroe',
      character: 'Shrek (Baño)',
      file: 'sfx_13_heroe.mp3',
      color: Color(0xFFFBC02D),
    ),
    SoundItem(
      id: 14,
      title: 'Spray Ambientador',
      character: 'Fiona',
      file: 'sfx_14_spray.mp3',
      color: Color(0xFF00838F),
    ),
    SoundItem(
      id: 15,
      title: 'Baile (I\'m a Believer)',
      character: 'Final Sketch',
      file: 'sfx_15_final.mp3',
      color: Color(0xFF4A148C),
    ),
  ];

  Future<void> _playSound(String assetName) async {
    final player = AudioPlayer();
    _activePlayers.add(player);

    player.onPlayerComplete.listen((_) {
      player.dispose();
      _activePlayers.remove(player);
    });

    await player.play(AssetSource('audio/$assetName'));
  }

  Future<void> _stopAllSounds() async {
    for (final player in _activePlayers) {
      await player.stop();
      await player.dispose();
    }
    _activePlayers.clear();
  }

  @override
  void dispose() {
    _stopAllSounds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soundboard Sketch'),
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _stopAllSounds,
              icon: const Icon(Icons.stop),
              label: const Text('PARAR TODO'),
            ),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 110,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _sounds.length,
        itemBuilder: (context, index) {
          final item = _sounds[index];
          return Material(
            color: item.color,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _playSound(item.file),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black26,
                          child: Text(
                            '${item.id}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                        const Icon(Icons.play_arrow,
                            color: Colors.white70, size: 20),
                      ],
                    ),
                    Text(
                      item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.character,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
