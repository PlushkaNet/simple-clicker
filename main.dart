import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => GameProcessProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => PageProvider())
      ],
      child: const MainWindow(),
    )
  );
}

class MainWindow extends StatefulWidget{
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindow();
}

class _MainWindow extends State<MainWindow>{
  @override
  Widget build(BuildContext context) {
    final PageProvider page = Provider.of(context, listen: true);
    final ThemeProvider theme = Provider.of(context, listen: true);
    List<Widget> pages = <Widget>[
      const CounterWidget(),
      const Shop(),
      const Settings()
    ];
    return MaterialApp(
      home: Scaffold(
        backgroundColor: theme.color,
        body: pages[page.index],
        bottomNavigationBar: const BottomNavigation()
      ),
    );
  }
}

class PageProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setPage(int index) {
    _index = index;

    notifyListeners();
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidget();
}

class _CounterWidget extends State<CounterWidget>{
  @override
  Widget build(BuildContext context) {
    final GameProcessProvider gameProcess = Provider.of<GameProcessProvider>(context);
    final ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Align(
      child: GestureDetector(
        onTap: () => setState(() {
          gameProcess.incrementClicks();
        }),
        child: Container(
          decoration: BoxDecoration(
            color: theme.isDarkTheme ? const Color.fromARGB(255, 82, 81, 81) : Colors.black,
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
            ),
            border: Border.all(
              style: BorderStyle.solid
            ),
          ),

          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,

          child: Align(
            alignment: Alignment.center,
            child: Text(
              gameProcess.clicks.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
              )
            )
          )
        ),
      )
    );
  }
}

class Shop extends StatelessWidget{
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> upgrades = [
      const SizedBox(height: 60),
      const ImproveClickStrength()
    ];

    return ListView.builder(
      itemCount: upgrades.length,
      itemBuilder: (context, index){
        return upgrades[index];
      }
    );
  }
}

class Loading extends StatelessWidget{
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "loading..."
      )
    );
  }
}

class ShopItem extends StatelessWidget{
  const ShopItem({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = Provider.of(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: theme.isDarkTheme ? const Color.fromARGB(255, 63, 63, 63) : Colors.black
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          
          child: content,
        )
      ],
    );
  }
}

double screenSpecificFont(BuildContext context){
  return 
    (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) ?
    MediaQuery.of(context).size.width * 0.05 : MediaQuery.of(context).size.height * 0.05;
}

class ImproveClickStrength extends StatefulWidget {
  const ImproveClickStrength({super.key});

  @override
  State<ImproveClickStrength> createState() => _ImproveClickStrength();
}

class _ImproveClickStrength extends State<ImproveClickStrength>{
  @override
  Widget build(BuildContext context) {
    final LanguageProvider language = Provider.of(context, listen: true);
    final GameProcessProvider gameProcess = Provider.of(context, listen: true);
    return GestureDetector(

      onTap: () => setState(() {
        if(gameProcess.clicks > gameProcess.needForUpgradeStrength) {
          gameProcess.substractClicks();
          gameProcess.incrementStrengthLevel();
        }
      }),

      child: ShopItem(
        content: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04
                ),
                child: Text(
                  "💪",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSpecificFont(context) * 2
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.mainLanguage.words[3] + gameProcess.strengthLevel.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSpecificFont(context) * 0.8,
                    ),
                  ),
                  Text(
                    language.mainLanguage.words[4] + gameProcess.needForUpgradeStrength.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSpecificFont(context) * 0.8
                    ),
                  ),
                  Text(
                    language.mainLanguage.words[5] + gameProcess.strength.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSpecificFont(context) * 0.8
                    ),
                  )
                ],
              )
            ],
          ),
        )
      );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation>{
  @override
  Widget build(BuildContext context) {
    final PageProvider page = Provider.of(context, listen: true);
    final ThemeProvider theme = Provider.of(context, listen: true);
    final LanguageProvider language = Provider.of(context, listen: true);
    return BottomNavigationBar(
      backgroundColor: theme.isDarkTheme ? const Color.fromARGB(255, 14, 14, 14) : const Color.fromARGB(255, 207, 207, 207),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.gamepad),
          label: language.mainLanguage.words[0]
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.store),
          label: language.mainLanguage.words[1]
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: language.mainLanguage.words[2]
        )
      ],
      onTap: (value){page.setPage(value);},
      currentIndex: page.index,
      unselectedItemColor: theme.isDarkTheme ? const Color.fromARGB(117, 219, 219, 219) : Colors.black45,
      selectedItemColor: theme.isDarkTheme ? Colors.white : Colors.black,
    );
  }
}

