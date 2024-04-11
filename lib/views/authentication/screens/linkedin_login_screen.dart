import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/client/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:uuid/uuid.dart';

class LinkedinLoginScreen extends StatefulWidget {
  const LinkedinLoginScreen({
    required this.onGetUserProfile,
    required this.redirectUrl,
    required this.clientId,
    required this.clientSecret,
    this.onError,
    this.destroySession = false,
    this.appBar,
    this.useVirtualDisplay = false,
    this.scope = const [
      OpenIdScope(),
      EmailScope(),
      ProfileScope(),
    ],
    super.key,
  });

  final ValueChanged<UserSucceededAction>? onGetUserProfile;
  final ValueChanged<UserFailedAction>? onError;
  final String? redirectUrl;
  final String? clientId;
  final String? clientSecret;
  final PreferredSizeWidget? appBar;
  final bool destroySession;
  final bool useVirtualDisplay;
  final List<Scope> scope;

  @override
  State<LinkedinLoginScreen> createState() => _LinkedinLoginScreenState();
}

class _LinkedinLoginScreenState extends State<LinkedinLoginScreen> {
  late Graph graph;

  @override
  void initState() {
    super.initState();

    graph = Initializer().initialise(
      AccessCodeConfiguration(
        clientSecretParam: widget.clientSecret,
        clientIdParam: widget.clientId,
        redirectUrlParam: widget.redirectUrl,
        urlState: const Uuid().v4(),
        scopeParam: widget.scope,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        Navigator.pop(context, false);
      },
      child: InjectorWidget(
        graph: graph,
        child: LinkedInWebViewHandler(
          appBar: widget.appBar,
          destroySession: widget.destroySession,
          useVirtualDisplay: widget.useVirtualDisplay,
          onUrlMatch: (final config) {
            print("onUrlMatch called with Config Url:${config.url}");

            ClientFetcher(
              graph: graph,
              url: config.url,
            ).fetchUser().then(
              (final action) {
                if (action is UserSucceededAction) {
                  widget.onGetUserProfile?.call(action);
                }

                if (action is UserFailedAction) {
                  widget.onError?.call(action);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
