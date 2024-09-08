import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState('');

    useEffect(() {
      controller.addListener(() {
        text.value = controller.text;
      });
      return null;
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Home page',
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
          ),
          Text('You typed: ${text.value}')
        ],
      ),
    );
  }
}
