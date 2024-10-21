import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<_LocationAndNotificationState> _locationAndNotificationKey =
        GlobalKey<_LocationAndNotificationState>();

    void _handleCardTap(String message) {
      _locationAndNotificationKey.currentState
          ?._showNotificationDialog(message);
    }

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section
              TopSection(key: _locationAndNotificationKey),
              // Middle Section
              MiddleSection(),
              // Bottom Section
              BottomSection(),
              // Card Section
              CardSection1(onCardTap: _handleCardTap), // Pass the callback here
            ],
          ),
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationAndNotification(
            key: key), // Pass key to LocationAndNotification
        SearchBar(),
        BannerWidget(),
      ],
    );
  }
}

class LocationAndNotification extends StatefulWidget {
  const LocationAndNotification({Key? key}) : super(key: key);

  @override
  _LocationAndNotificationState createState() =>
      _LocationAndNotificationState();
}

class _LocationAndNotificationState extends State<LocationAndNotification> {
  String _selectedLocation = 'Seattle, USA'; // Locația inițială
  final List<String> _locations = [
    'Seattle, USA',
    'New York, USA',
    'Los Angeles, USA',
    'Chicago, USA',
    'Miami, USA',
  ];

  String? _notificationMessage; // Mesajul notificării

  void _showNotificationDialog(String message) {
    setState(() {
      _notificationMessage = message;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notificare'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
              child: Text('Închide'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 5),
              DropdownButton<String>(
                value: _selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: _locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ],
          ),
          // Notification with red dot
          Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(
                onTap: () {
                  if (_notificationMessage != null) {
                    _showNotificationDialog(_notificationMessage!);
                  }
                },
                child: Icon(Icons.notifications, color: Colors.blue),
              ),
              if (_notificationMessage != null)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search doctor...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Stack(
        children: [
          Container(
            height: 200, // Setează înălțimea imaginii
            child: CarouselWithDots(), // Carousel-ul cu imagini
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Looking for Specialist Doctors?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Text alb pe fundal
                  ),
                ),
                Text(
                  'Schedule an appointment with our top doctors.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselWithDots extends StatefulWidget {
  @override
  _CarouselWithDotsState createState() => _CarouselWithDotsState();
}

class _CarouselWithDotsState extends State<CarouselWithDots> {
  final List<String> imgList = [
    'assets/iphoto.jpg',
    'assets/iphoto2.jpg',
    'assets/iphoto3.jpg',
  ];

  int _currentIndex = 0;

  void _nextSlide() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % imgList.length;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 5));
      _nextSlide();
      return true; // Continuă să se execute
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            height: 200,
            child: IndexedStack(
              index: _currentIndex,
              children: imgList.map((item) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(item),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = entry.key;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentIndex == entry.key ? 12.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Adaugă secțiunea Middle aici
class MiddleSection extends StatefulWidget {
  @override
  _MiddleSectionState createState() => _MiddleSectionState();
}

class _MiddleSectionState extends State<MiddleSection> {
  bool _showMore = false; // Stare pentru a afișa sau ascunde rândul suplimentar

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(
            onSeeAllPressed: _toggleShowMore), // Trece funcția la buton
        CategoriesSection(
            showMore: _showMore), // Trimite starea către CategoriesSection
      ],
    );
  }

  // Funcția pentru a schimba starea de afișare a mai multor taburi
  void _toggleShowMore() {
    setState(() {
      _showMore = !_showMore;
    });
  }
}

class TitleSection extends StatefulWidget {
  final VoidCallback onSeeAllPressed;

  TitleSection({required this.onSeeAllPressed});

  @override
  _TitleSectionState createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  bool _isHovering = false; // Stare pentru hover

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // MouseRegion detectează hover-ul pentru textul 'See All'
          MouseRegion(
            onEnter: (_) => _onHover(true), // Detectează când intră cursorul
            onExit: (_) => _onHover(false), // Detectează când iese cursorul
            child: GestureDetector(
              onTap: widget.onSeeAllPressed,
              child: Text(
                'See All',
                style: TextStyle(
                  color: _isHovering
                      ? Colors.blueAccent
                      : Colors.blue, // Schimbă culoarea la hover
                  fontWeight: _isHovering
                      ? FontWeight.bold
                      : FontWeight.normal, // Schimbă stilul la hover
                  decoration: _isHovering
                      ? TextDecoration.underline
                      : null, // Sublinează la hover
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Funcție pentru a actualiza starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }
}

class CategoriesSection extends StatelessWidget {
  final bool showMore; // Primiți starea pentru a controla afișarea rândurilor

  CategoriesSection({required this.showMore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Tab01(),
            Tab02(),
            Tab03(),
            Tab04(),
          ],
        ),
        SizedBox(height: 16),
        // Afișați mai multe taburi doar dacă showMore este true
        if (showMore)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Tab05(),
              Tab06(),
              Tab07(),
              Tab08(),
            ],
          ),
      ],
    );
  }
}

