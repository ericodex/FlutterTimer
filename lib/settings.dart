import 'package:ericFocusTimer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Route da página de Settings
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // constantes para interagir com o shared_preferences
  TextEditingController txtTrabalho;
  TextEditingController txtPausa;
  TextEditingController txtDescanco;
  static const String TEMPOTRABALHO = "workTime";
  static const String TEMPOPAUSA = "shortBreak";
  static const String TEMPODESCANCO = "longBreak";
  int workTime;
  int shortBreak;
  int longBreak;
  SharedPreferences prefs;

  @override
  void initState() {
    // cria os objetos q concedem leitura e escrita dos TextFields.
    txtTrabalho = TextEditingController();
    txtPausa = TextEditingController();
    txtDescanco = TextEditingController();
    readSettings(); // Carrega valores iniciar a página.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);
    return Container(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3, // A quantidade de itens exibidos na tela
        childAspectRatio: 3, // Determina o tamanho dos filhos do gridview
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          // Trabalho
          Text('Trabalho', style: textStyle),
          Text(''),
          Text(''),
          SettingButton(
              // Botão -1 Trabalho
              Color(0xff455a64),
              '-',
              20.0,
              -1,
              TEMPOTRABALHO,
              updateSettings),
          TextField(
              //Adicionado controller
              controller: txtTrabalho,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
              // Botão +1 Trabalho
              Color(0xff009688),
              '+',
              20.0,
              1,
              TEMPOTRABALHO,
              updateSettings),

          // Pausa
          Text('Pausa', style: textStyle),
          Text(''),
          Text(''),
          SettingButton(
              // Botão -1 Pausa
              Color(0xff455a64),
              '-',
              5.0,
              -1,
              TEMPOPAUSA,
              updateSettings),
          TextField(
              //Adicionado controller
              controller: txtPausa,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
              // Botão +1 Pausa
              Color(0xff009688),
              '+',
              5.0,
              1,
              TEMPOPAUSA,
              updateSettings),

          // Descanço
          Text('Descanço', style: textStyle),
          Text(''),
          Text(''),
          SettingButton(
              // Botão -1 Descanço
              Color(0xff455a64),
              '-',
              20.0,
              -1,
              TEMPODESCANCO,
              updateSettings),
          TextField(
              //Adicionado controller
              controller: txtDescanco,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SettingButton(
              Color(0xff009688), '+', 20.0, 1, TEMPODESCANCO, updateSettings),
        ],
        padding: const EdgeInsets.all(20),
      ),
    );
  }

  readSettings() async {
    try {
      // Método para ler o prefs
      prefs = await SharedPreferences.getInstance();

      // Verifica se é a primera vez do sharedPreferences
      int workTime = prefs.getInt(TEMPOTRABALHO);
      if (workTime == null) {
        await prefs.setInt(TEMPOTRABALHO, int.parse('30'));
      }

      int shortBreak = prefs.getInt(TEMPOPAUSA);
      if (shortBreak == null) {
        await prefs.setInt(TEMPOPAUSA, int.parse('5'));
      }
      int longBreak = prefs.getInt(TEMPODESCANCO);
      if (longBreak == null) {
        await prefs.setInt(TEMPODESCANCO, int.parse('20'));
      }
      setState(() {
        txtTrabalho.text = workTime.toString();
        txtPausa.text = shortBreak.toString();
        txtDescanco.text = longBreak.toString();
      });
    } catch (AcessarMemoriaInternaApp) {
      print('Algo incompreendido aconteceu no: $AcessarMemoriaInternaApp');
    }
  }

  void updateSettings(String key, int value) {
    switch (key) {
      case TEMPOTRABALHO:
        {
          int workTime = prefs.getInt(TEMPOTRABALHO);
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(TEMPOTRABALHO, workTime);
            setState(() {
              txtTrabalho.text = workTime.toString();
            });
          }
        }
        break;
      case TEMPOPAUSA:
        {
          int shortBreak = prefs.getInt(TEMPOPAUSA);
          shortBreak += value;
          if (shortBreak >= 1 && shortBreak <= 120) {
            prefs.setInt(TEMPOPAUSA, shortBreak);
            setState(() {
              txtPausa.text = shortBreak.toString();
            });
          }
        }
        break;
      case TEMPODESCANCO:
        {
          int longBreak = prefs.getInt(TEMPODESCANCO);
          longBreak += value;
          if (longBreak >= 1 && longBreak <= 180) {
            prefs.setInt(TEMPODESCANCO, longBreak);
            setState(() {
              txtDescanco.text = longBreak.toString();
            });
          }
        }
        break;
    }
  }
}

// Para evitar duplicação de código, utilize um método construtor de botoes
class SettingButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final int value;
  final String setting;
  final CallbackSetting callback;

  SettingButton(
      //
      this.color,
      this.text,
      this.size,
      this.value,
      this.setting,
      this.callback);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => this.callback(this.setting, this.value),
      color: this.color,
      minWidth: this.size,
    );
  }
}
