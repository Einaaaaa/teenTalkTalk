part of 'widgets.dart';

class BottomNavigation extends StatelessWidget {
  final int index;
  final bool isReel;

  const BottomNavigation({Key? key, required this.index, this.isReel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
<<<<<<< Updated upstream
      padding: EdgeInsets.only(top: 5),
=======
>>>>>>> Stashed changes
      decoration: BoxDecoration(
          color: isReel ? Colors.black : Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: -1)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ItemButtom(
              i: 1,
              index: index,
              // icon: Icons.home,
              isIcon: false,
              iconString: 'images/bottom_bar/icon_menu_home.svg',
              isReel: isReel,
              iconText: '홈',
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (_) => false)),

          // Navigator.pushAndRemoveUntil(
          //     context, routeSlide(page: const HomePage()), (_) => false)),

          _ItemButtom(
              i: 2,
              index: index,
              isIcon: false,
              isReel: isReel,
              iconString: 'images/bottom_bar/icon_menu_thumb.svg',
              iconText: '복지검색',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyListPage(
                                selectedCodes: SelectedCodes(
                              policyInstitution: [],
                              policyTarget: [],
                              policyField: [],
                              policyCharacter: [],
                              // policyArea: []
                            ))),
                    (_) => false);
              }),
          _ItemButtom(
              i: 3,
              index: index,
              // icon: Icons.date_range,
              isIcon: false,
              isReel: isReel,
              iconString: 'images/bottom_bar/icon_menu_scrap.svg',
              iconText: '스크랩',
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ScrapPage()),
                  (_) => false)),
          _ItemButtom(
              i: 4,
              index: index,
              // icon: Icons.card_giftcard_rounded,
              isIcon: false,
              isReel: isReel,
              iconString: 'images/bottom_bar/icon_menu_event.svg',
              iconText: '이벤트',
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                  (_) => false)),
          _ItemButtom(
              i: 5,
              index: index,
              // icon: Icons.person,
              isIcon: false,
              isReel: isReel,
              iconString: 'images/bottom_bar/icon_menu_mypage.svg',
              iconText: '마이 톡톡',
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyTalkTalkPage()),
                  (_) => false)),

          // _ItemProfile()
        ],
      ),
    );
  }
}

// class _ItemProfile extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const ProfilePage()), (_) => false),
//       child: BlocBuilder<UserBloc, UserState>(
//           builder: (_, state)
//           => state.user?.image != null
//               ? CircleAvatar(
//               radius: 15,
//               backgroundImage: NetworkImage(Environment.baseUrl+ state.user!.image )
//           )
//               : const CircleAvatar(
//               radius: 15,
//               backgroundColor: ThemeColors.primary,
//               child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
//           )
//       ),
//     );
//   }
// }

class _ItemButtom extends StatelessWidget {
  final int i;
  final int index;
  final bool isIcon;
  final IconData? icon;
  final String? iconString;
  final Function() onPressed;
  final bool isReel;
  final String iconText;

  const _ItemButtom({
    Key? key,
    required this.i,
    required this.index,
    required this.onPressed,
    this.iconString,
    this.isIcon = true,
    this.isReel = false,
    required this.iconText,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
            //margin: const EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                (isIcon)
                    ? Icon(icon,
                        color: (i == index)
                            ? ThemeColors.primary
                            : isReel
                                ? Colors.white
                                : ThemeColors.basic,
                        size: MediaQuery.of(context).size.width / 15)
                    : SvgPicture.asset(
                        iconString!,
                        height: MediaQuery.of(context).size.width / 15,
                        color: (i == index)
                            ? ThemeColors.primary
                            : isReel
                                ? Colors.white
                                : ThemeColors.basic,
                      ),
                const SizedBox(
                  height: 6,
                ),
                TextCustom(
                  text: iconText,
                  fontSize: 13,
                ),
              ],
            )));
  }
}
