import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teentalktalk/data/env/env.dart';
import 'package:teentalktalk/domain/blocs/auth/auth_bloc.dart';
import 'package:teentalktalk/domain/blocs/user/user_bloc.dart';
import 'package:teentalktalk/domain/models/response/response_policy.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/domain/services/policy_services.dart';
import 'package:teentalktalk/ui/helpers/helpers.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_checkLogin.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_getFig.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_scrap.dart';
import 'package:teentalktalk/ui/screens/policy/policy_detail_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_search_filter_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';
import 'package:teentalktalk/domain/blocs/policy/policy_bloc.dart';

class SelectedCodes {
  late List<CodeDetailData>? policyInstitution;
  late List<CodeDetailData>? policyTarget;
  late List<CodeDetailData>? policyField;
  late List<CodeDetailData>? policyCharacter;
  // late List<CodeDetailData>? policyArea;

  SelectedCodes({
    this.policyInstitution,
    this.policyTarget,
    this.policyField,
    this.policyCharacter,
    // this.policyArea
  });

  void remove(String codeDetail) {
    if (policyInstitution != null) {
      policyInstitution!
          .removeWhere((detail) => detail.detailName == codeDetail);
    }
    if (policyTarget != null) {
      policyTarget!.removeWhere((detail) => detail.detailName == codeDetail);
    }
    if (policyField != null) {
      policyField!.removeWhere((detail) => detail.detailName == codeDetail);
    }
    if (policyCharacter != null) {
      policyCharacter!.removeWhere((detail) => detail.detailName == codeDetail);
    }
  }

  bool get isEmpty {
    return (policyInstitution == null || policyInstitution!.isEmpty) &&
        (policyTarget == null || policyTarget!.isEmpty) &&
        (policyField == null || policyField!.isEmpty) &&
        (policyCharacter == null || policyCharacter!.isEmpty);
  }

  Map<String, List<CodeDetailData>?> toMap() => {
        'policyInstitution': policyInstitution,
        'policyTarget': policyTarget,
        'policyField': policyField,
        'policyCharacter': policyCharacter,
        // 'policyArea': policyArea,
      };
  @override
  String toString() {
    return 'SelectedCodes: {policyInstitution: $policyInstitution, policyTarget: $policyTarget, policyField: $policyField, policyCharacter: $policyCharacter}';
  }
}

// ignore: must_be_immutable
class PolicyListPage extends StatefulWidget {
  PolicyListPage({
    Key? key,
    required this.selectedCodes,
    this.selectedSortOrder,
    this.policyId,
  }) : super(key: key);

  final SelectedCodes selectedCodes;
  late policySortOrder? selectedSortOrder;
  final String? policyId;

  @override
  State<PolicyListPage> createState() => _PolicyListPageState();
}

class _PolicyListPageState extends State<PolicyListPage> {
  late String? policyId;
  late String selectedSortOrderCode = '0';
  late Policy sharedPolicy;
  bool _isSelectingCategory = false;
  late int policyCount = 0; // 검색 결과 수

