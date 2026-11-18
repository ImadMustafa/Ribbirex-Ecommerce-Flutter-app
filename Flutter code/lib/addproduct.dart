import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';


class Addproductpage extends StatefulWidget {
  const Addproductpage({super.key});

  @override
  _AddproductpageState createState() => _AddproductpageState();
}


class _AddproductpageState extends State<Addproductpage> {

  //variables
  String version = "";
  late List info;
  late String userid = "";
  String? _selectedCategory;
  bool tradable = false;
  List<String> categories = [];
  
  File? _image;
  File? _zipf;
  bool afimg = false;
  bool updimg = false;

  final _addform = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _nameke = GlobalKey<FormState>();

  bool selcat = false;
  bool selimg = false;
  bool selfil = false;
  bool _requestdone = true;


 @override
  void initState() {
    super.initState();
    _updateCategory();
    aftv();
    savepass().then((value) {
      setState(() {
        info = value ?? [];
        //we save the orginal info
        userid = info.isNotEmpty ? info[4] : '';

      });
    });
  }

   



  Future<List<String>?> getthepass() async {
    SharedPreferences useinf = await SharedPreferences.getInstance();
    return useinf.getStringList('usersav');
  }

  Future<List<String>?> savepass() async {
    List<String>? savedinfo = await getthepass();
    return savedinfo;
  }
  Future<String?> getv() async {
    SharedPreferences infos = await SharedPreferences.getInstance();
    return infos.getString('appv');
  }

  void aftv() async {
    String? av = await getv();
    setState(() {
      version = av!;
    });
  }



//img select mehtod
Future<void>pickimgx() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  

    setState(() {
      selimg = false;
      afimg = true;
      _image = File(pickedFile!.path);
      
      
    });
  }

  //zip select mehtod
Future<void>pickzipx() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      initialDirectory: Platform.isAndroid ? '/storage/emulated/0/Download' : null,
      type: FileType.custom,
      allowedExtensions: ['zip']
    );

 
    setState(() {
      selfil = false;
      afimg = true;
      _zipf = File(pickedFile!.files.single.path!);
      
    });

  
  }





    //method to get all category start
    Future<void> _updateCategory() async {

      //we send the request
      final responsegetcate = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/allcategoryinfo.php'),
    );
    if(responsegetcate.statusCode == 200){

      final allcatjs = responsegetcate.body;
      final allcat = jsonDecode(allcatjs);
      List<String> allcatx = [];
      for(var cat in allcat){
        allcatx.add(cat.toString());
      }

      setState(() {
        categories = allcatx;
      });
    }
  
    }
     //method to get all category end




   //method to get add product start
    Future<void> _addproduct() async {
     
      if(_selectedCategory != null){
      
       if (_image != null && _zipf != null){
    
      if(_addform.currentState!.validate()){

         setState(() {
        _requestdone = false;
      });

      //we get all the info
      final name = _name.text;
      final price = _price.text;
      final descr = _description.text;
      final categ = _selectedCategory;
      final tradb = tradable;
      
      
       final proinfox = {
        'name': name,
        'price': price,
        'desc' : descr,
        'tradble': tradb,
        'categ' : categ,
        'uid' : userid
      };
      
      
      //we convert the data into a json
      final injs = jsonEncode(proinfox);
      
     
    var request = http.MultipartRequest('POST', Uri.parse('https://navajowhite-worm-558163.hostingersite.com/addproducts.php'));
    //we add the image to the request
    request.files.add(
    await http.MultipartFile.fromPath('cover', _image!.path,
  
    
    ));
  //we add the zip to the request
  request.files.add(
  await http.MultipartFile.fromPath('zipf',_zipf!.path,
  contentType: MediaType('application', 'zip'),
  ),
);
    //we add the fields to the request
    request.fields['prodata']= injs;

    setState(() {
      updimg = true;
    });

     //we send the request
    var responsegetcate = await request.send();

    if(responsegetcate.statusCode == 200){
     
      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added.')),
      );
      }
      //clear all fields
      _name.clear();
      _price.clear();
      _description.clear();
      setState(() {
        tradable = false;
        _image = null;
        _zipf = null;
      });
      

    }
    else{

      if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client or server error')),
      );
      }

    }
      setState(() {
        _requestdone = true;
      });


      }

       }
       //if there is no selected img
       else if(_image == null){
        setState(() {
          selimg = true;

        });

       }
       else if(_zipf == null){

        setState(() {
          selfil = true;

        });

       }

      }
      
      //if there is no selected catregory
      else{

        setState(() {
            selcat = true;
        });

      }
    }
     //method to get add product end







  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFCEDC2),
      ),

      




      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _addform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text("Product Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _name,
                    key: _nameke,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),   
                    ),
                    validator: (value) {
          
                     if (value!.isEmpty) {
                          return 'Required Field';
                      }
                        const pattern = (r'^[a-zA-Z0-9 -]+$');
                        final regExp = RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Only letters';
                        }
                          return null;
          
                    },
                       onChanged: (value){
                            _addform.currentState!.validate();
                                  
                            },
                  ),
                  const SizedBox(height: 20),
                  const Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                       validator: (value) {
          
                     if (value!.isEmpty) {
                          return 'Required Field';
                      }
                        const pattern = (r'^[0-9]+$');
                        final regExp = RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Only numbers';
                        }
                          return null;
          
                    },
                       onChanged: (value){
                            _addform.currentState!.validate();
                       }
                  ),
                  const SizedBox(height: 20),
                  const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Choose Category"),
                    value: _selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selcat = false;
                        _selectedCategory = value!;
                       
                      });
                    },
                    items: categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  selcat? const Text("Select Category",style: TextStyle(color: Colors.red),): const Text(""),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Tradable", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10,),
                      Checkbox(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        value: tradable,
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              tradable = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _description,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                       validator: (value) {
          
                     if (value!.isEmpty) {
                          return 'Required Field';
                      }
                        const pattern = r'^[a-zA-Z0-9 .,"-]+$';
                        final regExp = RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Only letters and numbers';
                        }
                          return null;
          
                    },
                       onChanged: (value){
                            _addform.currentState!.validate();
                       }
                  ),
                          
                  
                   Row(
                     children: [
                      const Text("Select image"),
                       IconButton(
                          tooltip: "Edit photo",     
                          onPressed: () {
                          pickimgx();
                      },
                      icon: const Icon(Icons.image_search),
                    ),
                     ],
                   ),
                   const SizedBox(height: 5,),
                  selimg? const Text("Required field",style: TextStyle(color: Colors.red),):const Text(""),
                 ClipOval(
                  child:
                    _image != null ?
                    Image.file(_image!,width: 150,height: 150):null,
                  ),
                  const SizedBox(height: 5,),
                    Row(
                     children: [
                      const Text("Select Zip folder"),
                       IconButton(
                          tooltip: "Select folder",     
                          onPressed: () {
                          pickzipx();
                      },
                      icon: const Icon(Icons.folder_zip),
                    ),
                     ],
                   ),
                   selfil? const Text("Required field",style: TextStyle(color: Colors.red),):const Text(""),
                    Center(
                    child: _zipf != null ? Text(
                    _zipf!.path.split('/').last,
                      style: const TextStyle(fontSize: 16),
                       ) : null,
                      ),
                      
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF49AFD2),
                    ),
                    onPressed: () {
                      _addproduct();
                    },
                    child: _requestdone? const Text(
                      "Upload Product",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ):const SizedBox(width: 23,height: 23,
                      child: CircularProgressIndicator(),
                      ),
                  ),
                ],
              ),
            ),
          ),
      
        ],
      ),
    );
  }
}

