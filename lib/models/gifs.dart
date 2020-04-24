class Gif {
  String name;
  String id;
  String url;

  Gif(String name, String id){
    this.name = name;
    this.id = id; 
    this.url = 'https://i.giphy.com/media/' + id + '/200_d.gif';
  }
}

List<Gif> gifs = [
  Gif('nails','mlvseq9yvZhba',),
  Gif('fight','q1MeAPDDMb43K',),
  Gif('surprised','5i7umUqAOYYEw',),
  Gif('keyboard','VbnUQpnihPSIgIXuZv',),
  Gif('kiss','MDJ9IbxxvDUQM',),
  Gif('ready','CjmvTCZf2U3p09Cn0h',),
];
