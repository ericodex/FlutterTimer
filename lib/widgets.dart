import 'package:flutter/material.dart';

// (pointer) que aponta para uma função.
typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  // (Named Parameters) Parametros nomeados, para reutilização de código criando vários botões diferentes utilizando parametrização.

  final String text;
  final double size;
  final IconData icone; // Tipo de dado para icone

  final VoidCallback onPressed;
  // @required faz com que o parametro seja mantatório.
  ProductivityButton(
      {@required this.text,
      @required this.icone,
      @required this.onPressed,
      @required this.size});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Icon(
                this.icone,
                // color: Colors.yellow[100],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  this.text,
                  style: TextStyle(color: Colors.deepPurple[50]),
                ),
              ),
            ],
          ),
        ),
        onPressed: this.onPressed,
        //color: this.color,
        minWidth: this.size);
  }
}
