import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:session_19_itc_flutter_advanced/cubit/home_cubit.dart';
import 'package:session_19_itc_flutter_advanced/models/product_model.dart';

void main() async {
  // 1- fetching data  - send data
  // 2- display on ui

  // http - dio ---> packages pub dev
  /// fetch data
  var url = Uri.parse("https://dummyjson.com/products/9");
  var data = await http.get(url);

  /// send data  ----> post
  // var url = Uri.parse("https://dummyjson.com/products/1");
  /// post
  // var data = await http.pos(
  //   url,
  //   body: jsonEncode({"title": "keyboard logitech", "price": 750}),
  // );
  /// put
  // var data = await http.put(
  //   url,
  //   body: jsonEncode({"title": "keyboard logitech", "price": 750}),
  // );

  /// delete
  // var data = await http.delete(url);

  print(data.body);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => HomeCubit(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    context.read<HomeCubit>().getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeGetProductsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeGetProductsFailure) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          }
          var products = state is HomeGetProductsSuccess ? state.products :<Product> [];

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 12),
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {

              var product = products[index] ;
              return Container(
              width: 320,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 4,
                    blurRadius: 2.1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(child: Image.network(product.images.first)),
                ],
              ),
            );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