  void _removeCodeDetail(String codeDetail) {
    setState(() {
      // 검색 조건 제거
      widget.selectedCodes.remove(codeDetail);

      if (widget.selectedCodes.isEmpty) {
        _isSelectingCategory = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    policyId = widget.policyId;

    // 정책 공유 링크를 통해 들어온 경우 해당 정책 정보 불러오기
    if (policyId != null) {
      getSharedPolicy(policyId!);
    }

    // 홈페이지 카테고리 선택 또는 검색 상세 조건 선택
    if ((widget.selectedCodes.policyField != null &&
            widget.selectedCodes.policyField!.isNotEmpty &&
            widget.selectedCodes.policyField![0].code != '' &&
            widget.selectedCodes.policyField![0].detailName != '') ||
        (widget.selectedCodes.policyInstitution != null &&
            widget.selectedCodes.policyInstitution!.isNotEmpty &&
            widget.selectedCodes.policyInstitution![0].code != '' &&
            widget.selectedCodes.policyInstitution![0].detailName != '') ||
        (widget.selectedCodes.policyTarget != null &&
            widget.selectedCodes.policyTarget!.isNotEmpty &&
            widget.selectedCodes.policyTarget![0].code != '' &&
            widget.selectedCodes.policyTarget![0].detailName != '') ||
        (widget.selectedCodes.policyCharacter != null &&
            widget.selectedCodes.policyCharacter!.isNotEmpty &&
            widget.selectedCodes.policyCharacter![0].code != '' &&
            widget.selectedCodes.policyCharacter![0].detailName != '')) {
      _isSelectingCategory = true;
    } else {
      // 홈페이지>전체보기 또는 하단메뉴[복지검색] 탭
      _isSelectingCategory = false;
    }
  }

  Future<void> getSharedPolicy(String policyId) async {
    List<Policy> policies = await policyService.getPolicyById(policyId);
    if (policies.isNotEmpty) {
      sharedPolicy = policies[0];
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPolicyPage(
            sharedPolicy,
          ),
        ),
      );
    }
  }

  void updateSelectedSortOrder(policySortOrder? newSortOrder) {
    setState(() {
      widget.selectedSortOrder = newSortOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String selectedSortOrderCode = widget.selectedSortOrder?.code ?? '0';
    // print(_isSelectingCategory);

    selectedSortOrderCode = widget.selectedSortOrder?.code ?? '0';

    final policyInstitution = widget.selectedCodes.policyInstitution;
    final policyTarget = widget.selectedCodes.policyTarget;
    final policyField = widget.selectedCodes.policyField;
    final policyCharacter = widget.selectedCodes.policyCharacter;

    // 운영 기관
    final String selectedInstitutionCodeName =
        policyInstitution?.isNotEmpty == true
            ? policyInstitution![0].codeName
            : '';
    final String selectedInstitutionCodeDetail =
        policyInstitution?.isNotEmpty == true ? policyInstitution![0].code : '';
    // 정책 대상
    final String selectedTargetCodeName =
        policyTarget?.isNotEmpty == true ? policyTarget![0].codeName : '';
    final String selectedTargetCodeDetail =
        policyTarget?.isNotEmpty == true ? policyTarget![0].code : '';
    // 정책 분야
    final String selectedFieldCodeName =
        policyField?.isNotEmpty == true ? policyField![0].codeName : '';
    final String selectedFieldCodeDetail =
        policyField?.isNotEmpty == true ? policyField![0].code : '';
    //정책 성격
    final String selectedCharacterCodeName =
        policyCharacter?.isNotEmpty == true ? policyCharacter![0].codeName : '';
    final String selectedCharacterCodeDetail =
        policyCharacter?.isNotEmpty == true ? policyCharacter![0].code : '';

    return BlocListener<PolicyBloc, PolicyState>(
        listener: (context, state) {},
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: ThemeColors.third,
              appBar: AppBar(
                backgroundColor: ThemeColors.primary,
                toolbarHeight: 10,
                elevation: 0,
              ),
              body: SafeArea(
                  child: Column(
                children: <Widget>[
                  const SearchBar(), // 검색창
                  Visibility(
                    visible: _isSelectingCategory,
                    child: SelectedSearchConditions(
                      selectedCodes: widget.selectedCodes,
                      onRemove: _removeCodeDetail,
                    ),
                  ),
                  Expanded(
                    child: Center(
                        child: BlocBuilder<PolicyBloc, PolicyState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        if (state.isSearchPolicy) {
                          return streamSearchPolicy();
                        } else if (_isSelectingCategory) {
                          return FutureBuilder<List<Policy>>(
                            future: policyService.getPolicyBySelect(
                                // selectedCodeName, selectedCodeDetail
                                selectedInstitutionCodeName,
                                selectedInstitutionCodeDetail,
                                selectedTargetCodeName,
                                selectedTargetCodeDetail,
                                selectedFieldCodeName,
                                selectedFieldCodeDetail,
                                selectedCharacterCodeName,
                                selectedCharacterCodeDetail,
                                selectedSortOrderCode),
                            builder: (_, snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.data!.isEmpty) {
                                return _ListWithoutPolicySearch();
                              }
                              policyCount = snapshot.data?.length ?? 0;
                              return !snapshot.hasData
                                  ? const _ShimerLoading()
                                  : Column(
                                      children: [
                                        PolicyBar(
                                          policyCount: policyCount,
                                          selectedSortOrder:
                                              widget.selectedSortOrder,
                                          onUpdateSortOrder:
                                              updateSelectedSortOrder,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: false,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (_, i) =>
                                                ListViewPolicy(
                                              policies: snapshot.data![i],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                            },
                          );
                        } else {
                          // print(selectedSortOrderCode);
                          return FutureBuilder<List<Policy>>(
                            future: policyService
                                .getAllPolicy(selectedSortOrderCode),
                            builder: (_, snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.data!.isEmpty) {
                                return _ListWithoutPolicy();
                              }
                              policyCount = snapshot.data?.length ?? 0;
                              return !snapshot.hasData
                                  ? const _ShimerLoading()
                                  : Column(
                                      children: [
                                        PolicyBar(
                                          policyCount: policyCount,
                                          selectedSortOrder:
                                              widget.selectedSortOrder,
                                          onUpdateSortOrder:
                                              updateSelectedSortOrder,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: false,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (_, i) =>
                                                ListViewPolicy(
                                              policies: snapshot.data![i],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                            },
                          );
                        }
                      },
                    )),
                  )
                ],
              )),
              bottomNavigationBar: const BottomNavigation(index: 2),
            )));
  }

  Widget streamSearchPolicy() {
    return StreamBuilder<List<Policy>>(
      stream: policyService.searchProducts,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Expanded(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                TextCustom(
                  text: '검색 결과가 없어요',
                  // '${_searchController.text}에 대한 검색 결과 없음',
                  color: ThemeColors.basic,
                ),
              ])));
        }
        // 검색 결과 수
        policyCount = snapshot.data!.length;

        return Column(
          children: [
            PolicyBar(
              policyCount: policyCount,
              selectedSortOrder: widget.selectedSortOrder,
              onUpdateSortOrder: updateSelectedSortOrder,
            ),
            Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) => ListViewPolicy(
                        // codeData: codeData,
                        policies: snapshot.data![i],
                      )),
            )
          ],
        );
      },
    );
  }
}

