
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'menupage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class Myproductpage extends StatefulWidget {
  final String uid;
  const Myproductpage({required this.uid, super.key });

  @override
  _MyproductpageState createState() => _MyproductpageState();
}

class _MyproductpageState extends State<Myproductpage> {

List listProducts = [];
bool hoverover = false;
bool _requestdone = true;


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
  late String orgimg = "";
  late String zipname = "";
  bool editing = false;


@override
  void initState() {
    super.initState();

    getmyproducts(1);

  }





//we call this on refresh
 Future<void> callgetpro() async {
  getmyproducts(1);
 }

  //get product method
  Future<void> getmyproducts(value) async {
      setState(() {
        _requestdone = false;
      });


      final uid = widget.uid;
      //we map the data
      final useinfo = {
        'uid':uid,'key':value
        };


      //we convert the data into a json
      final injs = jsonEncode(useinfo);

     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/myproductpage.php'),
      body: injs

    );

    if(response.statusCode == 200){
      final projs = response.body;
      final prol = jsonDecode(projs);
      print(prol);
      setState(() {
        listProducts = prol;
      });

    }
    else{
         if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server or Client error.')),
      );
    }

    }
      setState(() {
        _requestdone = true;
      });

  }
  //get product end



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

  if(pickedFile != null){
    setState(() {
      selimg = false;
      afimg = true;
      _zipf = File(pickedFile.files.single.path!);

    });

  }

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






  Future<void> editprofor(value) async {

    _updateCategory();
    final prid = value;

      final useinfo = {
        'pid':prid,

        };


      //we convert the data into a json
      final injs = jsonEncode(useinfo);

      //we send the json to our php to check the username and password
      final responsegetinf = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/editproductgi.php'),
      body: injs,
    );
    if(responsegetinf.statusCode == 200){
      //clear the form field
      final info = jsonDecode(responsegetinf.body);
      setState(() {
        _name.text = info['pname'] as String;
        _price.text = info['pprice'] as String;
        _description.text = info['pdesc'] as String;
        orgimg = info['pimgs'] as String;
        final tradb = info['trad'] as String;
        zipname = info['zipn'] as String;
        zipname = zipname.split("/").last;
        _selectedCategory = info['catn'] as String;
        if(tradb == "1"){
          tradable = true;
        }


      });

    }

    if(mounted){
              showDialog(context: context, builder: (BuildContext context) {

               return SingleChildScrollView(
                 child: AlertDialog(
                  title:  const Text("Edit product"),

                  actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      setState(() {
                        editing = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  editformwid(prid)

                      ],
                      ),
               );
                  });


              }

   }

