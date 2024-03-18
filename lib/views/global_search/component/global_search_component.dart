import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_provider.dart';
import 'package:flutter_instancy_2/models/global_search/response_model/global_search_component_response_model.dart';

class GlobalSearchComponent extends StatefulWidget {
  final GlobalSearchProvider globalSearchProvider;
  final String componentName;
  final int componentId;

  const GlobalSearchComponent({super.key, required this.globalSearchProvider, required this.componentName, required this.componentId});

  @override
  State<GlobalSearchComponent> createState() => _GlobalSearchComponentState();
}

class _GlobalSearchComponentState extends State<GlobalSearchComponent> with MySafeState {
  bool isAllChecked = true;
  late GlobalSearchProvider globalSearchProvider;
  Map<String, List<SearchComponents>> list = {};
  bool isCurrentCheckedBoxSelected = true;

  List<SearchComponents> _setValueCheckValueToTrue(List<SearchComponents> list, bool value) {
    return list.map((e) {
      e.check = value;
      return SearchComponents.fromJson(e.toJson());
    }).toList();
  }

  void changeTheValueOfAllCheckBox(bool changedValue) {
    Map<String, List<SearchComponents>> tempList = {};
    list.forEach((key, value) {
      tempList[key] = _setValueCheckValueToTrue(value, changedValue);
    });
    list.addAll(tempList);
    globalSearchProvider.globalSearchComponent.setMap(map: list, isNotify: false);
  }

  void changeOnlyTheComponentId({required int componentId, required bool changedValue}) {
    Map<String, List<SearchComponents>> tempList = list;
    tempList.forEach((key, value2) {
      for (var element in value2) {
        if (element.componentID == componentId) {
          element.check = changedValue;
        }
      }
      list.update(key, (value) => value2);
    });
  }

  void updateTheValueOfMap({required String key, required List<SearchComponents> mapValue}) {
    globalSearchProvider.updateSearchComponentMap(key: key, list: mapValue);
  }

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole("isInitCalled");
    globalSearchProvider = widget.globalSearchProvider;
    list = globalSearchProvider.globalSearchComponent.getMap();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(body: getGlobalSearchComponent(list: list));
  }

  Widget getCurrentScreenWidget() {
    return CheckboxListTile(
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      value: isCurrentCheckedBoxSelected,
      onChanged: (bool? val) {
        isCurrentCheckedBoxSelected = val ?? false;
        changeOnlyTheComponentId(componentId: widget.componentId, changedValue: isCurrentCheckedBoxSelected);
        mySetState();
      },
      title: Text(
        widget.componentName,
      ),
    );
  }

  Widget getGlobalSearchComponent({required Map<String, List<SearchComponents>> list}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CheckboxListTile(
            value: globalSearchProvider.isAllChecked.get(),
            onChanged: (bool? val) {
              isAllChecked = val ?? false;
              globalSearchProvider.isAllChecked.set(value: isAllChecked);
              changeTheValueOfAllCheckBox(isAllChecked);
              mySetState();
            },
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text("All"),
          ),
          getCurrentScreenWidget(),
          Column(
            children: list.entries
                .map(
                  (e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.key,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: e.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          SearchComponents model = e.value[index];
                          return CheckboxListTile(
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            value: model.check,
                            onChanged: (bool? val) {
                              model.check = val ?? false;
                              updateTheValueOfMap(key: e.key, mapValue: e.value);
                              mySetState();
                            },
                            title: Text(model.name),
                          );
                        },
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
