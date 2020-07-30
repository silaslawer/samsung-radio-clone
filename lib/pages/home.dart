import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:samsung_radio/ruler.dart';
import 'package:samsung_radio/util/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (150 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _rulerPickerController = RulerPickerController(value: 97.3);
    _textEditingController = TextEditingController(text: '97.3');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  RulerPickerController _rulerPickerController;
  ScrollController _scrollControl = ScrollController();
  TextEditingController _textEditingController;
  num showValue = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [SliverAppBar(
          expandedHeight: 300.0,
          elevation: 0,
          pinned: true,
          snap: true,
          floating: true,
          bottom: AppBar(
            elevation: 0,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    isShrink ? "Radio" : "",
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6,
                  ),
                ),
                Text(
                  'Scan',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline6,
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(icon: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                CircleAvatar(radius: 2,backgroundColor: theme.textTheme.headline6.color,),
                SizedBox(height: 2,),
                CircleAvatar(radius: 2,backgroundColor: theme.textTheme.headline6.color,),
                SizedBox(height: 2,),
                CircleAvatar(radius: 2,backgroundColor: theme.textTheme.headline6.color,),
              ],), onPressed: null)
            ],
          ),
          ////////////////////////////////////
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(bottom: 8.0),
            centerTitle: true,
            title: Text(
              "Radio",
              style: TextStyle(color: Colors.red),
            ),
            collapseMode: CollapseMode.parallax,
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text(
                      'Now playing',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline3.copyWith(fontWeight: FontWeight.w300),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 16.0),
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text(
                      '97.3 MHz',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline3.copyWith(fontWeight: FontWeight.w300),
                    )),
              ],
            ),
          ),
        )];
      }, body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                  child: Row(children: <Widget>[
                    Stack(alignment: Alignment.center,
                      children: <Widget>[
                        CircleAvatar(backgroundColor: UIColors.grey3,),
                        CircleAvatar(child: Center(child: IconButton(icon: Icon(Icons.power_settings_new,color: UIColors.blue,), onPressed: null,)),radius: 19.5,backgroundColor: UIColors.white,),
                      ],
                    ),

                    SizedBox(width: 20,),
                    Stack(alignment: Alignment.center,
                      children: <Widget>[
                        CircleAvatar(backgroundColor: UIColors.grey3,),
                        CircleAvatar(child: Center(child: IconButton(icon: Icon(Icons.fiber_manual_record,color: UIColors.red,), onPressed: null,)),radius: 19.5,backgroundColor: UIColors.white,),
                      ],
                    ),
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                  child: Row(children: <Widget>[
                    IconButton(icon: Icon(Icons.chevron_left, color: theme.textTheme.headline6.color), iconSize: 45,onPressed: null),
                    Expanded(
                        child: Stack(alignment: Alignment.center,children: <Widget>[
                          Text.rich(
                            TextSpan(
                              text: '97.3',style: theme.textTheme.headline2,
                              children: <TextSpan>[
                                TextSpan(text: ' MHz', style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w300),),
                              ],
                            ),
                          ),
                          Positioned(top: -5,right: 45,child: IconButton(icon: Icon(Icons.star_border, color: theme.textTheme.headline6.color), onPressed: null))
                        ],)
                    ),
                    IconButton(icon: Icon(Icons.chevron_right, color: theme.textTheme.headline6.color), iconSize: 45, onPressed: null),

                  ],),
                ),
                RulerPicker(
                  controller: _rulerPickerController,
                  fractionDigits: 1,
                  backgroundColor: Colors.transparent,
                  onValueChange: (value) {
                    setState(() {
                      _textEditingController.text = value.toString();
                    });
                  },
                  width: MediaQuery.of(context).size.width,
                  height: 95,
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Card(
            child: Container(
              height:  MediaQuery.of(context).size.height/2,
              child: ListView.separated(itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ListTile(
                    title: Text("$index",style: theme.textTheme.headline5,),
                    onTap: null,
                    trailing: IconButton(onPressed: null,icon: Icon(Icons.star_border,color: theme.textTheme.headline6.color),),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) { return Divider(endIndent: 20,indent: 20,); }, itemCount: 20,),
            ),
          ),
        ],),
      ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(height: 50,child: Row(children: <Widget>[
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
            Container(child: Center(child: Text("Favorites",style: TextStyle(color: UIColors.grey3),)),),
           // const MySeparator(color: UIColors.blue),
          ],)),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
            Container(child: Center(child: Text("Stations",style: TextStyle(color: UIColors.blue,fontWeight: FontWeight.w600),)),),
            const MySeparator(color: UIColors.blue),
          ],)),
        ],),),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 1.5;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(20, (_) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