// 검색창
class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _searchController;
  late FocusNode _myFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _myFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final value = _searchController.text.trim();
    if (value.isNotEmpty) {
      final policyBloc = BlocProvider.of<PolicyBloc>(context);
      policyBloc.add(OnIsSearchPolicyEvent(true));
      policyService.searchPolicy(value);
      _myFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyBloc = BlocProvider.of<PolicyBloc>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      color: ThemeColors.primary,
      child: Container(
        padding: const EdgeInsets.only(right: 5.0),
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: BlocBuilder<PolicyBloc, PolicyState>(
          builder: (context, state) => TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              _performSearch();
            },
            focusNode: _myFocusNode,
            controller: _searchController,
            cursorColor: ThemeColors.primary,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '복지 검색',
              hintStyle: const TextStyle(fontFamily: 'NanumSqureRound'),
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.tune,
                  size: 20,
                  color: ThemeColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    routeSlide(
                      page: const PolicySearchFilterPage(),
                    ),
                  );
                },
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        size: 20,
                        color: ThemeColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          policyBloc.add(OnIsSearchPolicyEvent(false));
                          _myFocusNode.unfocus();
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.search_rounded,
                        color: ThemeColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _performSearch();
                        });
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedSearchConditions extends StatelessWidget {
  final SelectedCodes selectedCodes;
  final Function(String detailName) onRemove;

  const SelectedSearchConditions({
    Key? key,
    required this.selectedCodes,
    required this.onRemove,
    // required this.isSelectingCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> selectedDetails = [];
    final size = MediaQuery.of(context).size;

    final List<CodeDetailData> policyInstitution =
        selectedCodes.policyInstitution ?? [];
    final List<CodeDetailData> policyTarget = selectedCodes.policyTarget ?? [];
    final List<CodeDetailData> policyField = selectedCodes.policyField ?? [];
    final List<CodeDetailData> policyCharacter =
        selectedCodes.policyCharacter ?? [];

    selectedDetails.addAll(policyInstitution.map((e) => e.detailName));
    selectedDetails.addAll(policyTarget.map((e) => e.detailName));
    selectedDetails.addAll(policyField.map((e) => e.detailName));
    selectedDetails.addAll(policyCharacter.map((e) => e.detailName));

    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: ThemeColors.basic, width: 0.3),
        ),
      ),
      child: Wrap(
        spacing: 5, // 좌우 간격
        runSpacing: 5, // 상하 간격
        children: selectedDetails
            .map((codeDetailName) => Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      onRemove(codeDetailName);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextCustom(
                          text: codeDetailName,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        const Icon(
                          Icons.clear,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class policySortOrder {
  final String name;
  final String code;

  policySortOrder({required this.name, required this.code});
}

class PolicyBar extends StatefulWidget {
  final int policyCount;
  final policySortOrder? selectedSortOrder;
  final Function(policySortOrder?) onUpdateSortOrder;
  const PolicyBar(
      {Key? key,
      required this.policyCount,
      this.selectedSortOrder,
      required this.onUpdateSortOrder})
      : super(key: key);

  @override
  State<PolicyBar> createState() => _PolicyBarState();
}

class _PolicyBarState extends State<PolicyBar> {
  late policySortOrder _selectedSortOrder;

  final List<policySortOrder> _sortByOptions = [
    policySortOrder(name: '최신순', code: '0'),
    policySortOrder(name: '등록순', code: '1'),
    policySortOrder(name: '스크랩많은순', code: '2'),
    policySortOrder(name: '스크랩적은순', code: '3'),
    policySortOrder(name: '마감일순', code: '4'),
    // policySortOrder(name: '조회수높은순', code: '5'),
    // policySortOrder(name: '조회수낮은순', code: '6'),
  ];
  // late String _sortOrderCode = '0';

  @override
  void initState() {
    super.initState();
    _selectedSortOrder = widget.selectedSortOrder ?? _sortByOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    final int policyCount = widget.policyCount;

    return Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        // height: 25,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextCustom(
            text: '검색결과 $policyCount건',
            fontSize: 15,
            color: ThemeColors.basic,
          ),

          // 정렬
          PopupMenuButton(
            onSelected: (policySortOrder value) {
              setState(() {
                _selectedSortOrder = value;
                widget.onUpdateSortOrder(value);
              });
            },
            itemBuilder: (BuildContext context) {
              return _sortByOptions.map((policySortOrder option) {
                return PopupMenuItem<policySortOrder>(
                    value: option, child: TextCustom(text: option.name));
              }).toList();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextCustom(
                  text: _selectedSortOrder.name,
                  fontSize: 15,
                  color: ThemeColors.basic,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: ThemeColors.primary,
                )
              ],
            ),
          ),
        ]));
  }
}