class Settings extends StatelessWidget{
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        const SettingsThemeChanger(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        const SettingsLanguageChooser(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        const ResetAll(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        const ResetProgress()
      ],
    );
  }
}

class SettingsElement extends StatelessWidget{
  const SettingsElement({super.key,
  required this.content,
  this.onTap,
  this.backgroundColor});

  final Widget content;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = Provider.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: (backgroundColor != null) ? backgroundColor :
                theme.isDarkTheme ? const Color.fromARGB(255, 63, 63, 63) : Colors.black,
              borderRadius: const BorderRadius.all(
                Radius.circular(30)
              )
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: content
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1)
      ],
    );
  }
}

class LanguageChooserPage extends StatelessWidget {
  const LanguageChooserPage({super.key});
  @override
  Widget build(BuildContext context) {
    returnBack() => Navigator.pop(context);
    final ThemeProvider theme = Provider.of(context, listen: true);
    final LanguageProvider language = Provider.of(context, listen: true);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.color,
          title: Title(
            color: theme.color, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  color: theme.isDarkTheme ? Colors.white : Colors.black,
                  iconSize: screenSpecificFont(context),
                ),
                Text(
                language.mainLanguage.words[12],
                  style: TextStyle(
                    color: theme.isDarkTheme ? Colors.white : Colors.black,
                    fontSize: screenSpecificFont(context)
                  ),
                ),
                SizedBox(width: screenSpecificFont(context) * 2)
              ],
            )
          ),
        ),
        body: ListOfLanguages(returnBack: returnBack),
        backgroundColor: theme.color,
      ),
    );
  }
}

class ListOfLanguages extends StatelessWidget {
  const ListOfLanguages({super.key, required this.returnBack});

  final VoidCallback returnBack;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = Provider.of(context, listen: true);
    final LanguageProvider language = Provider.of(context, listen: true);
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (context, index) {
        return LanguageItem(
          theme: theme,
          onTap: () => {language.chooseLanguage(index), returnBack()},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                languages[index].language,
                style: TextStyle(
                  color: theme.isDarkTheme ? Colors.white : Colors.black,
                  fontSize: screenSpecificFont(context)
                ),
              )
            ],
          )
        );
      }
    );
  }
}

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key, required this.onTap, required this.theme, required this.child});

  final VoidCallback onTap;
  final ThemeProvider theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8)
              ),
              color: theme.isDarkTheme ? const Color.fromARGB(75, 122, 122, 122) : const Color.fromARGB(158, 162, 162, 162)
            ),

            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.14,

            child: child
          ),
        )
      ],
    );
  }
}

class SettingsLanguageChooser extends StatelessWidget {
  const SettingsLanguageChooser({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider language = Provider.of(context, listen: true);
    return SettingsElement(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LanguageChooserPage())
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(
                language.mainLanguage.words[11],
                style: TextStyle(
                  fontSize: screenSpecificFont(context),
                  color: Colors.white
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                language.mainLanguage.language,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSpecificFont(context)
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: screenSpecificFont(context),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            ],
          )
        ],
      ),
    );
  }
}

class SettingsThemeChanger extends StatelessWidget{
  const SettingsThemeChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = Provider.of(context, listen: true);
    final LanguageProvider language = Provider.of(context, listen: true);
    return SettingsElement(
      onTap: theme.switchTheme,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02
              ),
              Text(
                language.mainLanguage.words[6],
                style: TextStyle(
                  fontSize: screenSpecificFont(context),
                  color: Colors.white
                ),
              ),
            ],
          ),

        Row(
          children: [
            Switch(
              value: theme._isDarkTheme,
              onChanged: (value) {
                theme.switchTheme();
              },
              activeColor: Colors.black,
              activeTrackColor: Colors.white,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02
            )
          ],
        ),
      ],
    ),
    );
  }
}

class Reseter extends StatelessWidget{
  const Reseter({super.key, required this.reseter, required this.text});

