import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        primaryColor: const Color(0xFF1F2937),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        hintColor: const Color(0xFF60A5FA),
        canvasColor: const Color(0xFFFFFFFF),
        cardColor: const Color(0xFFFFFFFF),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Color(0xFF111827)),
          bodyMedium: TextStyle(color: Color(0xFF374151)),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1F2937),
          secondary: const Color(0xFF60A5FA),
          onPrimary: Colors.white,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '0';

  final List<String> buttons = [
    'C', '+/-', '%', 'DEL',
    '7', '8', '9', '/',
    '4', '5', '6', 'x',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyMediumColor = theme.textTheme.bodyMedium?.color;
    final headlineSmallColor = theme.textTheme.headlineSmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flutter Calculator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 4.0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((255 * 0.1).round()),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      userInput.isEmpty ? '0' : userInput,
                      style: TextStyle(
                        fontSize: 28,
                        color: bodyMediumColor?.withAlpha((255 * 0.7).round()),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    answer,
                    style: TextStyle(
                      fontSize: 48,
                      color: headlineSmallColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final buttonText = buttons[index];

                  if (buttonText == 'C') {
                    return MyButton(
                      key: ValueKey('button_$buttonText'),
                      buttontapped: () {
                        setState(() {
                          userInput = '';
                          answer = '0';
                        });
                      },
                      buttonText: buttonText,
                      color: const Color(0xFFFECACA),
                      textColor: const Color(0xFFDC2626),
                    );
                  } else if (buttonText == 'DEL') {
                    return MyButton(
                      key: ValueKey('button_$buttonText'),
                      buttontapped: () {
                        setState(() {
                          if (userInput.isNotEmpty) {
                            userInput = userInput.substring(0, userInput.length - 1);
                          }
                        });
                      },
                      buttonText: buttonText,
                      color: const Color(0xFFFED7AA),
                      textColor: const Color(0xFFF97316),
                    );
                  } else if (buttonText == '=') {
                    return MyButton(
                      key: ValueKey('button_$buttonText'),
                      buttontapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttonText,
                      color: theme.hintColor,
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      key: ValueKey('button_$buttonText'),
                      buttontapped: () {
                        setState(() {
                          if (buttonText == '+/-') {
                            if (userInput.isNotEmpty) {
                              if (userInput.startsWith('-')) {
                                userInput = userInput.substring(1);
                              } else {
                                if (userInput != '0' && userInput.isNotEmpty) {
                                  userInput = '-$userInput';
                                } else if (userInput.isEmpty) {
                                  userInput = '-';
                                }
                                else if (userInput == '0'){
                                  userInput = '-';
                                }
                              }
                            } else {
                              userInput = '-';
                            }
                          } else {
                            if (isOperator(buttonText) && userInput.isNotEmpty && isOperator(userInput[userInput.length -1])) {
                              if (userInput.length > 1 || userInput[userInput.length -1] != '-') {
                                userInput = userInput.substring(0, userInput.length -1) + buttonText;
                              } else if (buttonText != '-') {
                                userInput = userInput.substring(0, userInput.length -1) + buttonText;
                              }
                            } else if (isOperator(buttonText) && userInput.isEmpty && buttonText != '-'){
                              // Do nothing
                            }
                            else {
                              userInput += buttonText;
                            }
                          }
                        });
                      },
                      buttonText: buttonText,
                      color: isOperator(buttonText)
                          ? const Color(0xFFBFDBFE)
                          : theme.cardColor,
                      textColor: isOperator(buttonText)
                          ? theme.hintColor
                          : bodyMediumColor,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '%') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalUserInput = userInput;

    if (finalUserInput.isNotEmpty && isOperator(finalUserInput[finalUserInput.length -1]) && finalUserInput[finalUserInput.length -1] != '%') {
      return;
    }

    finalUserInput = finalUserInput.replaceAll('x', '*');

    if (finalUserInput.endsWith('%')) {
      if (finalUserInput.length > 1) {
        finalUserInput = '${finalUserInput.substring(0, finalUserInput.length - 1)}/100';
      } else {
        answer = "Error";
        userInput = "";
        return;
      }
    } else {
      finalUserInput = finalUserInput.replaceAllMapped(RegExp(r'(\d+\.?\d*)%'), (match) {
        return '(${match.group(1)!}/100)';
      });
    }

    if (finalUserInput.isEmpty) {
      answer = "0";
      return;
    }

    try {
      final parser = ShuntingYardParser();
      Expression exp = parser.parse(finalUserInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isNaN || eval.isInfinite) {
        answer = "Error";
        userInput = "";
      } else {
        if (eval == eval.toInt().toDouble()) {
          answer = eval.toInt().toString();
        } else {
          answer = eval.toStringAsFixed(4);
          answer = answer.replaceAll(RegExp(r'0*$'), '');
          if (answer.endsWith('.')) {
            answer = answer.substring(0, answer.length - 1);
          }
        }
      }
    } catch (e) {
      answer = "Error";
      userInput = "";
    }
  }
}

// creating Stateless Widget for buttons
@immutable
class MyButton extends StatelessWidget {
  // declaring variables
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final VoidCallback? buttontapped;

  //Constructor
  const MyButton({ // Added const
    super.key, // Added key
    this.color,
    this.textColor,
    required this.buttonText,
    this.buttontapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme for fallback colors/styles
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(0.2), // User's specified padding
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Rounded corners like in the immersive
          child: Container(
            decoration: BoxDecoration(
              color: color ?? theme.cardColor, // Use provided color or theme's card color
              // borderRadius is also set here to ensure the container itself is rounded,
              // complementing ClipRRect, especially if there were other effects.
              borderRadius: BorderRadius.circular(16),
              boxShadow: [ // Subtle shadow for depth, from the immersive
                BoxShadow(
                  color: Colors.grey.withAlpha((255 * 0.15).round()),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? theme.textTheme.bodyMedium?.color, // Use provided or theme text color
                  fontSize: 22, // Consistent font size from immersive
                  fontWeight: FontWeight.w500, // Consistent font weight from immersive
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
