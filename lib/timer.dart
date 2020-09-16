import 'dart:async';
import 'timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1; // Percentual de completude
  bool _isActive = true; // Cronomêtro: Ativo ou Desativado
  Timer timer; // Timer é uma classe que cria cronometros regressivos
  Duration _time; // Expressa o tempo remanescente
  Duration _fullTime; // Represemta o tempo inicial (ex: pausa, 5 minutos.)

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if (_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  // Função para formatação dos texto de tempo
  // ex: 05:42

  // Duration é um classe do dart utilizada para conter um período de tempo.
  String returntime(Duration t) {
    // .inMinutes retorna os minutos assim como .inSeconds retorna os segundos, se qualquer um dos dois for menor do 10, é adicionado o no texto o '0' a esquerda para melhor apresentação.
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();

    int numSeconds = t.inSeconds - (t.inMinutes * 60);

    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();

    // Concatena ambos os textos.
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  // Um método stream() retorna um Stream, stream é genérico e pode ser de qualquer tipo.

  // O retorno do stream é <TimerModel>
  Stream<TimerModel> stream() async* {
    // O método é assíncrono
    // async* representa Streams    (async sem o asterisco representa Future)

    // O yield* é a construção de um retorno que não encerra a função
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      // Está programado a peridiocidade de 1 segundo

      String time;
      if (this._isActive) {
        // Verifica se _isActive é verdadeiro (true)

        // Se o contador tiver ativo
        // decrementa o _time em menos 1
        _time = _time - Duration(seconds: 1);

        // Atualiza o _radius (raio do gráfico do contador)
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          // Desativa quando o Contador _time chegar em 0
          _isActive = false;
        }
      }

      // Chama o método que transforma o tempo em texto.
      time = returntime(_time);

      // Retorna um TimerModer (timermodel.dart) com o tempo e o raio para exibição.
      return TimerModel(time, _radius);
    });
  }

  int trabalho = 30;
  int pausa = 5;
  int descanco = 20;

  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trabalho = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    pausa = prefs.getInt('shortBreak') == null ? 5 : prefs.getInt('shortBreak');
    descanco =
        prefs.getInt('longBreak') == null ? 20 : prefs.getInt('longBreak');
  }

  void startTrabalho() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: this.trabalho, seconds: 0);
    _fullTime = _time;
  }

  void startPausa(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: (isShort) ? pausa : descanco, seconds: 0);
    _fullTime = _time;
  }
}
