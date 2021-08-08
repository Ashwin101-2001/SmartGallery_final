import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_gallery/Gallery.dart';



class MyCustomForm extends StatefulWidget {
  Map<String,dynamic> map;
  MyCustomForm(this.map);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState(map);
  }
}


class MyCustomFormState extends State<MyCustomForm> {

  Map<String,dynamic> map;
  MyCustomFormState(this.map);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController scontroller = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  AutoCompleteTextField searchTextField;
  String search;
  List<String> suggestions;
  bool loading ;


  @override
  void initState() {
    // TODO: implement initState
    loading=true;
   scontroller.text="";
    super.initState();
    init();
  }

  void init() async
  {
    suggestions= List<String>();
        setSlist();
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print(suggestions);

     return Form(

       key: _formKey,
       child: loading
           ? CircularProgressIndicator()
           : searchTextField = AutoCompleteTextField<String>(
         controller: scontroller,
         suggestions: suggestions,
         clearOnSubmit: true,
         key: key1,


         textSubmitted: (item) async
         {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(
                 builder: (context) => Gallery(item)),
           );
         },


         itemFilter: (item, query) {
           return item
               .toLowerCase()
               .startsWith(query.toLowerCase());
         },


         itemSorter: (a, b) {
           return a.compareTo(b);
         },

         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),


         decoration: InputDecoration(
           suffixIcon: IconButton(
             icon: Icon(Icons.cancel_outlined,color: Colors.blue,),
             onPressed: () {
               setState(() {
                 scontroller.text = " ";
               });
             },
           ),


           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.blue, width: 2.7),
           ),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.white, width: 2.7),
           ),
           hintText: '  Search Tags',
           hintStyle: TextStyle(color: Colors.white60,),



         ),

         itemBuilder: (context, item) {
           print(' item builder : $item  ');
           return GestureDetector(
             onTap: () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                     builder: (context) => Gallery(item)),
               );
             },

             child: Container(
               decoration: BoxDecoration(
                   color: Colors.white60,
                   border: Border.all(color: Colors.blueAccent, width: 2.0)
               ),
               //
               padding: EdgeInsets.only(bottom: 10.0),
               child: Row(

                 children: [
                   Expanded(flex: 1,
                       child: Icon(Icons.search, color: Colors.blue[800],)),
                   Expanded(flex: 1,
                     child: Container(),),
                   Expanded(flex: 10,
                       child: Text(item, style: TextStyle(
                           color: Colors.pink[800],
                           fontSize: 20,
                           fontWeight: FontWeight.bold),)),

                   Expanded(flex: 2,
                     child: Container(),),

                 ],
               ),
             ),
           );
         },

       ),


     );



  }
  // Build a Form widget using the _formKey created above.
  void setSlist() {

    for (String  s in map.keys) {
      List<String> x = map[s].split(",");
      x = x.toSet().toList();
      for (String j in x) {
        if (!suggestions.contains(j.replaceAll(' ', ''))) suggestions.add(j.replaceAll(' ', ''));
      }
    }
  }
}





