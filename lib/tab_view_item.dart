import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class LoadMoreListSource extends LoadingMoreBase<int> {
  //外部传入 state参数实际上是api请求的参数，可以动态修改api请求的参数
  LoadMoreListSource(this.state);
  final state;
  int pageIndex = 1;
  bool hasMore = true;
  int count = 100;
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) {
    print(this.state);
    return Future.delayed(Duration(seconds: 1), () {
      if (pageIndex == 1) {
        this.clear();
      }
      for (var i = 0; i < 10; i++) {
        this.add(0);
      }
      hasMore = count > this.length;
      pageIndex++;

      return true;
    });
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    // TODO: implement refresh
    pageIndex = 1;
    return loadMore();
  }
}

class TabViewItem extends StatefulWidget {
  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem> {
  LoadMoreListSource source;
  int state = 1;
  @override
  void initState() {
    super.initState();
    source = LoadMoreListSource(this.state);
    // sc.addListener(_loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    source.dispose();
  }

   Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
     //print(info?.mode);
     //print(info?.dragOffset);
 //    print("------------");
     var offset = info?.dragOffset ?? 0.0;
     var mode = info?.mode;
     Widget refreshWiget = Container();
     //it should more than 18, so that RefreshProgressIndicator can be shown fully
     // 左侧loading
    //  if (info?.refreshWiget != null &&
    //      offset > 18.0 &&
    //      mode != RefreshIndicatorMode.error) {
    //    refreshWiget = info.refreshWiget;
    //  }
 
     Widget child = null;
     if (mode == RefreshIndicatorMode.error) {
       child = GestureDetector(
           onTap: () {
             // refreshNotification;
             info?.pullToRefreshNotificationState?.show();
           },
           child: Container(
             color: Colors.grey,
             alignment: Alignment.bottomCenter,
             height: offset,
             width: double.infinity,
             //padding: EdgeInsets.only(top: offset),
             child: Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() + "  click to retry" ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             ),
           ));
     } else {
       child = Container(
        //  color: Colors.grey,
         alignment: Alignment.bottomCenter,
         height: offset,
         width: double.infinity,
         //padding: EdgeInsets.only(top: offset),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             refreshWiget,
             Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             )
           ],
         ),
       );
     }
 
     return child;
   }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        // FlatButton(
        //   child: Text('anniu'),
        //   onPressed: () {
        //     this.state = 3;
        //     setState(() {});
        //     source = LoadMoreListSource(this.state);
        //     // source.loadData();
        //   },
        // ),
        Expanded(
          child: PullToRefreshNotification(
              color: Colors.blue,
              maxDragOffset: 80.0,
              child: Column(children: [
                PullToRefreshContainer(buildPulltoRefreshHeader),
                Expanded(
                  child: LoadingMoreList(ListConfig(
                    itemBuilder: (context, item, index) {
                      return Text('-----------$index---------------');
                    },
                    sourceList: source,
                    lastChildLayoutType: LastChildLayoutType.none
                    // indicatorBuilder: (context, indocatorStatus) {
                    //   print(source);
                    //   print(indocatorStatus);
                    //   if (indocatorStatus == IndicatorStatus.noMoreLoad) {
                    //     return Text('加载完了');
                    //   } else {
                    //     return Container(
                    //       color: Colors.grey,
                    //       child: Text('加载更多')
                    //     );
                    //   }
                    // },
                  )),
                )
              ]),
              onRefresh: source.refresh),
        )
      ]),
      // child: ListView.builder(
      //   // controller: sc,
      //   physics: AlwaysScrollableScrollPhysics(),
      //   itemBuilder: (context, i) {
      //     if ( i == count) {
      //       return Container(
      //         height: 40.0,
      //         child: Text('-------上拉加载-------'),
      //       );
      //     } else {
      //       return Container(
      //         height: 40.0,
      //         child: Text('-------a${i}--------'),
      //       );
      //     }

      //   },
      //   itemCount: count + 1,
      // ),
    );
  }
}