class TabBarSection extends StatelessWidget {
  final List<String> tabs;

  TabBarSection({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs.map((tab) => TabItem(tab: tab)).toList(),
        ),
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  final String tab;

  TabItem({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          color: Colors.grey[300], // Placeholder for the image
          child: Center(child: Text(tab)),
        ),
        SizedBox(height: 5),
        Text(tab, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class Tab01 extends StatefulWidget {
  @override
  _Tab01State createState() => _Tab01State();
}

class _Tab01State extends State<Tab01> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/tooth.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Dentistry', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Stomatologie'),
          content: Text(
              'Stomatologia este ramura medicală care se ocupă cu studiul, diagnosticul, prevenirea și tratamentul afecțiunilor cavității bucale și structurilor înconjurătoare.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab02 extends StatefulWidget {
  @override
  _Tab02State createState() => _Tab02State();
}

class _Tab02State extends State<Tab02> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/cardiolog.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Cardiology', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Cardiologie'),
          content: Text(
              'Cardiologia este o specialitate medicală care are ca subiect de studiu bolile inimii și ale vaselor de sânge. Etimologie: gr. kardia: „inimă”, logos: „știință”. Cardiologia cuprinde diagnosticul și tratamentul bolilor cardiace congenitale, bolii cardiace ischemice, insuficienței cardiace, valvulopatiilor, aritmiilor și al bolilor pericardului.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab03 extends StatefulWidget {
  @override
  _Tab03State createState() => _Tab03State();
}

class _Tab03State extends State<Tab03> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/pulmonolog.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Pulmonolo', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Pulmonoologie'),
          content: Text(
              'Pulmonologia este o ramură a medicinei dedicată diagnosticului și tratamentului bolilor plămânilor și ale căilor respiratorii.  Pulmonolog este o specialitate terapeutică.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab04 extends StatefulWidget {
  @override
  _Tab04State createState() => _Tab04State();
}

class _Tab04State extends State<Tab04> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/general.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('General', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Medic General'),
          content: Text(
              'Medicul de medicină generală diagnostichează, tratează și previne bolile, infecțiile, leziunile și alte deficiențe fizice și mentale la om, prin aplicarea principiilor și procedurilor medicinii moderne. Acesta nu își limitează activitatea la anumite categorii de boli sau metode de tratament și pot să își asume responsabilitatea pentru furnizarea corespunzătoare și continuă a îngrijirii medicale persoanelor, familiilor și comunităților.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab05 extends StatefulWidget {
  @override
  _Tab05State createState() => _Tab05State();
}

class _Tab05State extends State<Tab05> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/neurolog.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Neurology', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Neurologie'),
          content: Text(
              'Neurologia este o ramură specială a medicinii care se ocupă cu diagnosticul și tratamentul bolilor organice care afectează sistemul nervos central sau periferic.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab06 extends StatefulWidget {
  @override
  _Tab06State createState() => _Tab06State();
}

class _Tab06State extends State<Tab06> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/gastroenterolog.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Gatroente', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Gastroenterologie'),
          content: Text(
              'Gastroenterologia este specialitatea medicală care se ocupă cu prevenirea, depistarea, diagnosticarea și tratarea bolilor tubului digestiv și ale organelor anexe (esofagului, stomacului, duodenului, intestinului subțire, colonului, ficatului, vezicii biliare, pancreasului)'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab07 extends StatefulWidget {
  @override
  _Tab07State createState() => _Tab07State();
}

class _Tab07State extends State<Tab07> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/labaratory.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Laboratory', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Laborator'),
          content: Text(
              'Medicina de laborator este o specialitate medicală din grupul specialităților paraclinice, care are ca obiect de activitate efectuarea investigațiilor de laborator pe eșantioane de produse biologice prelevate de la pacienți, sau din mediul care poate afecta pacienții, în scopul de a contribui la stabilirea diagnosticului, sau la evidențierea dinamicii modificărilor fiziologice și fiziopatologice din organism.'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class Tab08 extends StatefulWidget {
  @override
  _Tab08State createState() => _Tab08State();
}

class _Tab08State extends State<Tab08> {
  bool _isHovering = false; // Pentru a verifica dacă cursorul este deasupra

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează când cursorul intră în box
      onExit: (_) => _onHover(false), // Detectează când cursorul iese din box
      child: InkWell(
        onTap: () => _showInfoDialog(), // Afișează dialogul de informații
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? Colors.blue[50]
                : Colors.white, // Schimbă culoarea la hover
            borderRadius: BorderRadius.circular(8), // Colțuri rotunjite
            border: Border.all(
              color:
                  _isHovering ? Colors.blue : Colors.grey, // Bordura la hover
              width: 2,
            ),
          ),
          width: 80, // Setează lățimea fixă pentru toate box-urile
          height: 80, // Setează înălțimea fixă pentru toate box-urile
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 30, // Lățimea dorită pentru imagine
                height: 30, // Înălțimea dorită pentru imagine
                child: Image.asset(
                  'assets/vaccine.jpg', // Calea către imagine
                  fit: BoxFit.cover, // Ajustează imaginea pentru a se potrivi
                ),
              ),
              SizedBox(height: 8), // Spațiu între imagine și text
              Text('Vaccinatio', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  // Schimbă starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Afișează un dialog cu informații
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informații despre Vaccinare'),
          content: Text(
              'Vaccinarea este o metodă de imunizare activă, profilactică, împotriva unor boli, prin inocularea unui vaccin.'
              'Protecția imunologică se instalează după un interval de timp variabil de la inoculare (săptămâni, luni), în funcție de vaccin, și este de lungă durată (ani).'),
          actions: [
            TextButton(
              child: Text('Închide'),
              onPressed: () {
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}

class BottomSection extends StatefulWidget {
  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool showMoreCards = false; // Starea pentru afișarea cardurilor suplimentare

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection1(onSeeAllPressed: () {
          setState(() {
            showMoreCards =
                true; // Setează starea pentru a afișa carduri suplimentare
          });
        }),
        CardsSection(showMoreCards: showMoreCards),
      ],
    );
  }
}

class TitleSection1 extends StatefulWidget {
  final VoidCallback onSeeAllPressed;

  TitleSection1({required this.onSeeAllPressed});

  @override
  _TitleSectionState1 createState() => _TitleSectionState1();
}

class _TitleSectionState1 extends State<TitleSection1> {
  bool _isHovering = false; // Stare pentru hover

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Nearby Medical Centers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          // MouseRegion detectează hover-ul pentru textul 'See All'
          MouseRegion(
            onEnter: (_) => _onHover(true), // Detectează când intră cursorul
            onExit: (_) => _onHover(false), // Detectează când iese cursorul
            child: GestureDetector(
              onTap: widget.onSeeAllPressed,
              child: Text(
                'See All',
                style: TextStyle(
                  color: _isHovering
                      ? Colors.blueAccent
                      : Colors.blue, // Schimbă culoarea la hover
                  fontWeight: _isHovering
                      ? FontWeight.bold
                      : FontWeight.normal, // Schimbă stilul la hover
                  decoration: _isHovering
                      ? TextDecoration.underline
                      : null, // Sublinează la hover
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Funcție pentru a actualiza starea de hovering
  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }
}

class CardsSection extends StatelessWidget {
  final bool showMoreCards;

  CardsSection({required this.showMoreCards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HospitalPage(hospitalName: 'Sunrise Health Clinic'),
              ),
            );
          },
          child: Card01(),
        ),
        SizedBox(height: 16), // Spacing între carduri
        if (showMoreCards) ...[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HospitalPage(hospitalName: 'Golden Cardiology Center'),
                ),
              );
            },
            child: Card02(),
          ),
        ],
      ],
    );
  }
}

