/*
import 'package:flutter/material.dart';
import '../stateManager/valueStream.dart';

/// TabView de Scaffold customizada semelhante ao widget `CupertinoTabScaffold`
/// como mais flexibilidade
class TabScaffold extends StatefulWidget {
  /// TabView para alternar entre páginas que oculpam a tela inteira
  final double labelSize;
  final Color labelColor;
  final double iconSize;
  final Color iconColor;
  final double backgroundHeight;
  final Color backgroundColor;
  final Color boxShadowColor;
  final double boxShadowBlurRadius;
  final List<ListTabs> listTabs;
  final int initialPage;
  final int transitionTime;
  final Curve transitionCurve;
  const TabScaffold({
    Key key,
    this.labelSize = 13.0,
    this.labelColor = Colors.white,
    this.iconSize = 25.0,
    this.iconColor = Colors.white,
    this.backgroundHeight,
    this.backgroundColor = Colors.cyan,
    this.boxShadowColor = Colors.black38,
    this.boxShadowBlurRadius = 4.0,
    @required this.listTabs,
    this.initialPage = 0,
    this.transitionTime = 300,
    this.transitionCurve = Curves.easeInCirc,
  }): assert(listTabs != null, 'Insira os parâmentros corretamente'),
      super(key: key);

  @override
  _TabScaffoldState createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {

  PageController pageController;
  ValueStream<int>  selectedPage;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    selectedPage = ValueStream<int>(widget.initialPage);
    /*pageController.addListener(() {
      print('ScrollPosition is: ${pageController.page}');//type is double
    });*/
  }

  @override
  void dispose() {
    pageController.dispose();
    selectedPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Flexible(
            child: PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),//bloquear a scroll
              onPageChanged: (index) {
                //print('onChanded: $index');
                selectedPage.value = index;
              },
              itemCount: widget.listTabs.length,
              itemBuilder: (BuildContext context, int index) => widget.listTabs[index].page,
            ),
          ),

          Container(
            height: widget.backgroundHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: [//elevation customizada sem o material
                BoxShadow(
                  color: widget.boxShadowColor,
                  blurRadius: widget.boxShadowBlurRadius,
                  //offset: const Offset(0.0, 0.0),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(widget.listTabs.length, (index) {
                if(widget.listTabs[index].key != null && widget.listTabs[index].iconData != null){//text + icon
                  return labelIconButton(widget.listTabs[index].key, widget.listTabs[index].iconData, index);
                }else if(widget.listTabs[index].key != null){//only text
                  return labelButton(widget.listTabs[index].key, index);
                }else if(widget.listTabs[index].iconData != null){//only icon
                  return iconButton(widget.listTabs[index].iconData, index);
                }else{
                  throw  'Insira um texto, um ícone ou os dois para criar os botões de navegação entre as páginas';
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget labelIconButton(String label, IconData icon, int item){
    return GestureDetector(
      child: StreamBuilder<int>(
        initialData: selectedPage.value,
        stream: selectedPage.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                color: snapshot.data == item ? widget.iconColor : widget.iconColor.withOpacity(0.6), 
                size: widget.iconSize,
              ),
              Text(
                widget.listTabs[item].key, 
                style: TextStyle(
                  color: snapshot.data == item ? widget.labelColor: widget.labelColor.withOpacity(0.6), 
                  fontSize: widget.labelSize
                ),
              ),
            ],
          );
        }
      ),
      onTap: (){
        goToPage(item);
      },
    );
  }

  Widget labelButton(String label, int item){
    return GestureDetector(
      child: StreamBuilder<int>(
        initialData: selectedPage.value,
        stream: selectedPage.stream,
        builder: (context, snapshot) {
          return Container(
            height: widget.labelSize + 18,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              widget.listTabs[item].key, 
              style: TextStyle(
                color: snapshot.data == item ? widget.labelColor: widget.labelColor.withOpacity(0.6), 
                fontSize: widget.labelSize
              ),
            ),
          );
        }
      ),
      onTap: (){
        goToPage(item);
      },
    );
  }

  Widget iconButton(IconData icon, int item){
    return GestureDetector(
      child: StreamBuilder<int>(
        initialData: selectedPage.value,
        stream: selectedPage.stream,
        builder: (context, snapshot) {
          return Icon(
            icon, 
            color: snapshot.data == item ? widget.iconColor : widget.iconColor.withOpacity(0.6), 
            size: widget.iconSize,
          );
        }
      ),
      onTap: (){
        goToPage(item);
      },
    );
  }

  void goToPage(int index) {
    //ir para uma pagina sem animação
    //pageController.jumpToPage(index);
    //com uma animação simples
    pageController.animateToPage(
      index, 
      duration: Duration(milliseconds: widget.transitionTime), 
      curve: widget.transitionCurve
    );
  }

}

@immutable
class ListTabs {
  final String key;
  final IconData iconData;
  final Widget page;
  const ListTabs({this.key, this.iconData, @required this.page}): 
    assert(page != null, 'O parâmetros "page" é obrigatório');
}


/// Exemplo
///```
///	@override
///	Widget build(BuildContext context) {
///		return TabScaffold(
///      backgroundColor: ThemeValues.appBarColor,
///      iconColor: ThemeValues.iconColor,
///      iconSize: 35.0,
///      labelColor: Colors.white,
///      listTabs: [
///       /*ListTabs(key: 'Eventos', iconData: FlutterIcons.list_ent, page: Page1()),
///        ListTabs(key: 'Calêndario', iconData: FlutterIcons.calendar_oct, page: Page2()),
///        ListTabs(key: 'Comunicados', iconData: Icons.dashboard, page: Page3()),
///        ListTabs(key: 'Menu', iconData: Icons.menu, page: Page4()),*/
///
///        ListTabs(iconData: FlutterIcons.list_ent, page: Page1()),
///        ListTabs(iconData: FlutterIcons.calendar_oct, page: Page2()),
///        ListTabs(iconData: Icons.dashboard, page: Page3()),
///        ListTabs(iconData: Icons.menu, page: Page4()),
///
///        /*ListTabs(key: 'Eventos', page: Page1()),
///        ListTabs(key: 'Calêndario', page: Page2()),
///        ListTabs(key: 'Comunicados', page: Page3()),
///        ListTabs(key: 'Menu', page: Page4()),*/
///
///      ],
///    );
///	}
///```
*/