  final VoidCallback reseter;
  final String text;

  @override
  Widget build(BuildContext context) {
    final LanguageProvider language = Provider.of(context, listen: true);
    return SettingsElement(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            language.mainLanguage.words[8]
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                language.mainLanguage.words[10]
              )
            ),
            TextButton(
              onPressed: ()  {
                Navigator.pop(context);
                reseter();
              },
              child: Text(
                language.mainLanguage.words[9]
              )
            )
          ],
        )
      ),
      backgroundColor: Colors.red,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenSpecificFont(context)
            ),
          )
        ],
      ),
    );
  }
}

class ResetProgress extends StatelessWidget{
  const ResetProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final GameProcessProvider gameProcess = Provider.of<GameProcessProvider>(context, listen: true);
    final LanguageProvider language = Provider.of<LanguageProvider>(context, listen: true);
    return Reseter(
      reseter: gameProcess.resetAll,
      text: language.mainLanguage.words[13]
    );
  }
}

class ResetAll extends StatelessWidget{
  const ResetAll({super.key});

  @override
  Widget build(BuildContext context) {
    final GameProcessProvider gameProcess = Provider.of<GameProcessProvider>(context, listen: true);
    final LanguageProvider language = Provider.of<LanguageProvider>(context, listen: true);
    final ThemeProvider theme = Provider.of<ThemeProvider>(context, listen: true);
    return Reseter(
      text: language.mainLanguage.words[7],
      reseter: () => {
        gameProcess.resetAll(),
        language.reset(),
        theme.reset()
      }
    );
  }
}

class ThemeProvider extends ChangeNotifier{
  static const String _key = "theme";

  bool _isDarkTheme = false;

  ThemeProvider(){
    _loadPreferences();
  }

  Future<void> _loadPreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isDarkTheme = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> _savePreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(_key, _isDarkTheme);
    notifyListeners();
  }

  void switchTheme(){
    _isDarkTheme = !_isDarkTheme;

    _savePreferences();
  }

  Color get color => _isDarkTheme ? Colors.black : Colors.white;
  bool get isDarkTheme => _isDarkTheme;

  Future<void> reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = false;
    prefs.remove(_key);
    notifyListeners();
  }
}

class GameProcessProvider extends ChangeNotifier{
  static const String _clicksKey = "clicks";
  static const String _clickStrengthKey = "strength";

  int _clicks = 0;

  int _csLevel = 1;
  int _strength = 1;
  int _needForUpgradeStrength = 100;

  GameProcessProvider(){
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await SharedPreferences.getInstance().then((prefs){
      _clicks = prefs.getInt(_clicksKey) ?? 0;
      _csLevel = prefs.getInt(_clickStrengthKey) ?? 1;

      updateClickStrength();
      updateClicksForUpgradeStrength();

      notifyListeners();
    });
  }

  Future<void> _saveClicks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(_clicksKey, _clicks);
    notifyListeners();
  }

  int get clicks => _clicks;

  void incrementClicks(){
    _clicks+=_strength;
    _saveClicks();
  }

  Future<void> _saveImprovementsLevels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(_clickStrengthKey, _csLevel);
    notifyListeners();
  }

  void incrementStrengthLevel() {
    _csLevel++;
    _strength*=2;
    _needForUpgradeStrength*=4;
    _saveImprovementsLevels();
  }

  int get strengthLevel => _csLevel;

  void updateClickStrength(){
    int buffer = 1;

    if(_csLevel > 1){
      buffer = pow(2, _csLevel-1).toInt();
    }

    _strength = buffer;
  }

  void updateClicksForUpgradeStrength() {
    int buffer = 100;

    for(int i = 0; i < _csLevel-1; i++){
      buffer*=4;
    }

    _needForUpgradeStrength = buffer;
  }
  
  int get strength => _strength;
  int get needForUpgradeStrength => _needForUpgradeStrength;

  void substractClicks(){
    _clicks-=_needForUpgradeStrength;

    _saveClicks();
  }

  Future<void> resetAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(_clicksKey);
    prefs.remove(_clickStrengthKey);

    _clicks = 0;
    _csLevel = 1;
    _strength = 1;
    _needForUpgradeStrength = 100;

    notifyListeners();
  }
}

class Language {
  final List<String> words;
  final String language;