class Card01 extends StatefulWidget {
  @override
  _Card01State createState() => _Card01State();
}

class _Card01State extends State<Card01> {
  bool isLiked = false; // Stare pentru butonul de like
  bool _isHovered = false; // Stare pentru hover

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează intrarea cursorului
      onExit: (_) => _onHover(false), // Detectează ieșirea cursorului
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Timpul pentru animație
        curve: Curves.easeInOut, // Curba animației
        decoration: BoxDecoration(
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3), // Schimbă umbra la hover
                  ),
                ]
              : [], // Fără umbră la stare normală
        ),
        child: Card(
          child: Column(
            children: [
              Stack(
                children: [
                  // Folosește un Container cu padding
                  Container(
                    padding:
                        EdgeInsets.only(top: 8), // Ajustează marginea de sus
                    child: SizedBox(
                      width: 500, // Lățimea imaginii
                      height: 180, // Înălțimea imaginii
                      child: Image.asset('assets/sunrise-hospital.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Content(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funcție pentru a actualiza starea de hover
  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Info(),
        Divider(), // Separator (linie)
        Location(),
      ],
    );
  }
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sunrise Health Clinic',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 4),
            Text('123 Oak Street, CA 98765'),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text('5.0', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Colors.yellow, size: 16);
              }),
            ),
            SizedBox(width: 8),
            Text('58 Reviews'),
          ],
        ),
      ],
    );
  }
}

class Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Icon(Icons.directions_walk),
            SizedBox(height: 4),
            Text('2.5km/40min'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.local_hospital),
            SizedBox(height: 4),
            Text('Hospital'),
          ],
        ),
      ],
    );
  }
}

class Card02 extends StatefulWidget {
  @override
  _Card02State createState() => _Card02State();
}

class _Card02State extends State<Card02> {
  bool isLiked = false; // Stare pentru butonul de like
  bool _isHovered = false; // Stare pentru hover

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true), // Detectează intrarea cursorului
      onExit: (_) => _onHover(false), // Detectează ieșirea cursorului
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Timpul pentru animație
        curve: Curves.easeInOut, // Curba animației
        decoration: BoxDecoration(
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3), // Schimbă umbra la hover
                  ),
                ]
              : [], // Fără umbră la stare normală
        ),
        child: Card(
          child: Column(
            children: [
              Stack(
                children: [
                  // Folosește un Container cu padding
                  Container(
                    padding:
                        EdgeInsets.only(top: 8), // Ajustează marginea de sus
                    child: SizedBox(
                      width: 500, // Lățimea imaginii
                      height: 180, // Înălțimea imaginii
                      child: Image.asset('assets/cardiology-center.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Content2(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funcție pentru a actualiza starea de hover
  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

class Content2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Info2(),
        Divider(), // Separator (linie)
        Location2(),
      ],
    );
  }
}

class Info2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Golden Cardiology Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: 4),
            Text('555 Bridge Street, Golden Gate'),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text('4.9', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Colors.yellow, size: 16);
              }),
            ),
            SizedBox(width: 8),
            Text('108 Reviews'),
          ],
        ),
      ],
    );
  }
}

class Location2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Icon(Icons.directions_walk),
            SizedBox(height: 4),
            Text('1.5km/40min'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.local_hospital),
            SizedBox(height: 4),
            Text('Hospital'),
          ],
        ),
      ],
    );
  }
}

class HospitalPage extends StatelessWidget {
  final String hospitalName;

  HospitalPage({required this.hospitalName});

