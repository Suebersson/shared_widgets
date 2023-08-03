import 'package:flutter/material.dart';
import '../functions/get_text_width.dart';

/// Barra de navigação inferior com botões expansível para páginas/screen
@immutable
class BottomNavigatonBarExpandableScreen extends StatefulWidget {

  final TextStyle? labelStyle;
  final IconThemeData? iconThemeData;
  final Color? selectedButtonColor;
  final Color? splashColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final double? selectedButtonBorderRadius;
  final double backgroundHeight, backgroundWidth;
  final BoxDecoration? backgroundDecoration;
  final List<CreateButtomExpandable> listExpandableTag;
  final int initialPage;

  /// A animação na transição das páginas foi desativada porque a [ListView.builder]
  /// carrega as páginas intermediárias desnecessariamente
  /// 
  /// Ex: Se a página atual for a 0 e clicar para ir para página 4, significa que
  /// as páginas 2 e 3 serão carregadas desnecessariamente, e isso pode custar caro
  /// na árvove de widgets por criar instâncias antecipadas que não serão usadas
  /// 
  // final Duration animationTime;
  // final Curve animationCurve;

  const BottomNavigatonBarExpandableScreen({
    Key? key,
    required this.listExpandableTag,
    this.labelStyle,
    this.iconThemeData,
    this.selectedButtonColor,
    this.splashColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.selectedButtonBorderRadius,
    this.backgroundHeight = kBottomNavigationBarHeight,
    this.backgroundWidth = double.infinity,
    this.backgroundDecoration,
    this.initialPage = 0,
    // this.animationTime = const Duration(milliseconds: 300),
    // this.animationCurve = Curves.easeInCirc,
  }): assert(
        initialPage < listExpandableTag.length, 
        'O index da página $initialPage não existe'
      ),
      super(key: key);

  /// Lista de funções para exibir e ocultar a buttomBar
  static final List<Function> _buttomBarVisibilityList = [];

  /// inverter a visibilidade da barra de botões
  static void buttomBarVisibility(){
    if (_buttomBarVisibilityList.isNotEmpty) {
      _buttomBarVisibilityList.last.call();
    }
  }

  @override
  _BottomNavigatonBarExpandableScreenState createState() => _BottomNavigatonBarExpandableScreenState();

}

class _BottomNavigatonBarExpandableScreenState extends State<BottomNavigatonBarExpandableScreen> {

  late final PageController _pageController;
  late final ValueNotifier<int>  _currentPage;
  late final ValueNotifier<bool> _buttomBarVisibility;

  /// inverter a visibilidade da barra de botões
  void _invertVisibility(){
    _buttomBarVisibility.value = !_buttomBarVisibility.value;
  }

