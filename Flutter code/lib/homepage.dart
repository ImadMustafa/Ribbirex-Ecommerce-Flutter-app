
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'productinfopage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
List listProducts = [];
List<String> categories = [];

bool hoverover = false;
bool _requestdone = true;
bool trad = false;
bool nores = false;
bool searching = false;
bool resfilter = false;
bool searfilter = false;

String? _selectedCategory;

final _keform = GlobalKey<FormState>();
final _minprice = TextEditingController();
final _keminprice = GlobalKey<FormState>();
final _maxprice = TextEditingController();
final _searchin = TextEditingController();
// ignore: unused_field
final GlobalKey<RefreshIndicatorState> _refkey = GlobalKey<RefreshIndicatorState>();




  String limitwords(String txt){
    if(txt.length > 16){
      return "${txt.substring(0, 13)}...";
    }else{
      return txt;
    }
  }



  @override
  void initState() {
    super.initState();
    _updateCategory();
    getallproducts();
    setState(() {
      _minprice.text = (1).toString();
      _maxprice.text = (9999).toString();
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


//method to filter start
  Future<void> filtersear() async {

    final cate = _selectedCategory;
    final minp = _minprice.text;
    final maxp = _maxprice.text;
    final tradb = trad;

      //we map the data
      final useinfo = {
        'cat':cate,
        'minp':minp,
        'maxp':maxp,
        'trad':tradb
        };


      //we convert the data into a json
      final injs = jsonEncode(useinfo);

      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/searchfilter.php'),
      body: injs,
    );
    //if username and password match
    if (response.statusCode == 200) {
      final projs = response.body;
      final prol = jsonDecode(projs);
      setState(() {
        listProducts = prol;
      });
      if(listProducts.isEmpty){
        setState(() {
          nores = true;
        });
      }
      else{
        setState(() {
          nores = false;
        });
      }

  }
  setState(() {
    searfilter = false;
  });

  }

//method to filter end

  bool checkfilter()  {
  if(_selectedCategory == null && _minprice.text == "1" && _maxprice.text == "9999" && trad == false){
    return true;
  }
  else{
    return false;
  }

}

//search method
Future<void> searchinp() async {

  final sin = _searchin.text;

      final useinfo = {
        'searin':sin
        };


      //we convert the data into a json
      final injs = jsonEncode(useinfo);


      //we send the json to our php to check the username and password
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/searchin.php'),
      body: injs,
    );
    //if username and password match
    if (response.statusCode == 200) {

      final projs = response.body;
      final prol = jsonDecode(projs);
      setState(() {
        listProducts = prol;
      });
      if(listProducts.isEmpty){
        setState(() {
          nores = true;
        });
      }
      else{
        setState(() {
          nores = false;
        });
      }

    }


}



//method to get all product
  Future<void> getallproducts() async {
      setState(() {
        _requestdone = false;

      });


     //we get all the products info
      final response = await http.post(
      Uri.parse('https://navajowhite-worm-558163.hostingersite.com/allproductinfo.php'),

    );

    if(response.statusCode == 200){
      final projs = response.body;
      final prol = jsonDecode(projs);
      setState(() {
        listProducts = prol;
      });
      if(listProducts.isEmpty){
        setState(() {
          nores = true;
        });
      }
      else{
        setState(() {
          nores = false;
        });
      }

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
        resfilter = false;
      });

  }

  //get all product end




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEDC2),
      body: Stack(
        children: [
          RefreshIndicator(

            onRefresh: getallproducts,
            child: CustomScrollView(

              slivers: [
                SliverAppBar(
                  title: TextFormField(

                    controller: _searchin,
                    decoration:  InputDecoration(
                      suffixIcon: searching? IconButton(onPressed: (){
                        _searchin.clear();
                        if(checkfilter()){
                        getallproducts();
                        }
                        else{
                          filtersear();
                        }
                        setState(() {
                          searching = false;
                        });
                      }, icon: const Icon(Icons.clear)):null,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator:(value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                      }
                        const pattern = (r'^[a-zA-Z]+$');
                        final regExp = RegExp(pattern);
                        if(!regExp.hasMatch(value)){
                          return 'Only letters';
                        }
                          return null;
                    },
                    onChanged: (value) {
                      searchinp();
                      if(value != ""){
                        setState(() {
                          searching = true;
                        });
                      }
                      else{
                        setState(() {
                          searching = false;
                        });
                      }
                    },

                  ),
                  actions: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: IconButton(onPressed: (){
                    showDialog(context: context, builder: (BuildContext context) {
                       return SingleChildScrollView(
                         child: AlertDialog(
                           backgroundColor: Color(0xFFFCEDC2),
                    actionsAlignment: MainAxisAlignment.start,
                    title:  const Text("Filter"),

                    actions: [
                      TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    filterfor()

                        ],
                        ),
                                   );
                      });
                      },
                      icon: const Icon(Icons.filter)),
                  ),
                    SizedBox(width: 10,),

                ],

                  backgroundColor: const Color(0xFFFCEDC2),
                  floating: true,
                  snap: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    delegate: !nores? SliverChildBuilderDelegate(
                        childCount: listProducts.length,
                          (BuildContext context, int index) {

                            return InkWell(
                              splashColor: const Color.fromARGB(255, 248, 3, 3),

                              onTap: (){
                                List productinf = [listProducts[index]['pid'],
                                listProducts[index]['pname'],
                                listProducts[index]['crname'],
                                listProducts[index]['pdesc'],
                                listProducts[index]['pprice'],
                                listProducts[index]['pimgs'],
                                listProducts[index]['trad'],
                                listProducts[index]['creatorid']];
                                Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductInfo(product: productinf),
                            ),
                          );

                              },

                                child:Container(
                                  color: const Color(0xFFC2D1D9),
                                  height: 100,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                    color: const Color(0xFFF2F5F7),
                                    height: 90,
                                    width: 90,
                                      child: Column(
                                        children: [

                                           CachedNetworkImage(
                                            imageUrl: listProducts[index]['pimgs'],
                                            width: double.infinity,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                           errorWidget: (context, url, error) => const Icon(Icons.error),),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(limitwords(listProducts[index]['pname']), style: const TextStyle(color:Color(0xFF435964), fontWeight: FontWeight.bold, fontSize: 16),),
                                                Text('${listProducts[index]['crname']}',style: const TextStyle(fontSize: 11, decoration: TextDecoration.underline),),
                                                Row(
                                                  children: [
                                                    Container(width: 68 ,child: Text('US\$${listProducts[index]['pprice']}', style: const TextStyle(fontSize: 14 ,fontWeight: FontWeight.bold,color:Color(0xFF435964,)))),
                                                    Column(

                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Type: ${listProducts[index]['catname']}',style: const TextStyle(fontSize: 10),),
                                                        Text(listProducts[index]['trad'] == '1' ? "Tradeable" : "Not Tradeable", style: TextStyle(fontSize: 12),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ),
                                ),

                            );

                      },

                    ):SliverChildBuilderDelegate((context, index) => const Center(child: Text("No Result!")))
                  ),
                ),
              ],
            ),
          ),
            if (!_requestdone)
            Container(

              child: const Center(
                child: CircularProgressIndicator(),
              )
            )

        ],
      )
    );
  }








