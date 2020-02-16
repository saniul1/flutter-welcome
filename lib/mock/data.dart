class MockUser {
  final String name;
  final String email;
  final String phoneNumber;
  final String bio;
  final String imageURL;

  MockUser.fromMap(Map<String, dynamic> map)
      : name = map['name'] ?? '',
        email = map['email'],
        phoneNumber = map['phoneNumber'],
        bio = map['bio'] ?? '',
        imageURL = map['imageURL'];
}

List userData = [
  {
    "name": "Marty Turrell",
    "email": "mturrell0@vistaprint.com",
    "phoneNumber": null,
    "password": "Implemented discrete help-desk",
    "bio": "Triple-buffered 24/7 infrastructure",
    "imageURL":
        "https://robohash.org/autemconsequuntursit.png?size=300x300&set=set1"
  },
  {
    "name": null,
    "email": null,
    "phoneNumber": "52-200-3317",
    "password": "Compatible bandwidth-monitored policy",
    "bio": "Reactive human-resource challenge",
    "imageURL":
        "https://robohash.org/accusantiuminaut.png?size=300x300&set=set1"
  },
  {
    "name": "Kyle Jesse",
    "email": null,
    "phoneNumber": null,
    "password": "Decentralized disintermediate policy",
    "bio": "Reactive encompassing model",
    "imageURL": "https://robohash.org/harumdelenitiab.png?size=300x300&set=set1"
  },
  {
    "name": null,
    "email": "jcupitt3@toplist.cz",
    "phoneNumber": "26-942-8832",
    "password": "Secured zero tolerance circuit",
    "bio": "Open-source mobile local area network",
    "imageURL":
        "https://robohash.org/corruptivoluptatemneque.png?size=300x300&set=set1"
  },
  {
    "name": "Dido Coldridge",
    "email": "dcoldridge4@ca.gov",
    "phoneNumber": null,
    "password": "Focused zero defect artificial intelligence",
    "bio": "Switchable zero defect contingency",
    "imageURL":
        "https://robohash.org/voluptasminusperspiciatis.png?size=300x300&set=set1"
  },
  {
    "name": "Alissa Slessor",
    "email": null,
    "phoneNumber": null,
    "password": "Public-key bifurcated archive",
    "bio": "Synergized zero tolerance firmware",
    "imageURL":
        "https://robohash.org/molestiaetotamerror.png?size=300x300&set=set1"
  },
  {
    "name": "Arnaldo Fullbrook",
    "email": null,
    "phoneNumber": null,
    "password": "Front-line high-level archive",
    "bio": "Fundamental motivating data-warehouse",
    "imageURL":
        "https://robohash.org/natusquivoluptates.png?size=300x300&set=set1"
  },
  {
    "name": null,
    "email": "goleshunin7@ed.gov",
    "phoneNumber": null,
    "password": "Cross-platform full-range neural-net",
    "bio": "Advanced next generation capability",
    "imageURL":
        "https://robohash.org/commodietperferendis.png?size=300x300&set=set1"
  },
  {
    "name": "Fletch Cowle",
    "email": "fcowle8@t-online.de",
    "phoneNumber": null,
    "password": "Networked mission-critical matrix",
    "bio": "Upgradable solution-oriented pricing structure",
    "imageURL":
        "https://robohash.org/explicaboexercitationemporro.png?size=300x300&set=set1"
  },
  {
    "name": null,
    "email": "amundwell9@vimeo.com",
    "phoneNumber": null,
    "password": "Multi-layered global core",
    "bio": "Reduced tertiary capacity",
    "imageURL":
        "https://robohash.org/evenietetassumenda.png?size=300x300&set=set1"
  }
];
