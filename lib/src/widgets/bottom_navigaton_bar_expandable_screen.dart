import 'package:flutter/material.dart';
import '../functions/get_text_width.dart';

/// Barra de navigação inferior com botões expansível para páginas/screen
@immutable
class BottomNavigatonBarExpandableScreen extends StatefulWidget {

  final TextStyle? labelStyle;
  final IconThemeData? iconThemeData;
  final Color selectedButtonColor;
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
    this.selectedButtonColor = Colors.black26,
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
  late final ThemeData _theme;
  late final TextStyle _textStyle;
  late final IconThemeData _iconThemeData;

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
    
    _theme = Theme.of(context);
    
    _textStyle = widget.labelStyle 
      ?? _theme.textTheme.button 
      ?? const TextStyle(fontSize: 14.0, color: Colors.white);

    _iconThemeData = widget.iconThemeData ?? _theme.iconTheme;

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
                  color: _theme.primaryColor,
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
                          splashColor: _theme.splashColor,
                          focusColor: _theme.focusColor,
                          hoverColor: _theme.hoverColor,
                          highlightColor: _theme.highlightColor,
                          borderRadius: BorderRadius.circular(
                            widget.selectedButtonBorderRadius ?? widget.backgroundHeight),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentPage,
                            builder: (_, _index, __) {
                              return AnimatedContainer(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 300), //widget.animationTime,
                                curve: Curves.fastOutSlowIn,
                                width: _index == index 
                                  ? (_iconThemeData.size ?? 24) + 18 + getTextWidth(
                                        widget.listExpandableTag[index].label,
                                        style: _textStyle
                                      )
                                  : (_iconThemeData.size ?? 24) + 30,
                                decoration: BoxDecoration(
                                  color: _index  == index 
                                    ? widget.selectedButtonColor 
                                    : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    widget.selectedButtonBorderRadius ?? widget.backgroundHeight),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                                child: Visibility(
                                  visible: _index == index ? true : false,
                                  replacement: Icon(
                                    widget.listExpandableTag[index].icon, 
                                    color: _iconThemeData.color?.withOpacity(0.8), 
                                    size: _iconThemeData.size,
                                  ),
                                  child: ListView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Icon(
                                        widget.listExpandableTag[index].icon, 
                                        color: _iconThemeData.color,
                                        size: _iconThemeData.size,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Text(
                                            widget.listExpandableTag[index].label, 
                                            style: _textStyle,
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