  @override
  void initState() {
    super.initState();
    _currentPage = ValueNotifier<int>(widget.initialPage);
    _buttomBarVisibility = ValueNotifier(true);
    _pageController = PageController(initialPage: widget.initialPage, keepPage: true);
    /*_pageController.addListener(() {
      print('ScrollPosition is: ${_pageController.page}');
    });*/
    BottomNavigatonBarExpandableScreen
      ._buttomBarVisibilityList
        .add(_invertVisibility);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    _buttomBarVisibility.dispose();
    BottomNavigatonBarExpandableScreen
      ._buttomBarVisibilityList
        .removeLast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    ThemeData theme = Theme.of(context);
    
    TextStyle textStyle = widget.labelStyle 
      ?? theme.bottomNavigationBarTheme.selectedLabelStyle
      ?? const TextStyle(fontSize: 14.0, color: Colors.white);

    IconThemeData iconThemeData = widget.iconThemeData 
      ?? theme.bottomNavigationBarTheme.selectedIconTheme 
      ?? theme.iconTheme;

    double partOfButtomWidth = (MediaQuery.sizeOf(context).width / widget.listExpandableTag.length) * 0.49;
    double iconButtomWidth;

    if(partOfButtomWidth <= 42){
      iconButtomWidth = (iconThemeData.size ?? 24) + 42;
    }else{
      iconButtomWidth = (iconThemeData.size ?? 24) + partOfButtomWidth;
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => _currentPage.value = index,
          // childrenDelegate: SliverChildBuilderDelegate(
          //   (context, index) {
          //     return widget.listExpandableTag[index].page;
          //   },
          //   childCount: widget.listExpandableTag.length,
          // ),
          itemCount: widget.listExpandableTag.length,
          itemBuilder: (context, index) {
            return widget.listExpandableTag[index].page;
          }
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _buttomBarVisibility,
          builder: (_, visible, __) {
            return Visibility(
              visible: visible,
              replacement: const SizedBox.shrink(),
              child: Container(
                height: widget.backgroundHeight,
                width: widget.backgroundWidth,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4.0),
                decoration: widget.backgroundDecoration ?? BoxDecoration(
                  color: theme.bottomNavigationBarTheme.backgroundColor,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(widget.listExpandableTag.length, (index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: widget.splashColor ?? theme.splashColor,
                          focusColor:  widget.focusColor ?? theme.focusColor,
                          hoverColor:  widget.hoverColor ?? theme.hoverColor,
                          highlightColor: widget.highlightColor ?? theme.highlightColor,
                          borderRadius: BorderRadius.circular(
                            widget.selectedButtonBorderRadius ?? widget.backgroundHeight),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentPage,
                            builder: (_, i, __) {
                              return AnimatedContainer(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 300), //widget.animationTime,
                                curve: Curves.fastOutSlowIn,
                                width: i == index 
                                  ? (iconThemeData.size ?? 24) + 44 + getTextWidth(
                                        widget.listExpandableTag[index].label,
                                        style: textStyle
                                      )
                                  : iconButtomWidth,
                                decoration: BoxDecoration(
                                  color: i  == index 
                                    ? widget.selectedButtonColor ?? Colors.transparent 
                                    : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    widget.selectedButtonBorderRadius ?? widget.backgroundHeight),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                                child: Visibility(
                                  visible: i == index ? true : false,
                                  replacement: Icon(
                                    widget.listExpandableTag[index].icon, 
                                    color: iconThemeData.color?.withOpacity(0.8), 
                                    size: iconThemeData.size,
                                  ),
                                  child: ListView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Icon(
                                        widget.listExpandableTag[index].icon, 
                                        color: iconThemeData.color,
                                        size: iconThemeData.size,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Text(
                                            widget.listExpandableTag[index].label, 
                                            style: textStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                          onTap: (){
                            if(_currentPage.value != index){
                              /// Transição sem animação e sem carregar páginas intermediárias
                              _pageController.jumpToPage(index);

                              /// Transição com animação, mais pode carregar alguma página intermediária
                              /// 
                              /// Ex: Se a página atual for a 0 e clicar para ir para página 4, significa que
                              /// as páginas 2 e 3 serão carregadas desnecessariamente
                              // _pageController.animateToPage(
                              //   index, 
                              //   duration: widget.animationTime, 
                              //   curve: widget.animationCurve
                              // );
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

/// Criar um botão expansível passando uma `IconData`, `text` e uma `Widget`
@immutable
class CreateButtomExpandable {
  
  final String label;
  final IconData icon;
  
  /// Para que page[Widget] não seja disposada automaticamente quando ir para
  /// outra página, é necessario que a [page] seja uma [StatefulWidget] e também 
  /// hede de [AutomaticKeepAliveClientMixin]
  /// 
  /// Ex: class _AnyPageState extends State<AnyPage> with AutomaticKeepAliveClientMixin {
  ///   
  ///   @override
  ///   Widget build(BuildContext context) {}
  /// 
  ///   // true => não disposar essa página
  ///   @override
  ///   bool get wantKeepAlive => true;
  /// 
  /// }
  /// 
  final Widget page;
  
  const CreateButtomExpandable({
    required this.label, 
    required this.icon, 
    required this.page
  });

}
