import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/base/base_cubit.dart';
import 'package:base_doanh/presentation/main_screen/ui/main_screen.dart';

part 'main_state.dart';

class MainCubit extends BaseCubit<MainState> {
  MainCubit() : super(MainInitial());
  final BehaviorSubject<int> _index = BehaviorSubject<int>.seeded(0);

  Stream<int> get indexStream => _index.stream;

  Sink<int> get indexSink => _index.sink;

  int get currentIndex => _index.valueOrNull ?? tabBookTicketIndex;
}
