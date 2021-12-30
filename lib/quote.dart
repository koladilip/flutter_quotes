import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import "dart:math";

T? getRandomElement<T>(List<T>? list) {
  if (list == null) {
    return null;
  }
  final random = Random();
  var i = random.nextInt(list.length);
  return list[i];
}

Future<List<Quote>> getQuotes() async {
  var jsonRaw = await rootBundle.loadString('assets/quotes.json');
  var quotes = json.decode(jsonRaw) as List;
  return quotes.map((quoteJson) => Quote.fromJson(quoteJson)).toList();
}

class Quote {
  final String quote;
  final String author;
  Quote(this.quote, this.author);

  factory Quote.fromJson(dynamic json) {
    return Quote(json['quote'] as String, json['author'] as String);
  }
}

class QuoteWidget extends StatelessWidget {
  final Quote quote;
  const QuoteWidget({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Text(
            quote.quote,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 10.0),
          child: Text(
            quote.author,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class QuoteWidgetController extends StatefulWidget {
  static final quotesFuture = getQuotes();

  const QuoteWidgetController({Key? key}) : super(key: key);

  @override
  State<QuoteWidgetController> createState() => _QuoteWidgetControllerState();
}

class _QuoteWidgetControllerState extends State<QuoteWidgetController> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>>(
        future: QuoteWidgetController.quotesFuture,
        builder: (context, AsyncSnapshot<List<Quote>> snapshot) {
          if (snapshot.hasData) {
            var quotes = snapshot.data;
            var quote = getRandomElement(quotes);
            if (quote == null) {
              return const Text('Keep smiling');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QuoteWidget(quote: quote),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                      onPressed: refresh, child: const Text("New Quote")),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