// 정책 리스트
class ListViewPolicy extends StatefulWidget {
  final Policy policies;

  const ListViewPolicy({
    Key? key,
    required this.policies,
  }) : super(key: key);

  @override
  State<ListViewPolicy> createState() => _ListViewPolicyState();
}

class _ListViewPolicyState extends State<ListViewPolicy> {
  @override
  Widget build(BuildContext context) {
    final Policy policies = widget.policies;

    // 정책 고유 번호
    final String policyId = policies.pid;

    // 기관
    final String policyInstitution = getMobileCodeService.getCodeDetailName(
        "policy_institution_code", policies.policy_institution_code);
    // 제목
    final String policyName = policies.policy_name;
    // 분야
    final String policyField = getMobileCodeService.getCodeDetailName(
        "policy_field_code", policies.policy_field_code);
    final String policyCharacter = getMobileCodeService.getCodeDetailName(
        "policy_character_code", policies.policy_character_code);

    // 이미지
    final String imgName = policies.img;
    final String imgUrl = '${Environment.urlApiServer}/upload/policy/$imgName';

    // 모집 기간
    final String startDateYear =
        policies.application_start_date.substring(0, 4);
    final String endDateYear = policies.application_end_date.substring(0, 4);
    final String startDateMonth =
        policies.application_start_date.substring(5, 7);
    final String endDateMonth = policies.application_end_date.substring(5, 7);
    final String startDateDay =
        policies.application_start_date.substring(8, 10);
    final String endDateDay = policies.application_end_date.substring(8, 10);
    final String startDate = '$startDateYear.$startDateMonth.$startDateDay';
    final String endDate = '$endDateYear.$endDateMonth.$endDateDay';

    return Padding(
        padding: const EdgeInsets.fromLTRB(3, 3, 3, 0), // 카드 바깥쪽
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(7), // 카드 안쪽
              child: InkWell(
                  splashColor: ThemeColors.primary.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPolicyPage(
                          policies,
                        ),
                      ),
                    );
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: SizedBox(
                            // 이미지
                            width: 80.0,
                            height: 80.0,
                            child: Image.network(
                              imgUrl,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/default_policy_img.png',
                                  fit: BoxFit.fill,
                                );
                              },
                            ),
                            // Image(
                            //   image: AssetImage(imgUrl),
                            //   fit: BoxFit.fitWidth,
                            // ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // 주최 기관
                                    TextCustom(
                                      text: policyInstitution,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12.0,
                                      color: ThemeColors.basic,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    // 정책 제목
                                    TextCustom(
                                      text: policyName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // 모집 기간
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 2, bottom: 2),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ThemeColors.secondary,
                                      ),
                                      child: TextCustom(
                                        text: '$startDate ~ $endDate',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    // 카테고리
                                    Row(
                                      children: [
                                        TextCustom(
                                          text: policyField,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextCustom(
                                          text: policyCharacter,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12,
                                        ),
                                      ],
                                    )
                                  ],
                                ))),
                        SizedBox(
                          width: 50,
                          height: 80,
                          child: _ScrapUnscrap(
                            uidPolicy: policies.pid,
                            countScraps: policies.count_scraps,
                          ),
                        )
                      ]))),
        ));
  }
}

