/*
import 'package:flutter/widgets.dart';
import '../stateManager/valueStream.dart';

/// Creted by `Suebersson Montalvão` - 03/08/2020

/*
  TabView simples customizada cross plat form (Androis e IOS)
*/

enum PositionTabLabel {top, bottom}
//definir se as labels da tab serão fixas na largura da tela ou uma lisView na horizontal
enum TypeLabel {fixedLabel, listLabel}

@immutable
class TabViewLabel extends StatefulWidget {
  final PositionTabLabel positionTabLabel;
  final TypeLabel typeLabel;
  final double labelSize;
  final Color labelColor;
  final Color selectedColor;
  final Color backgroundColor;
  final double marginTabTop;
  final double marginTabBottom;
  final Map<String, Widget> listTabs;
  final double containerTabBorderRadius;
  final double itemBorderRadius;
  final int initialPage;
  final int transitionTime;

  const TabViewLabel({
    Key key,
    this.positionTabLabel = PositionTabLabel.top,
    this.typeLabel = TypeLabel.fixedLabel,
    this.labelSize = 12.0,
    this.labelColor = const Color(0xFFFFFFFF),
    this.selectedColor = const Color(0xFF00BCD4),
    this.backgroundColor = const Color(0xFFBA68C8),
    this.marginTabTop = 0.0,
    this.marginTabBottom = 0.0,
    @required this.listTabs,
    this.containerTabBorderRadius = 0.0,
    this.itemBorderRadius = 0.0,
    this.initialPage = 0,
    this.transitionTime = 300,
  }): assert(listTabs != null, 'Insira a lista de tabelas'),
      super(key: key);

  @override
  _TabViewLabelState createState() => _TabViewLabelState();
}

class _TabViewLabelState extends State<TabViewLabel> {

  PageController pageController;
  ValueStream<int>  selectedPage;
  List<Widget> components = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    selectedPage = ValueStream<int>(widget.initialPage);
    components.add(tabView());
    components.add(tabBody());
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.positionTabLabel == PositionTabLabel.top 
        ? components.map((_widget) => _widget).toList()
        : components.reversed.map((_widget) => _widget).toList(),
    );
  }

  Widget tabView(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: widget.marginTabTop, bottom: widget.marginTabBottom),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor, //colorAppBarTheme,
        borderRadius: BorderRadius.circular(widget.containerTabBorderRadius),
      ),
      child: widget.typeLabel == TypeLabel.fixedLabel
        ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.listTabs.length, (index) {
            return itemTabView(widget.listTabs.keys.elementAt(index), index);
          }),
        )
        : ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(widget.listTabs.length, (index) {
              return itemTabView(widget.listTabs.keys.elementAt(index), index);
            }),
          ),
    );
  }

  Widget tabBody(){
    return Flexible(
      child: PageView.builder(
        controller: pageController,
        physics: BouncingScrollPhysics(),
        onPageChanged: (index) {
          //print('onChanded: $index');
          selectedPage.value = index;
        },
        itemCount: widget.listTabs.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.listTabs.values.elementAt(index);
        },
      ),
    );
  }

  Widget itemTabView(String label, int item) {
    return GestureDetector(
      onTap: () => goToPage(item),
      child: StreamBuilder<int>(
        initialData: selectedPage.value,
        stream: selectedPage.stream,
        builder: (context, snapshot) {
          return Container(
            width: widget.typeLabel == TypeLabel.fixedLabel
              ? (MediaQuery.of(context).size.width / widget.listTabs.length) - 1.5
              : null,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: snapshot.data == item ? widget.selectedColor : Color(0x00000000),
              borderRadius: BorderRadius.circular(widget.itemBorderRadius),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: snapshot.data == item ? widget.labelColor : widget.labelColor.withOpacity(0.6),
                fontSize: widget.labelSize,
              ),
            ),
          );
        }
      ),
    );
  }

  void goToPage(int index) {
    //ir para uma pagina sem animação
    //pageController.jumpToPage(index);
    //com uma animação simples
    pageController.animateToPage(index, duration: Duration(milliseconds: widget.transitionTime), curve: Curves.easeInCirc);
  }
}
*/