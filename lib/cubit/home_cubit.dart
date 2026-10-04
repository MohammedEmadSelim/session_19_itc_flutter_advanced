import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:session_19_itc_flutter_advanced/models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getProducts() async {
    emit(HomeGetProductsLoading());
    try {
      var url = Uri.parse("https://dummyjson.com/products");
      // var data = await http.get(url);
      // // model
      // print("_________>>_______ ${data.body}");

      var dio = Dio();

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('');
            print('══════════════════════════════════════════════════════');
            print('🚀 DIO REQUEST');
            print('══════════════════════════════════════════════════════');

            print('➡️ Method   : ${options.method}');
            print('🌐 URL      : ${options.uri}');

            if (options.queryParameters.isNotEmpty) {
              print('🔍 Query    : ${options.queryParameters}');
            }

            if (options.headers.isNotEmpty) {
              print('📋 Headers  : ${options.headers}');
            }

            if (options.data != null) {
              print('📦 Body     : ${options.data}');
            }

            print('══════════════════════════════════════════════════════');
            print('');

            handler.next(options);
          },

          onResponse: (response, handler) {
            print('');
            print('══════════════════════════════════════════════════════');
            print('✅ DIO RESPONSE');
            print('══════════════════════════════════════════════════════');

            print('➡️ Method   : ${response.requestOptions.method}');
            print('🌐 URL      : ${response.requestOptions.uri}');
            print('📊 Status   : ${response.statusCode}');
            print('📦 Data     : ${response.data}');

            print('══════════════════════════════════════════════════════');
            print('');

            handler.next(response);
          },

          onError: (error, handler) {
            print('');
            print('══════════════════════════════════════════════════════');
            print('❌ DIO ERROR');
            print('══════════════════════════════════════════════════════');

            print('➡️ error   : ${error}');
            print('➡️ Method   : ${error.requestOptions.method}');
            print('🌐 URL      : ${error.requestOptions.uri}');
            print('📊 Status   : ${error.response?.statusCode}');
            print('⚠️ Type     : ${error.type}');
            print('💬 Message  : ${error.message}');

            if (error.response?.data != null) {
              print('📦 Response : ${error.response?.data}');
            }

            print('══════════════════════════════════════════════════════');
            print('');

            handler.next(error);
          },
        ),
      );

      var data = await dio.get("https://dummyjson.com/products");
      //
      // var postedData = await dio.post(
      //   "https://dummyjson.com/products/add",
      //   data: {"title": "keyboard logitech", "price": 750},
      // );

      // print("postedData   =====>>>>>>>> ${postedData.data}");

      var products = ProductsResponse.fromJson((data.data));

      print(products.products.length);

      emit(HomeGetProductsSuccess(products.products));
    } catch (e) {
      if (e is TypeError) {
        print(e.stackTrace);
      }

      emit(HomeGetProductsFailure(e.toString()));
    }
  }
}