// 정책 스크랩
class _ScrapUnscrap extends StatefulWidget {
  final String uidPolicy; // 정책 고유번호
  final int countScraps; // 스크랩 수

  const _ScrapUnscrap({
    Key? key,
    required this.uidPolicy,
    required this.countScraps,
  }) : super(key: key);
  @override
  State<_ScrapUnscrap> createState() => _ScrapUnscrapState();
}

class _ScrapUnscrapState extends State<_ScrapUnscrap> {
  bool _isScrapped = false;

  @override
  void initState() {
    super.initState();
    _loadScrappedStatus();
  }

  Future<void> _loadScrappedStatus() async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is SuccessAuthentication) {
      final uidPolicy = widget.uidPolicy;
      final isScrapped = await policyService.checkPolicyScrapped(uidPolicy);
      setState(() {
        _isScrapped = isScrapped == 1;
      });
    } else {
      setState(() {
        _isScrapped = false;
      });
    }
  }

  Future<void> _handleScrapUnscrap() async {
    final policyBloc = BlocProvider.of<PolicyBloc>(context);
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final userState = BlocProvider.of<UserBloc>(context).state;
    final uidUser = userState.user?.uid;
    final uidPolicy = widget.uidPolicy;

    if (authState is SuccessAuthentication) {
      if (uidUser != null) {
        policyBloc.add(
          OnScrapOrUnscrapPolicy(uidPolicy, uidUser),
        );
        setState(() {
          _isScrapped = !_isScrapped;
        });

        if (_isScrapped) {
          modalScrap(context);
        } else {
          // modalUnScrap();
        }
      }
    } else {
      modalCheckLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyBloc = BlocProvider.of<PolicyBloc>(context);
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final userState = BlocProvider.of<UserBloc>(context).state;
    final uidUser = userState.user?.uid;
    final uidPolicy = widget.uidPolicy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            _handleScrapUnscrap();

            // if (authState is LogOut) {
            //   modalCheckLogin(context);
            //   // modalCheckLogin().showBottomDialog(context);
            // } else {
            //   if (uidUser != null) {
            //     policyBloc.add(
            //       OnScrapOrUnscrapPolicy(uidPolicy, uidUser),
            //     );
            //     setState(() {
            //       _isScrapped = !_isScrapped;
            //     });
            //   }
            // }
          },
          icon: Icon(
            _isScrapped ? Icons.bookmark : Icons.bookmark_border_outlined,
            color: authState is LogOut
                ? ThemeColors.basic
                : (_isScrapped ? ThemeColors.primary : ThemeColors.basic),
            size: 30,
          ),
        ),
        TextCustom(
          text: widget.countScraps.toString(),
          color: ThemeColors.basic,
          fontSize: 10,
        ),
      ],
    );
  }
}

// 등록된 정책 없을 때
class _ListWithoutPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/aco4.png',
                height: size.height / 4,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextCustom(text: '등록된 정책이 없어요', fontSize: 20),
            ],
          ),
        ));
  }
}

// 검색 결과 없을 때
class _ListWithoutPolicySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/aco4.png',
            height: size.height / 4,
          ),
          const SizedBox(
            height: 10,
          ),
          const TextCustom(text: '등록된 정책이 없어요', fontSize: 20),
        ],
      ),
    );
  }
}

// 로딩
class _ShimerLoading extends StatelessWidget {
  const _ShimerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ShimmerNaru(),
        SizedBox(height: 10.0),
        ShimmerNaru(),
        SizedBox(height: 10.0),
        ShimmerNaru(),
      ],
    );
  }
}