/////////////////////
////////////////////
Widget filterfor(){
  return StatefulBuilder(
    builder: (context,setState){
    return Stack(
      children: [
                 Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category"),
                    DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Category"),
                    value: _selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value;

                      });
                    },
                    items: [
                       const DropdownMenuItem<String>(
                       value: null,
                        child: Text('None'),
                        ),
                      ...categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }),
                    ]
                  ),
                  const SizedBox(height: 20,),


                  SizedBox(
                    width: 180,

                      child: Form(
                        key: _keform,
                        child: Column(
                          children: [
                      Row(
                        children: [
                         Expanded(
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                 const Text("Min Price"),
                                  Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _minprice,
                                    key: _keminprice,
                                      inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        ],

                                    validator: (value) {

                                      final num = int.tryParse(value!);
                                      if (num == null) {
                                        Future.delayed(const Duration(seconds: 3), () {
                                          if (_minprice.text == "") {
                                            setState(() {
                                              _minprice.text = '1';
                                            });
                                          }
                                        });
                                        return null;
                                      }

                                      if (num < 0 || num > 9999) {
                                        return 'Invalid number';
                                      }
                                      else {
                                        return null;
                                      }

                                    },
                                    onChanged: (value) {

                                       _keform.currentState!.validate();

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                            const SizedBox(width: 30),
                            Expanded(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Max Price"),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: _maxprice,
                                      inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        ],
                                      validator: (value) {

                                          final num = int.tryParse(value!);
                                        const pattern = (r'^[0-9]+$');
                                        final regExp = RegExp(pattern);
                                        if (num == null) {
                                          Future.delayed(const Duration(seconds: 3), () {
                                            if (_maxprice.text == "") {
                                              setState(() {
                                                _maxprice.text = '9999';
                                              });
                                            }
                                          });
                                          return null;
                                        }
                                        if (!regExp.hasMatch(value)) {
                                          return 'Invalid number';
                                        }
                                        if (num < 0 || num > 9999) {
                                          return 'Invalid number';
                                        } else {
                                          return null;
                                        }

                                      },
                                      onChanged: (value) {
                                        _keform.currentState!.validate();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                          ],
                        ),


                      ),
                    ),
                  SizedBox(height: 20,),
                  Row(children: [
                    const Text("Tradeable"),
                    const SizedBox(width: 10,),
                    Checkbox(value: trad, onChanged:(value) {
                      setState(() {
                          trad = !trad;

                      },);

                    },)
                  ],),
                  const SizedBox(height: 50,),


                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF49AFD2),
                          ),
                          onPressed: !searfilter? () {
                            setState(() {
                              searfilter = true;
                            });
                              filtersear().then((value) =>
                             Navigator.of(context).pop()
                              );
                          }:() {
                            null;
                          },
                          child: _requestdone? const Text(
                            "Search",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ):const SizedBox(width: 23,height: 23,
                          child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(width: 30,),
                        InkWell(
                          onTap: !resfilter?() {
                            setState(() {
                              resfilter = true;
                            });
                            _selectedCategory = null;
                            _minprice.text = '1';
                            _maxprice.text = '9999';
                            trad = false;
                            getallproducts().then((value) => Navigator.of(context).pop());

                          }:(){
                            null;
                          },
                          child: const Text("Reset Filter", style: TextStyle(decoration: TextDecoration.underline ,fontWeight: FontWeight.bold, color: Color(0xFF3396B9)),)

                        )

                      ],
                    ),

                  ],

                ),





                  ]
                    );

                   }

                 );

}



}
