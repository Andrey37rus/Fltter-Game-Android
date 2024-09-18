import 'package:flutter/material.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: const HiddenNumberGame(),
    );
  }
}

class HiddenNumberGame extends StatefulWidget {
  const HiddenNumberGame({super.key});

  @override
  HiddenNumberGameState createState() => HiddenNumberGameState();
}

class HiddenNumberGameState extends State<HiddenNumberGame> {
  late int targetNumber;
  List<int> hiddenNumbers = [];
  String resultMessage = '';
  List<bool> revealed = [false, false, false, false];
  int attemptsLeft = 2;
  bool showFireworks = false;

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    targetNumber = random.nextInt(99);
    hiddenNumbers = List.generate(3, (_) => random.nextInt(10))..add(targetNumber);
    hiddenNumbers.shuffle();
    revealed = [false, false, false, false];
    attemptsLeft = 2;
    resultMessage = '';
    showFireworks = false;
    setState(() {});
  }

  void checkNumbers(int index, bool isCorrect) {
    setState(() {
      revealed[index] = true;

      if (isCorrect) {
        resultMessage = 'You Win!';
        attemptsLeft = 0;
        showFireworks = true;
      } else {
        attemptsLeft--;
        if (attemptsLeft == 0) {
          resultMessage = 'You Lose!';
        } else {
          resultMessage = 'Wrong, try again!';
        }
      }
    });
  }

  Widget buildButton(int index, bool isCorrect) {
    return ElevatedButton(
      onPressed: attemptsLeft > 0 && !revealed[index]
          ? () => checkNumbers(index, isCorrect)
          : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (revealed[index]) {
              return isCorrect ? AppTheme.correctButtonColor : AppTheme.incorrectButtonColor;
            }
            return AppTheme.defaultButtonColor;
          },
        ),
        foregroundColor: WidgetStateProperty.all<Color>(AppTheme.buttonTextColor),
      ),
      child: revealed[index] ? Text(hiddenNumbers[index].toString()) : const Text('🖕'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Find the Number")),
        backgroundColor: AppTheme.appBarBackgroundColor,
        foregroundColor: AppTheme.appBarForegroundColor,
      ),
      body: Container(
        color: AppTheme.bodyBackgroundColor,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Target number: $targetNumber",
                    style: AppTheme.targetNumberTextStyle,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: hiddenNumbers.asMap().entries.map((entry) {
                    int index = entry.key;
                    int number = entry.value;
                    bool isCorrect = number == targetNumber;
                    return buildButton(index, isCorrect);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  "Attempts left: $attemptsLeft",
                  style: AppTheme.attemptsLeftTextStyle,
                ),
              ],
            ),
            if (resultMessage.isNotEmpty)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    resultMessage,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: resultMessage == "You Win!"
                          ? AppTheme.winTextColor
                          : resultMessage == "You Lose!"
                              ? AppTheme.loseTextColor
                              : AppTheme.defaultTextColor,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: generateRandomNumbers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.newGameButtonColor,
                    foregroundColor: AppTheme.newGameButtonTextColor,
                  ),
                  child: const Text("New Game"),
                ),
              ),
            ),
            if (showFireworks)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Lottie.asset(
                  'assets/animations/fireworks.json',
                  repeat: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppTheme {
  static const Color appBarBackgroundColor = Color(0xFF2E294E);
  static const Color appBarForegroundColor = Color(0xFFEFBCD5);
  static const Color bodyBackgroundColor = Color(0xFFEFBCD5);
  static const Color targetNumberTextColor = Color(0xFF2E294E);
  static const Color attemptsLeftTextColor = Color(0xFF2E294E);
  static const Color defaultTextColor = Color(0xFF000000);
  static const Color winTextColor = Colors.green;
  static const Color loseTextColor = Colors.red;
  static const Color defaultButtonColor = Color(0xFFBE97C6);
  static const Color correctButtonColor = Colors.green;
  static const Color incorrectButtonColor = Color.fromARGB(255, 137, 159, 202);
  static const Color buttonTextColor = Colors.black;
  static const Color newGameButtonColor = Color(0xFF8661C1);
  static const Color newGameButtonTextColor = Color(0xFFFFFFFF);

  static final ThemeData themeData = ThemeData(
    primaryColor: appBarBackgroundColor,
    scaffoldBackgroundColor: bodyBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarBackgroundColor,
      foregroundColor: appBarForegroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: defaultButtonColor,
        foregroundColor: buttonTextColor,
      ),
    ),
  );

  static const TextStyle targetNumberTextStyle = TextStyle(
    fontSize: 24,
    color: targetNumberTextColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle attemptsLeftTextStyle = TextStyle(
    fontSize: 18,
    color: attemptsLeftTextColor,
    fontWeight: FontWeight.bold,
  );
}