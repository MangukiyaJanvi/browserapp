import 'package:browserapp/screens/homescreen/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? homeProviderTrue;
  HomeProvider? homeProviderFalse;
  TextEditingController txtsearch=TextEditingController();
  PullToRefreshController? pullToRefreshController;
  @override
  void initState() {
    super.initState();
    pullToRefreshController =PullToRefreshController(onRefresh: () {
      homeProviderTrue!.inAppWebViewController!.reload();
    },);
  }
  @override
  Widget build(BuildContext context) {
    homeProviderTrue=Provider.of<HomeProvider>(context,listen: true);
    homeProviderFalse=Provider.of<HomeProvider>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: () {
                  homeProviderTrue!.inAppWebViewController!.goBack();
                }, icon: Icon(Icons.arrow_back)),
                IconButton(onPressed: () {
                  homeProviderTrue!.inAppWebViewController!.reload();
                }, icon: Icon(Icons.refresh)),
                IconButton(onPressed: () {
                  homeProviderTrue!.inAppWebViewController!.goForward();
                }, icon: Icon(Icons.arrow_forward)),
                Container(
                  width: 196,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12,blurRadius: 2),
                    ]
                  ),
                  child: TextField(
                    controller: txtsearch,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: IconButton(onPressed: () {
                        var link=txtsearch.text;
                        homeProviderTrue!.inAppWebViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://www.google.com/search?q=$link")));
                        },icon: Icon(Icons.search)),
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(value: homeProviderTrue!.progressweb),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse('https://www.google.com/'),
                ),
                pullToRefreshController: pullToRefreshController!,
                onProgressChanged: (controller, progress) {
                  pullToRefreshController!.endRefreshing();
                  homeProviderFalse!.changeProgress(progress/100);
                },
                onLoadStart: (controller, url) {
                  pullToRefreshController!.endRefreshing();
                  homeProviderFalse!.inAppWebViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController!.endRefreshing();
                  homeProviderFalse!.inAppWebViewController = controller;

                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController!.endRefreshing();
                  homeProviderFalse!.inAppWebViewController = controller;

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
