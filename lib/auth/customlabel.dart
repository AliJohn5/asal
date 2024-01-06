
import "package:flutter/material.dart";

class CustomLabel extends StatefulWidget
{
  const CustomLabel({required this.hittext,required this.title,required this.formKey,required this.cont,Key? key, required this.ispassword, required this.validetext}):super(key: key);

  final String hittext;
  final String title;
  final TextEditingController cont;
  final bool ispassword;
  final  GlobalKey<FormState> formKey;
  final Function validetext;

  @override
  State<CustomLabel> createState() => _CustomLabel();
}


class _CustomLabel extends State<CustomLabel>
{
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(10),
          child: Text(widget.title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 23), 
          ),
        ),
        Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: widget.formKey,
            
            child: TextFormField(
              
              validator: (value) {
                 return widget.validetext(value);
              },

              obscureText: widget.ispassword,
              
              decoration: InputDecoration(
                fillColor: Colors.black38,
                focusColor: Colors.black38,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),
                hintText: widget.hittext,
              
              ),
              controller: widget.cont,
              
              
            ),
          ),
          
        
      ]);

    
  }

}