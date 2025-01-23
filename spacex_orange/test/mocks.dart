import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:spacex_orange/helpers/database_helper.dart';

// Generate mocks using build_runner
@GenerateMocks([http.Client, DatabaseHelper])
import 'mocks.mocks.dart';