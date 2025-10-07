import 'package:freezed_annotation/freezed_annotation.dart';

part 'load_more_output.freezed.dart';

@freezed
class LoadMoreOutput<T> with _$LoadMoreOutput<T> {
  const factory LoadMoreOutput({
    required List<T> data,
    @Default(null) Object? otherData,
    @Default(1) int page,
    @Default(false) bool isRefreshSuccess,
    @Default(0) int offset,
    @Default(false) bool isLastPage,
  }) = _LoadMoreOutput;

  const LoadMoreOutput._();

  int get nextPage => page + 1;

  int get previousPage => page - 1;
}
