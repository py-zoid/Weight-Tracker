import 'dart:async';

class SelectedWeightBloc {
  var _textController = StreamController<String>();
  Stream<String> get textStream => _textController.stream;

  dispose() {
    _textController.close();
  }

  updateText(String text) {
    text == null
        ? _textController.sink.add("")
        : _textController.sink.add(text);
  }
}