  @override
  Widget build(BuildContext context) {
    // Informații pentru fiecare spital
    final Map<String, String> hospitalDetails = {
      'Sunrise Health Clinic':
          'Sunrise Health Clinic is known for its excellent emergency services and dedicated staff.',
      'Golden Cardiology Center':
          'Golden Cardiology Center specializes in heart-related treatments and has state-of-the-art technology.',
    };

    // Află informația pentru spitalul selectat
    String details = hospitalDetails[hospitalName] ?? 'No details available.';

    return Scaffold(
      appBar: AppBar(title: Text(hospitalName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospitalName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              details,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Înapoi la pagina anterioară
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class CardSection1 extends StatefulWidget {
  final Function(String) onCardTap;

  CardSection1({required this.onCardTap});

  @override
  _CardSection1State createState() => _CardSection1State();
}

class _CardSection1State extends State<CardSection1> {
  String selectedFilter = 'All';
  List<Map<String, dynamic>> allDoctors = [
    {
      'name': 'Dr. David Patel',
      'field': 'Cardiologist',
      'location': 'Golden Cardiology Center',
      'reviews': '405',
      'rating': '5',
      'image': 'assets/doctor1.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Jessica Turner',
      'field': 'Gynecologist',
      'location': 'Womens Clinic, Seatle, USA',
      'reviews': '127',
      'rating': '4.9',
      'image': 'assets/doctor2.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Michael Johnson',
      'field': 'Orthopedic Surgery',
      'location': 'Mapple Associates, NY, USA',
      'reviews': '5,223',
      'rating': '4.7',
      'image': 'assets/doctor3.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Emily Walker',
      'field': 'Pediatrics',
      'location': 'Serenity Pediatrics Clinic',
      'reviews': '405',
      'rating': '5',
      'image': 'assets/doctor5.jpg',
      'isFavorite': false,
    },
    {
      'name': 'Dr. Peter Parker',
      'field': 'Pediatrics',
      'location': 'Serenity Pediatrics Clinic',
      'reviews': '375',
      'rating': '4.8',
      'image': 'assets/doctor4.jpg',
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> filteredDoctors = [];
  Map<String, bool> hoverStates = {};

  @override
  void initState() {
    super.initState();
    filteredDoctors = allDoctors;

    // Inițializăm starea hover pentru fiecare doctor
    for (var doctor in allDoctors) {
      hoverStates[doctor['name']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${filteredDoctors.length} founds',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        selectedFilter,
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_upward),
                      Icon(Icons.arrow_downward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: filteredDoctors.map((doctor) {
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoverStates[doctor['name']] = true;
                });
              },
              onExit: (_) {
                setState(() {
                  hoverStates[doctor['name']] = false;
                });
              },
              child: InkWell(
                onTap: () {
                  // Trimiterea notificării către LocationAndNotification
                  String message =
                      'V-ați înscris la medicul ${doctor['name']} la data de 30 septembrie la ora 15:00';
                  widget.onCardTap(message);
                },
                child: Card(
                  elevation: hoverStates[doctor['name']] ?? false
                      ? 8
                      : 4, // Setează valoarea implicită la `false` dacă e null
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: hoverStates[doctor['name']] ?? false
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(doctor['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    doctor['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: doctor['isFavorite']
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        doctor['isFavorite'] =
                                            !doctor['isFavorite'];
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Text(doctor['field']),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  Text(doctor['location']),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Text(doctor['rating']),
                                  SizedBox(width: 8),
                                  Text('${doctor['reviews']} Reviews'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter by Doctor Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'All';
                    filteredDoctors = allDoctors;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Cardiologist'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Cardiologist';
                    filteredDoctors = allDoctors
                        .where((doctor) => doctor['field'] == 'Cardiologist')
                        .toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Gynecologist'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Gynecologist';
                    filteredDoctors = allDoctors
                        .where((doctor) => doctor['field'] == 'Gynecologist')
                        .toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Pediatrics'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Pediatrics';
                    filteredDoctors = allDoctors
                        .where((doctor) => doctor['field'] == 'Pediatrics')
                        .toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Dentist'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Dentist';
                    filteredDoctors = allDoctors
                        .where((doctor) => doctor['field'] == 'Dentists')
                        .toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Orthopedic Surgery'),
                onTap: () {
                  setState(() {
                    selectedFilter = 'Orthopedic Surgery';
                    filteredDoctors = allDoctors
                        .where(
                            (doctor) => doctor['field'] == 'Orthopedic Surgery')
                        .toList();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}