//edit product start
Future<void> editpro(value) async {


       if(_selectedCategory != null){



      if(_addform.currentState!.validate()){

      setState(() {
          _requestdone = false;
      });

      //we get all the info
      final proid = value;
      final name = _name.text;
      final price = _price.text;
      final descr = _description.text;
      final categ = _selectedCategory;
      final tradb = tradable;


       final proinfox = {
        'prid':proid,
        'name': name,
        'price': price,
        'desc' : descr,
        'tradble': tradb,
        'categ' : categ,
      };


      //we convert the data into a json
      final injs = jsonEncode(proinfox);


    var request = http.MultipartRequest('POST', Uri.parse('https://navajowhite-worm-558163.hostingersite.com/editproductup.php'));
    if(_image != null){
    //we add the image to the request
    request.files.add(
    await http.MultipartFile.fromPath('cover', _image!.path,

    ));
    }
    if(_zipf != null){
    //we add the zip to the request
    request.files.add(
    await http.MultipartFile.fromPath('zipf',_zipf!.path,
    contentType: MediaType('application', 'zip'),
    ),
    );
    }
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
        const SnackBar(content: Text('Product edited.')),
      );
      setState(() {
        editing = false;
      });

    Navigator.of(context).pop();
    getmyproducts(1).then(value);

      }

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



        //if there is no selected img
       else{
        setState(() {
          selimg = true;

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
//edit prodcut end


//delete product start
Future<void> deletepro(value) async {

  //we get all the info
      final proid = value;



       final proinfox = {
        'prid':proid,
      };

      //we convert the data into a json
      final injs = jsonEncode(proinfox);

       //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/deletepro.php'),
      body: injs,
    );
    //if username and password match
    if (response.statusCode == 200) {

      if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted')),
      );

      }


    }
    else{

      if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot Delete')),
      );

      }

    }

    if(mounted){

    Navigator.of(context).pop();

    }


}
//delete product end





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
         appBar: AppBar(
        backgroundColor: const Color(0xFFFCEDC2),
        title: const Text("My Products",style:TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {

           Navigator.pushAndRemoveUntil(
          context,
        MaterialPageRoute(builder: (context) => const Menupage()),
        (route) => false,);

          }
        ),


      ),


        body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: callgetpro,
            child: CustomScrollView(

              slivers: [
                 const SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor:  Color(0xFFFCEDC2),
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,


                  ),


                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3.5,
                      crossAxisCount: 1,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                        childCount: listProducts.length,
                          (BuildContext context, int index) {

                            return InkWell(
                              splashColor: const Color.fromARGB(255, 248, 3, 3),

                              onTap: (){

                              },

                                child: Container(
                                  color: const Color(0xFFC2D1D9),
                                  height: 100,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                    color: const Color(0xFFF2F5F7),
                                    height: 50,
                                    width: 5,
                                      child: Stack(
                                        children: [
                                          Row(

                                            children: [
                                               CachedNetworkImage(
                                                imageUrl: listProducts[index]['pimgs'],
                                                width: 130,
                                                height: 130,
                                                 fit: BoxFit.cover,
                                                placeholder: (context, url) => const CircularProgressIndicator(),
                                               errorWidget: (context, url, error) => const Icon(Icons.error),),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(height: 38 ,child: Text(listProducts[index]['pname'], style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 18),)),
                                                      const SizedBox(height: 5,),
                                                      Row(children: [
                                                        Container(width: 80 ,child: Text('US\$${listProducts[index]['pprice']}', style: const TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold,color:Color(0xFF435964,)))),
                                                        Text(listProducts[index]['trad'] == '1' ? "Tradeable" : "Not Tradeable"),
                                                      ],),
                                                    ],
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),

                                           Positioned(
                                          top: 10,
                                        right: 10,
                                       child: Column(
                                         children: [
                                           PopupMenuButton(
                                                itemBuilder: (BuildContext context) => [
                                                PopupMenuItem(
                                                value: 'Operation',
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextButton( onPressed: !editing?() {
                                                              setState(() {
                                                                editing = true;
                                                              });
                                                              editprofor(listProducts[index]['pid']);


                                                    }:() {
                                                      null;
                                                    },
                                            child: const Text("Edit"),),
                                            TextButton(onPressed:() {


                                                                             showDialog(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                                                             title: const Text("Confirmation"),
                                                                             content: const Text("Are you sure you want to delete your product?"),
                                                                             actions: [

                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                            },
                                                                             ),
                                                                             ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 160, 154, 154),
                                            ),
                                            child: const Text("Delete",style: TextStyle(color: Colors.black),),
                                            onPressed: () {
                                            deletepro(listProducts[index]['pid']).then(
                                              (value) => Navigator.of(context).pop()).then(
                                              (value) => getmyproducts(1));


                                            },
                                                                             ),
                                            ],
                                            );
                                                                             });

                                                    },
                                                    child: const Text("Delete"),),
                                                  ],
                                                ),
                                                ),
                                                ],
                                                icon: const Icon(Icons.more_vert),
                                              ),
                                           IconButton(onPressed: (){
                                             final url = Uri.parse(listProducts[index]['pzip']);
                                             launchUrl(url);
                                           }, icon: const Icon(Icons.download)),
                                         ],
                                       ),
                                          )
                                        ],
                                      ),

                                    ),
                                  ),
                                ),

                            );

                      },

                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),




    );

  }




  //edit form widget
Widget editformwid(proid){

  return StatefulBuilder(


    builder: (context, setState) {


    return Stack(
          children: [

             Form(
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

                              setState(() {
                                tradable = !tradable;
                              });

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
                            pickimgx().then((value) => setState(() {

                            },));

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
                      Image.file(_image!,width: 150,height: 150):CachedNetworkImage(imageUrl: orgimg,height: 25,width: 25,),
                    ),
                    const SizedBox(height: 5,),
                      Row(
                       children: [
                        const Text("Select Zip folder"),
                         IconButton(
                            tooltip: "Select folder",
                            onPressed: () {
                            pickzipx().then((value) => setState((){

                            },));
                        },
                        icon: const Icon(Icons.folder_zip),
                      ),
                       ],
                     ),
                     selimg? const Text("Required field",style: TextStyle(color: Colors.red),):const Text(""),
                      Center(
                      child: _zipf != null ? Text(
                      _zipf!.path.split('/').last,
                        style: const TextStyle(fontSize: 16),
                         ) : Text(zipname),
                        ),





                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF49AFD2),
                      ),
                      onPressed: () {
                          editpro(proid);
                      },
                      child: _requestdone? const Text(
                        "Edit Product",
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


          ],
      );
    }
  );

}


}

