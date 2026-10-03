import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:session_19_itc_flutter_advanced/models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getProducts() async {
    emit(HomeGetProductsLoading());
    try {
      var url = Uri.parse("https://dummyjson.com/products");
      var data = await http.get(url);
      // model
      print("_________>>_______ ${data.body}");
      var products = ProductsResponse.fromJson(json.decode(data.body));

      print(products.products.length);

      emit(HomeGetProductsSuccess(products.products));
    } catch (e) {

      if(e is TypeError){
        print(e.stackTrace);
      }

      emit(HomeGetProductsFailure(e.toString()));
    }
  }
}
