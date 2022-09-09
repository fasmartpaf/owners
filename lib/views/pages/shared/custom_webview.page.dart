import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomWebviewPage extends StatefulWidget {
  const CustomWebviewPage({
    Key key,
    this.selectedUrl,
  }) : super(key: key);

  final String selectedUrl;

  @override
  State<CustomWebviewPage> createState() => _CustomWebviewPageState();
}

class _CustomWebviewPageState extends State<CustomWebviewPage> {
  //
  bool pageLoaded = false;
  WebViewController webViewController;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      isLoading: !pageLoaded,
      showLeadingAction: true,
      leadingIconData: Icons.close,
      actions: [
        //go back
        IconButton(
          onPressed: () async {
            if (webViewController != null &&
                (await webViewController.canGoBack())) {
              webViewController.goBack();
            }
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        //go forward
        IconButton(
          onPressed: () async {
            if (webViewController != null &&
                (await webViewController.canGoForward())) {
              webViewController.goForward();
            }
          },
          icon: Icon(
            Icons.arrow_forward,
          ),
        ),
      ],
      body: Column(
        children: [
          WebView(
            initialUrl: widget.selectedUrl,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            debuggingEnabled: true,
            onWebViewCreated: (WebViewController mController) {
              setState(() {
                webViewController = mController;
              });
            },
            onPageFinished: (url) {
              setState(
                () {
                  pageLoaded = true;
                },
              );
            },
            onPageStarted: (url) {
              setState(
                () {
                  pageLoaded = false;
                },
              );
            },
          ).pOnly(bottom: context.mq.viewInsets.bottom).expand(),
        ],
      ),
    );
  }
}