  Language({
    required this.language,
    required this.words
  });
}

Language russian = Language(
  language: "Русский",
  words: ["Играть", "Улучшения", "Настройки", "Уровень: ", "Требуется: ", "Сила: ", "Тёмная тема", "Стереть всё",
"Вы уверены?", "ДА", "НЕТ", "Язык:", "Выберите язык:", "Сбросить прогресс"]);

Language english = Language(
  language: "English",
  words: ["Play", "Shop", "Settings", "Level: ", "Need for upgrade: ", "Click strength: ", "Dark theme", "Reset data",
  "Are you sure?", "OK", "Cancel", "Language:", "Choose language:", "Reset progress"]
);

Language arabic = Language(
  language: "العربية",
  words: [
    "العب", "تسوق", "الإعدادات", "المستوى: ", "الحاجة للتحديث: ", 
    "قوة النقر: ", "ثيم داكن", "إعادة تعيين البيانات", "هل أنت متأكد؟", 
    "حسناً", "إلغاء", "اللغة:", "اختر اللغة:", "إعادة تعيين التقدم"
  ]
);

Language japanese = Language(
  language: "日本語",
  words: [
    "プレイ", "ショッピング", "設定", "レベル: ", "アップグレードの必要: ", 
    "クリック強度: ", "ダークテーマ", "データをリセット", "本当にいいですか？", 
    "OK", "キャンセル", "言語:", "言語を選択:", "進捗をリセット"
  ]
);

Language chinese = Language(
  language: "中文",
  words: [
    "玩", "购物", "设置", "等级: ", "需要升级: ", 
    "点击强度: ", "深色主题", "重置数据", "你确定吗？", 
    "好的", "取消", "语言:", "选择语言:", "重置进度"
  ]
);

Language hindi = Language(
  language: "हिन्दी",
  words: [
    "खेलें", "खरीदारी", "सेटिंग्स", "स्तर: ", "अपग्रेड की आवश्यकता: ", 
    "क्लिक ताकत: ", "डार्क थीम", "डेटा रीसेट करें", "क्या आप सुनिश्चित हैं?", 
    "ठीक है", "रद्द करें", "भाषा:", "भाषा चुनें:", "प्रगति रीसेट करें"
  ]
);

Language french = Language(
  language: "Français",
  words: [
    "Jouer", "Magasiner", "Paramètres", "Niveau: ", "Besoin de mise à jour: ", 
    "Force de clic: ", "Thème sombre", "Réinitialiser les données", "Êtes-vous sûr?", 
    "D'accord", "Annuler", "Langue:", "Choisir la langue:", "Réinitialiser les progrès"
  ]
);

Language spanish = Language(
  language: "Español",
  words: [
    "Jugar", "Comprar", "Configuraciones", "Nivel: ", "Necesidad de actualización: ", 
    "Fuerza de clic: ", "Tema oscuro", "Restablecer datos", "¿Estás seguro?", 
    "Aceptar", "Cancelar", "Idioma:", "Elegir idioma:", "Restablecer progreso"
  ]
);

Language korean = Language(
  language: "한국어",
  words: [
    "재생", "쇼핑", "설정", "레벨: ", "업그레이드 필요: ", 
    "클릭 강도: ", "어두운 테마", "데이터 재설정", "확실합니까?", 
    "확인", "취소", "언어:", "언어 선택:", "진행 상황 초기화"
  ]
);

List<Language> languages = <Language>[
  english,
  russian,
  arabic,
  japanese,
  korean,
  spanish,
  french,
  chinese,
  hindi
];

class LanguageProvider extends ChangeNotifier{
  static const String _key = "language";

  Language mainLanguage = english;

  int _indexLanguage = 0;

  LanguageProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await SharedPreferences.getInstance().then((prefs){
      _indexLanguage = prefs.getInt(_key) ?? 0;

      mainLanguage = languages[_indexLanguage];

      notifyListeners();
    });
  }

  Future<void> _savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(_key, _indexLanguage);

    notifyListeners();
  }

  void chooseLanguage(int key) {
    _indexLanguage = key;

    mainLanguage = languages[key];

    _savePreferences();
  }

  Future<void> reset() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _indexLanguage = 0;
    mainLanguage = english;

    prefs.remove(_key);
    notifyListeners();
  }
}