import 'package:de/tab_view_item.dart';
import 'package:de/tab_view_item_refresh.dart';
// import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

/**
 * NestedScrollView + 下拉刷新 + 上拉加载
 * 使用  https://github.com/fluttercandies 下面的 extend_nested_scroll_view + load_more_list + pull_to_refresh_notification
 * 发现并解决的bug： 当中的Pinned为true的多个Sliver组件对body里面滚动组件的影响 ？https://juejin.im/post/5bea43ade51d45544844010a
 * 未复制到的bug：  1，NestedScrollView 列表滚动同步解决 https://juejin.im/post/5bea90c6e51d450319791b2e 2，  RefreshIndicator 在官方NestedScrollView没法使用 https://juejin.im/post/5beb91275188251d9e0c1d73
 */
void main() {
  runApp(new MaterialApp(
    home: new MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  TabController primaryTC;

  @override
  void initState() {
    primaryTC = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
    primaryTC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    var pinnedHeaderHeight = 300.0;
    return new NestedScrollView(
      // pinnedHeaderSliverHeightBuilder: () {
      //   return 100.0;
      // },
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            expandedHeight: 200.0,
            pinned: true,
            floating: false,
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Container(
                    child: Image.network(
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531798262708&di=53d278a8427f482c5b836fa0e057f4ea&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F342ac65c103853434cc02dda9f13b07eca80883a.jpg",
                  // "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3669273212,3031370855&fm=27&gp=0.jpg",
                  fit: BoxFit.fill,
                ))),
          ),
          /**
           * 针对问题一，设置的多个sliver组件
           */
          // SliverPersistentHeader(
          //     pinned: true,
          //     floating: false,
          //     delegate: _SliverPersistentHeaderDelegate(
          //         Container(
          //             color: Color.fromARGB(100, 100, 100, 100),
          //             height: 200.0,
          //             child: Center(
          //               child: Text("Pinned wiget"),
          //             )),
          //         200.0))
        ];
      },
      body: Column(
        children: <Widget>[
          TabBar(
            controller: primaryTC,
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.0,
            isScrollable: false,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Tab0"),
              Tab(text: "Tab1"),
              Tab(text: "Tab2"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: primaryTC,
              children: <Widget>[
                TabViewItem(),
                TabViewItemRefresh(),
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Text('-----------${index}---------------');
                  },
                  itemCount: 100,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget widget;
  _SliverPersistentHeaderDelegate(this.widget, this.height);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return widget;
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => height;

  // TODO: implement minExtent
  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
