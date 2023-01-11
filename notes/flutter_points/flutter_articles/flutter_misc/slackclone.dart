import 'dart:html';
import 'package:flutter/material.dart';

void main() {
  runApp(SlackApp());
}

class SlackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Slack', home: HomeScreen(),
    debugShowCheckedModeBanner: false);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Material(
      color: Color(0xFF1D2229),
      child: Column(
        children: [if (!isMobile) WindowSection(), Expanded(child: WorkspaceSection())],
      ),
    );
  }
}

class WindowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 34,
      width: size.width,
      color: Color(0xFF0A151F),
      child: Row(
        children: [
          SizedBox(width: 20),
          ClipOval(child: Container(color: Colors.red, width: 12, height: 12)),
          SizedBox(width: 10),
          ClipOval(child: Container(color: Colors.yellow, width: 12, height: 12)),
          SizedBox(width: 10),
          ClipOval(child: Container(color: Colors.green, width: 12, height: 12)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Icon(Icons.arrow_back, color: Colors.grey[300], size: 20),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Colors.grey[600], size: 20),
                SizedBox(width: 20),
                Icon(Icons.access_time, color: Colors.grey[300], size: 22),
                SizedBox(width: 40),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 500, minWidth: 0),
                      child: Container(
                        height: 25,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                            color: Color(0xFF262D31),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Color(0xFF42484B), width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 14, color: Colors.grey[300]),
                            SizedBox(width: 5),
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: Text(
                                'Search on this workspace',
                                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.help_outline, color: Colors.grey[400], size: 20),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

class WorkspaceSection extends StatefulWidget {
  @override
  WorkspaceSectionState createState() => WorkspaceSectionState();
}

class WorkspaceSectionState extends State<WorkspaceSection> with TickerProviderStateMixin {
  List<Widget> _workspacesItems = [];
  List<Tuple<Workspace, GlobalKey<WorkspaceItemState>>> _workspaces = [
    Tuple(
        Workspace()
          ..name = 'Flutter Study Group'
          ..url = 'flutterstudygroup.slack.com'
          ..logo =
              'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAw1BMVEX///97zfQTXJwRVZESWZgSWZYPUIkQUYsRVpMOTYRvyfMRVpIAS5QQU4+A0/kSWpoNSX0AVJjd7vgASpTV6vcAU5gATpUMR3qr3vi+5fnk8fnK6vq34/nT7fvr9/3b7feNqcivwtgAPXOO0/VZpNP2+fyVr8wAS4xhrdkAQ4DQ3Ohpt+Bch7To7vSR1fah2veBvuOhuNGww9jE0uJsj7hNfK4AP3opaaMAKWgAMnODocM7cagAPH3C0eJQfK52mb/d5e8O9u1tAAAG1ElEQVR4nO3da1vbNhgGYOwACTm5JouXFigwDqMcN6ddVxoa/v+vqiTbiZ04PsiSHsmXni/bR9/X++poh+7t2djY2NjY2NjY2NjY2NjY2NgU5vP5yccZzenJ2Wf0wwjP8emz06dxnPi/V7OzG/RTCcvZS0TbSL//fIJ+NBG5OXVydCvkzPR+vZnlVS+DfDHaeFrmY8aZsQPyvKA/s71q6HicVfMx47OBZbwZVwfSfEI/cN0c1/ORMhrWqWd1gYR4in7oOjmpDzSLyAU0icgJNGcscgMJ8Rj98FXSAEiIBqyLjYCOc4V+/tJwLBPZIn5EC0rSsIKUqPdRoznQcZ7RiKI0bVGW/jmasTtCgDpPNoKATv8MLdkRUUBtR6I4oKbTqUCgnjtwkUASNGc7goF97a40BAP1a1PRQO2WRPFAzQ5REoB6DUQZQK2uM6QAnf4M7VrlXArQcV7QsCRyKujoM5nKqqDjjNG0KPKAmuzbZAK1EEobg7oI/5AK1EAoGYifaSQD8auFbCB8xZcORB8QpQPRO2/5QPDpSQHQ6bcdCL0TVgJEvkRUAkReekvdbKfSdiCuSdW0KPAuURUQtmVTNQZhy70yIGoxVAcELRXqgKBRWPuLX/5gJlKFFcScm1QCIT2qsEUx+zWVQMg8qhSI+KRNKRAxy1igBWoO/KQSiDj1WqBIoG1RC7RAC2wd8HPbgXvqfCDgc9uByq62YS8olPlQwI/qrn5Br5haDxTxG8lqQNQnM1dtB96oegkK++hJUZMCv+qatR2oZjGEfpfXeqCKiQb7ZaUCIfjTUfnC8T9QoHzh+Hpy0Wrh+HrqBq9Qonyg6wYXrRVGQNcdIoky9zQJEEuUuC9dA6FEeVNNGkiItzCirPNhFoisoqQ2Hd9NPTdLhFVRinB87bsbQlwVZdy1je/+3vc2hbgqSgJu1RBHFP7rVwI8ONjPEcKIL+KB+wd5NcQRxQN3CVFEke8P6RgsEKKI4t4BE2CvUGg6kQKJcOc4ZMR/DSYyYJnQZCIBDga93kGJ0FwiAY4GSQ1z9jTGEwmw04mEZKY5KBKaSWRAJiQl3M/d0phNHN99GY3WNaQDUUci/zfCdAx2OilhSQ1dd2IWkVSwmxEWTaUmVpEBI+Ggag2NIkbAtLBkKk0aNTSESIHdEenS0aDTG/TYPFOhhJQ4N4I4fvjSPWQ1JFWkwopNSuIF7wYQSQUPYyFJxeVwRXQxP1Sv8/tDUsHDrJBNpVWGIY3/CBHWIDLgYbcbC9liUXkY0gSY2aZyo0ZAWsNotRhEE03VJqV9GoD+oEK1KhLgUUZYb6KJ+vQrRliJSIGRMGlTItxnR6fKQLJkvGtLZMC1kCwWyZ6tRglJn34DCUuJ44f/jtLCUTQMazYpyfAeRSz+ADwGMmFqGNImrbxWREGtGCXEBJjUkA7DHk+TkgRPMOLuRiXAD7GwGwnjbXf9JnXdKe4F8U5iCshqOEqvFZXOFel4Lk64o1HHD3/FwHSTxlu2GhuaJMN3zYgUuCXsJCen2k1K5hpgm+YRGTAjXG1K+UoIXBJziRHwQ36TcpXQ9abYfzkgSyTAP7eFndRyz5EAtuhvExPgWthNlnu+xZBleokVpojbwKRJB/VO99n4F2DhikiBecL1jo0LiNy4ZYkMmBqFR9kdG3cJXe8nGhgR18Bd8wxnCV3vO9q3R4kRcC08PBKyVERB82jO7hiwaKmovSNdFxGtY5n/v6OEneYl1EPIiIWjkLuEenQpyfxHvrDXuIQ6zDQs8x9FGzZuoBarRRxKzJybhIxC18Ov+KsQ4nYJe/VvSbPxsb+ryeZtEQO7qbWQ8+S7CnznncnbD4GHijjo09NGKHHVoyPOa+CNGmr1b+ft7YWL+PKiK6iEGk2lcd4W6yaNS9hgsdfheLiVcJG6YGu4UrjINxe7Ey6yryoaAV0fzckLIWaun1rWpDThYjRK3ts3A2KvvAsSLhrc46cDvg8uSLjgeG2fk+ANLdmZcCKiR/VbDFMJh/vNzr00Q8zHbRUTThruZkgJf6ERxQknDYHuBPeKu1rCYSOfG0BfHVbK5aQJUOtpJkkj4lT3HmW55G9U0EfCtcNNBH3LzhHORsX+0ZN64SIOdbpgKw3HogH+40O1c7/5VyJK4k20ukCskqfvfg2g72l4cVGa5bBqGb3gl2bXhxUzd6u1qq/XFXetXATlreoPl2YWMMrTclho9Pzh4zv6IRvm6cILdp2JvWC6fEc/oIjMv04Df0PpeX4QPIYm92c29xffiGjqR5mS//35+tYeXpyn+eXt63K5fL29fHtHP4yNjY2NjY2NjY2NjY2NjY0NOr8BRyPQkpP5WXoAAAAASUVORK5CYII='
          ..user = Utils.userLogged
          ..channels = [
            Channel()
              ..name = 'animations'
              ..private = false
              ..users = [
                Utils.userLogged,
              ]
              ..chats = [
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'Let me see if animated GIF works'
                  ..timestamp = 1590194974524,
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'https://media2.giphy.com/media/4PY2P7jVGwJpNb9TLl/giphy.gif'
                  ..timestamp = 1590194974550,
              ],
            Channel()
              ..name = 'announcements'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'Everyone! New clone ready! 🥳🥳🥳'
                  ..timestamp = 1590378680483,
                Chat()
                  ..user = Utils.martin
                  ..text = '🔥🔥🔥'
                  ..timestamp = 1590378685340,
                Chat()
                  ..user = Utils.simon
                  ..text = 'Flutter has no limits!'
                  ..timestamp = 1590378690209,
                Chat()
                  ..user = Utils.tim
                  ..text = '🙌 https://i1.wp.com/blog.codepen.io/wp-content/uploads/2020/03/flutter-on-codepen.png'
                  ..timestamp = 1590378826009,
                Chat()
                  ..user = Utils.nash
                  ..text = '👀👀👀'
                  ..timestamp = 1590378863226,
                Chat()
                  ..user = Utils.chris
                  ..text = 'How many pens so far?!'
                  ..timestamp = 1590380405755,
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'Like 19 #FlutterPen'
                  ..timestamp = 1590380435502,
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'or more... not sure lol Let me check'
                  ..timestamp = 1590380462853,
              ]
              ..topic = 'Announcements - Please use Threads for conversations in this channel.',
            Channel()
              ..name = 'community_organizers'
              ..private = true
              ..users = Utils.allUsers.sublist(0, 7)
              ..chats = [
                Chat()
                  ..user = Utils.nilay
                  ..text = 'If you need help for events and community related, make sure to contact me 😊'
                  ..timestamp = 1590380204601,
              ],
            Channel()
              ..name = 'firebase'
              ..private = false
              ..users = [Utils.userLogged, Utils.nash]
              ..chats = [],
            Channel()
              ..name = 'fuchsia'
              ..private = false
              ..users = [Utils.userLogged, Utils.nash]
              ..chats = [],
            Channel()
              ..name = 'general'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'This channel always gets so random, lol 😜'
                  ..timestamp = 1590380262195,
                Chat()
                  ..user = Utils.simon
                  ..text = 'Well... if you don\'t spam...'
                  ..timestamp = 1590380286760,
                Chat()
                  ..user = Utils.userLogged
                  ..text = '😒'
                  ..timestamp = 1590380312687,
                Chat()
                  ..user = Utils.nash
                  ..text = '😂😂😂😂😂'
                  ..timestamp = 1590380312687,
                Chat()
                  ..user = Utils.scott
                  ..text = 'You guys love to fight all the time lol'
                  ..timestamp = 1590380346349,
              ],
            Channel()
              ..name = 'hack20'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [
                Chat()
                  ..user = Utils.simon
                  ..text = 'Sign up now for #Hack20\n\nhttps://flutterhackathon.com/#/\n https://miro.medium'
                      '.com/max/2580/0*vValokazzfj52F2N?.jpg'
                ..timestamp = 1590379043156
              ],
            Channel()
              ..name = 'interact'
              ..private = true
              ..users = [Utils.userLogged, Utils.nash]
              ..chats = [],
            Channel()
              ..name = 'intros'
              ..private = false
              ..users = [Utils.userLogged, Utils.nash]
              ..chats = [],
            Channel()
              ..name = 'web'
              ..private = false
              ..users = [Utils.userLogged, Utils.nash]
              ..chats = [
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'CodePen continues to amaze me! https://miro.medium.com/max/800/1*Otx7CXIY9eh0Sxlp54olxA.png'
                  ..timestamp = 1590379697709
              ],
          ]
          ..users = Utils.allUsers
          ..dms = [
            DM()
              ..user = Utils.userLogged
              ..chats = [],
            DM()
              ..user = Utils.chris
              ..chats = [
                Chat()
                  ..user = Utils.chris
                  ..text = 'Sounds like you have something new, right?'
                  ..timestamp = 1590379519706
              ],
            DM()
              ..user = Utils.nilay
              ..chats = [],
            DM()
              ..user = Utils.tim
              ..chats = [
                Chat()
                  ..user = Utils.tim
                  ..text = 'Working on a new CodePen?'
                  ..timestamp = 1590366288580
              ],
            DM()
              ..user = Utils.nash
              ..chats = [
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'Hey, Nash! Are you there?'
                  ..timestamp = 1590199478148,
                Chat()
                  ..user = Utils.nash
                  ..text = 'Yep! Here, sup'
                  ..timestamp = 1590199490797,
                Chat()
                  ..user = Utils.nash
                  ..text = 'Just finished college!!!'
                  ..timestamp = 1590199970558,
                Chat()
                  ..user = Utils.userLogged
                  ..text = '🥳🥳🥳'
                  ..timestamp = 1590199975102,
              ],
            DM()
              ..user = Utils.simon
              ..chats = [
                Chat()
                  ..user = Utils.simon
                  ..text = 'Jump to Zoom. The whole gang is there.'
                  ..timestamp = 1590379563037,
                Chat()
                  ..user = Utils.userLogged
                  ..text = 'Gotcha! And thanks for all the help 😊'
                  ..timestamp = 1590379587572,
              ],
            DM()
              ..user = Utils.scott
              ..chats = [
                Chat()
                  ..user = Utils.scott
                  ..text = 'Did @Simon told you to jump into Zoom?'
                  ..timestamp = 1590379624392,
              ],
          ],
        GlobalKey<WorkspaceItemState>()),
    Tuple(
        Workspace()
          ..name = 'Flutter Bs As'
          ..url = 'flutterdevbsas.slack.com'
          ..user = Utils.userLogged
          ..channels = [
            Channel()
              ..name = 'random'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [],
            Channel()
              ..name = 'general'
              ..private = false
              ..users = Utils.allUsers.sublist(0, 5)
              ..chats = [],
            Channel()
              ..name = 'admin'
              ..private = true
              ..users = [
                Utils.userLogged,
                Utils.ariel
              ]
              ..chats = [],
          ]
          ..users = [
            Utils.userLogged,
            Utils.ariel,
          ]
          ..dms = [
            DM()
              ..user = Utils.userLogged
              ..chats = [],
            DM()
              ..user = Utils.ariel
              ..chats = [],
          ],
        GlobalKey<WorkspaceItemState>()),
    Tuple(
        Workspace()
          ..name = 'GDG Global'
          ..url = 'gdgglobal.slack.com'
          ..logo =
              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRzlnlRY55ine9zQvxR2dCJQKxEvxLkKr5IWfPfEZlEPq33Iya3&usqp=CAU'
          ..user = Utils.userLogged
          ..channels = [
            Channel()
              ..name = 'io19'
              ..private = false
              ..users = Utils.allUsers.sublist(0, 6)
              ..chats = [],
            Channel()
              ..name = 'announcements'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [],
            Channel()
              ..name = 'events'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [],
            Channel()
              ..name = 'jobs'
              ..private = false
              ..users = Utils.allUsers.sublist(0, 3)
              ..chats = [],
            Channel()
              ..name = 'support'
              ..private = false
              ..users = Utils.allUsers
              ..chats = [],
          ]
          ..users = Utils.allUsers
          ..dms = [
            DM()
              ..user = Utils.userLogged
              ..chats = [],
          ],
        GlobalKey<WorkspaceItemState>()),
  ];

  List<DMUserItem> _dms = [];
  List<ChannelItem> _channels = [];

  List<Widget> _menus = [
    _menuSection(Icons.subject, 'All unreads', () {}),
    _menuSection(Icons.chat, 'Threads', () {}),
    _menuSection(Utils.at, 'Mentions & Reactions', () {}),
    _menuSection(Icons.drafts, 'Drafts', () {}),
    _menuSection(Icons.bookmark_border, 'Saved items', () {}),
    _menuSection(Utils.hash, 'Mentions & Reactions', () {}),
    _menuSection(Utils.at, 'Channel browser', () {}),
    _menuSection(Icons.book, 'People', () {}),
    _menuSection(Icons.apps, 'Apps', () {}),
    _menuSection(Icons.folder_open, 'Files', () {}),
  ];

  int _currentIndex = 0;

  ClickItem _clickItem;
  ClickItem _closeItem;
  ClickItem _chatsItem;
  ClickItem _chanlItem;

  bool _showDMs = true;
  bool _showMenus = false;
  bool _showChannels = true;

  final _textController = TextEditingController();

  AnimationController _leftController;
  AnimationController _rightController;
  Animation<Offset> _leftPanel;
  Animation<Offset> _middleLeftPanel;
  Animation<Offset> _middleRightPanel;
  Animation<Offset> _rightPanel;

  double _direction = 0;
  AnimationController _activePanel;

  bool isMobile = false;
  bool switchToMobile = false;

  void _closePanels() {
    if (_activePanel != null) {
      if (_activePanel.value < 0.5) {
        _activePanel.reverse();
      } else {
        _activePanel.forward();
      }
      _activePanel = null;
    }
  }

  void _itemSelection<T extends List>(T list, dynamic selected) {
    list.asMap().forEach((key, value) {
      if (list[key].key.currentState != null) {
        list[key].key.currentState.selected(selected is bool ? selected : key == selected);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _leftController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _rightController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _leftPanel = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero).animate(_leftController);
    _middleLeftPanel = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.85, 0)).animate(_leftController);
    _middleRightPanel = Tween<Offset>(begin: Offset(0, 0), end: Offset(-0.15, 0)).animate(_rightController);
    _rightPanel = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(_rightController);

    _clickItem = (index) {
      _workspacesItems.forEach((element) {
        if (element is WorkspaceItem) {
          (element.key as GlobalKey<WorkspaceItemState>).currentState.selected(index == element.index);
          setState(() => _currentIndex = index);
          _initChannels(true);
          _initDMs(true);
        }
      });
      if (isMobile) {
        _leftController.reverse();
        _direction = 1.0;
      }
    };
    _workspaces.asMap().forEach((index, value) {
      setState(() => _workspacesItems.add(WorkspaceItem(
          key: value.second, index: index, selected: index == 0, workspace: value.first, clickItem: _clickItem)));
    });
    _workspacesItems.add(AspectRatio(
        key: GlobalKey(), aspectRatio: 1, child: Container(child: Icon(Icons.add, color: Color(0xFFACADAF)))));

    _closeItem = (index) => Future.microtask(() => setState(() {
          _dms.removeAt(index);
          _workspaces[_currentIndex].first.dms.removeAt(index);
          _workspaces[_currentIndex].first.currentChannel = _workspaces[_currentIndex].first.currentChannel;
          _workspaces[_currentIndex].first.currentDM = -1;
          (_channels[_workspaces[_currentIndex].first.currentChannel].key as GlobalKey<ChannelItemState>)
              .currentState
              .selected(true);
          _dms.asMap().forEach((key, value) {
            (_dms[key].key as GlobalKey<DMUserItemState>).currentState.index(key);
          });
        }));
    _chatsItem = (index) => Future.microtask(() => setState(() {
          _workspaces[_currentIndex].first.currentDM = index;
          if (isMobile) {
            _direction = -1.0;
            _rightController.forward();
          } else {
            _itemSelection(_channels, false);
            _itemSelection(_dms, index);
          }
        }));
    _chanlItem = (index) => Future.microtask(() => setState(() {
          _workspaces[_currentIndex].first.currentChannel = index;
          _workspaces[_currentIndex].first.currentDM = -1;
          if (isMobile) {
            _direction = -1.0;
            _rightController.forward();
          } else {
            _itemSelection(_dms, false);
            _itemSelection(_channels, index);
          }
        }));

    _initDMs(false);
    _initChannels(false);

    _rightPanel.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

    _leftController.addListener(() {
      if (_leftController.value == 0.0 || _leftController.value == 1.0) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    isMobile = size.width < 700;
    if (!isMobile) switchToMobile = false;
    if (!switchToMobile && isMobile) {
      switchToMobile = true;
      _itemSelection(_dms, false);
      _itemSelection(_channels, false);
    }
    return isMobile ? _mobileView(size) : _desktopView(size);
  }

  Widget _mobileView(Size size) {
    final channelIndex = _workspaces[_currentIndex].first.currentChannel;
    final channel = channelIndex > -1 ? _workspaces[_currentIndex].first.channels[channelIndex] : null;
    final dmIndex = _workspaces[_currentIndex].first.currentDM;
    final dm = dmIndex > -1 ? _workspaces[_currentIndex].first.dms[dmIndex] : null;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_activePanel == null) {
          if (_leftController.value > 0.0) {
            _activePanel = _leftController;
          } else if (_rightController.value > 0.0) {
            _activePanel = _rightController;
          } else {
            if (details.primaryDelta > 5) {
              _activePanel = _leftController;
              _direction = 1.0;
            } else if (details.primaryDelta < -5) {
              _activePanel = _rightController;
              _direction = -1.0;
            } else {
              return;
            }
          }
        }
        _activePanel.value += details.primaryDelta * _direction / context.size.width;
      },
      onHorizontalDragEnd: (_) => _closePanels(),
      onHorizontalDragCancel: () => _closePanels(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_middleLeftPanel, _middleRightPanel]),
            builder: (BuildContext context, Widget child) {
              final value = _middleLeftPanel.value + _middleRightPanel.value;
              return SlideTransition(position: AlwaysStoppedAnimation(value), child: child);
            },
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: Color(0xFF1B1B24),
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Color(0xFF1A212E),
                    leading: GestureDetector(
                      onTap: () {
                        _leftController.forward();
                        _direction = 1.0;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: _workspaces[_currentIndex].first.logo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(_workspaces[_currentIndex].first.logo),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    _workspaces[_currentIndex].first.name.substring(0, 1),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    title: Text(_workspaces[_currentIndex].first.name),
                    centerTitle: false,
                    actions: [Icon(Icons.search, color: Colors.white), SizedBox(width: 20)],
                  ),
                  body: Column(
                    children: [
                      Separator(vertical: false),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 15),
                            _searchBarSection(),
                            SizedBox(height: 15),
                            _itemSideMenu(Icons.chat, 'Threads'),
                            _titleSection(
                                'Channels', () => setState(() => _showChannels = !_showChannels), _showChannels, null),
                            if (_showChannels) ..._channels,
                            SizedBox(height: 5),
                            _titleSection(
                                'Direct messages', () => setState(() => _showDMs = !_showDMs), _showDMs, null),
                            if (_showDMs) ..._dms,
                            if (_showDMs) _itemSideMenu(Icons.add, 'Invite People'),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Separator(vertical: false),
                    ],
                  ),
                  bottomNavigationBar: _bottomBar(),
                  floatingActionButton: FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.edit, color: Color(0xFF1C2128), size: 18),
                    backgroundColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
                GestureDetector(
                  onTap: _leftController.value == 1.0
                      ? () {
                          _leftController.reverse();
                          _direction = 1.0;
                        }
                      : null,
                  child: IgnorePointer(
                    ignoring: _leftController.value < 1.0,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: _leftController.value > 0.7 ? 0.7 : 0.0,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.85,
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: _leftPanel,
              child: Row(
                children: [
                  SizedBox(width: 5),
                  Container(
                    width: 70,
                    height: size.height,
                    color: Color(0xFF22222B),
                    child: ReorderableListView(
                      padding: const EdgeInsets.only(top: 200),
                      onReorder: (index, destination) {
                        if (index != _workspacesItems.length - 1) {
                          Future.microtask(() {
                            setState(() {
                              final item = _workspacesItems.removeAt(index);
                              _workspacesItems.insert(destination, item);
                            });
                          });
                        }
                      },
                      children: _workspacesItems,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      color: Color(0xFF1B1B24),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                _workspaces[_currentIndex].first.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                              child: Text(
                                _workspaces[_currentIndex].first.url,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            SizedBox(height: 5),
                            Separator(vertical: false),
                            SizedBox(height: 10),
                            _itemSideMenu(Icons.search, 'Channel browser'),
                            SizedBox(height: 5),
                            _itemSideMenu(Icons.book, 'People'),
                            SizedBox(height: 10),
                            Separator(vertical: false),
                            SizedBox(height: 10),
                            _itemSideMenu(Icons.person_add, 'Invite people'),
                            SizedBox(height: 5),
                            _itemSideMenu(Icons.help_outline, 'Help'),
                            SizedBox(height: 10),
                            Separator(vertical: false),
                            SizedBox(height: 10),
                            _itemSideMenu(Icons.tune, 'Preferences'),
                            SizedBox(height: 5),
                            _itemSideMenu(Icons.input, 'Sign out of ${_workspaces[_currentIndex].first.name}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: _rightPanel,
            child: Container(
              color: Color(0xFF1D2229),
              child: dmIndex > -1 ? _dmsView(dm) : _channelView(channel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color(0xFF1A212E)),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: SizedBox(height: 30, child: Icon(Icons.home)), title: Text('Home')),
          BottomNavigationBarItem(icon: SizedBox(height: 30, child: Icon(Icons.message)), title: Text('DMs')),
          BottomNavigationBarItem(icon: SizedBox(height: 30, child: Icon(Utils.at)), title: Text('Mentions')),
          BottomNavigationBarItem(icon: SizedBox(height: 30, child: Icon(Icons.insert_emoticon)), title: Text('You')),
        ],
        elevation: 0,
        currentIndex: 0,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _desktopView(Size size) {
    final channelIndex = _workspaces[_currentIndex].first.currentChannel;
    final channel = channelIndex > -1 ? _workspaces[_currentIndex].first.channels[channelIndex] : null;
    final dmIndex = _workspaces[_currentIndex].first.currentDM;
    final dm = dmIndex > -1 ? _workspaces[_currentIndex].first.dms[dmIndex] : null;
    return Row(
      children: [
        Container(
          width: 55,
          height: size.height,
          color: Color(0xFF1D2229),
          child: ReorderableListView(
            padding: const EdgeInsets.only(top: 10),
            onReorder: (index, destination) {
              if (index != _workspacesItems.length - 1) {
                Future.microtask(() {
                  setState(() {
                    final item = _workspacesItems.removeAt(index);
                    _workspacesItems.insert(destination, item);
                  });
                });
              }
            },
            children: _workspacesItems,
            scrollDirection: Axis.vertical,
          ),
        ),
        Separator(vertical: true),
        Container(
          width: 260,
          height: size.height,
          child: Column(
            children: [
              Container(
                height: 65,
                width: 260,
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(_workspaces[_currentIndex].first.name,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 20, child: Utils.online(false)),
                              SizedBox(width: 4),
                              Text(_workspaces[_currentIndex].first.user.name,
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.2)),
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.edit, color: Color(0xFF1C2128), size: 18),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
              Separator(vertical: false),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 15),
                    ..._menus.sublist(0, _showMenus ? _menus.length : 3),
                    _menuSection(_showMenus ? Icons.arrow_upward : Icons.arrow_downward, 'Show more',
                        () => setState(() => _showMenus = !_showMenus)),
                    SizedBox(height: 15),
                    Separator(vertical: false),
                    SizedBox(height: 5),
                    _titleSection(
                        'Channels', () => setState(() => _showChannels = !_showChannels), _showChannels, null),
                    if (_showChannels) ..._channels,
                    SizedBox(height: 5),
                    _titleSection('Direct messages', () => setState(() => _showDMs = !_showDMs), _showDMs, null),
                    if (_showDMs) ..._dms,
                    if (_showDMs) _itemSideMenu(Icons.add, 'Invite People'),
                    SizedBox(height: 15),
                  ],
                ),
              )
            ],
          ),
        ),
        Separator(vertical: true),
        Expanded(child: dmIndex > -1 ? _dmsView(dm) : _channelView(channel)),
      ],
    );
  }

  Widget _searchBarSection() {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[800], width: 0.5),
      ),
      child: Container(
        height: 35,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        child: Text('Jump to...', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _itemSideMenu(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.start))
        ],
      ),
    );
  }

  Widget _channelView(Channel channel) {
    return Column(
      children: [
        Container(
          height: 65,
          child: Row(
            children: [
              if (isMobile)
                GestureDetector(
                  onTap: () => _rightController.reverse(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          channel.private
                              ? Icon(Icons.lock, color: Colors.white, size: 14)
                              : Text('\u0023', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              channel.name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Color(0xFFC7C8CA),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text('${channel.users.length}', style: TextStyle(color: Color(0xFFC7C8CA))),
                          SizedBox(width: 8),
                          Container(height: 12, width: 1, color: Color(0x80C7C8CA)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(channel.topic ?? 'Add a topic',
                                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              if (isMobile)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                ),
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              if (!isMobile) SizedBox(width: 5),
              if (!isMobile) Text('Details', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
              SizedBox(width: 20),
            ],
          ),
        ),
        Separator(vertical: false),
        Expanded(child: _chatView(channel.chats)),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100),
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            decoration: BoxDecoration(
              color: Color(0xFF232529),
              border: Border.all(color: Color(0xFF565856), width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                    maxLines: null,
                    onChanged: (text) => setState(() {}),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message #${channel.name}',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.whatshot, color: Color(0xFFC7C8CA), size: 18),
                      SizedBox(width: 8),
                      Container(width: 1, height: 25, color: Color(0x40C7C8CA)),
                      SizedBox(width: 8),
                      Icon(Icons.format_bold, color: Colors.grey[700], size: 18),
                      SizedBox(width: 8),
                      RotatedBox(quarterTurns: 1, child: Icon(Icons.link, color: Colors.grey[700], size: 18)),
                      SizedBox(width: 8),
                      Icon(Icons.format_list_numbered, color: Colors.grey[700], size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.format_indent_increase, color: Colors.grey[700], size: 18),
                      Expanded(child: SizedBox()),
                      Icon(Icons.mood, color: Colors.grey[300], size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.attach_file, color: Colors.grey[300], size: 18),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _textController.text.isNotEmpty
                            ? () {
                                setState(() {
                                  _workspaces[_currentIndex]
                                      .first
                                      .channels[_workspaces[_currentIndex].first.currentChannel]
                                      .chats
                                      .add(Chat()
                                        ..user = Utils.userLogged
                                        ..text = _textController.text
                                        ..timestamp = DateTime.now().millisecondsSinceEpoch);
                                  _textController.clear();
                                });
                              }
                            : null,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: _textController.text.isNotEmpty ? Color(0xFF007A5A) : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(child: Icon(Icons.send, color: Color(0xFFC7C8CA), size: 16)),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _dmsView(DM dm) {
    return Column(
      children: [
        Container(
          height: 65,
          child: Row(
            children: [
              if (isMobile)
                GestureDetector(
                  onTap: () => _rightController.reverse(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          dm.user.online ? Utils.online(false) : Utils.offline(false),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              dm.user.name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      if (dm.user.status != null)
                        Row(
                          children: [
                            Text(dm.user.status,
                                style: TextStyle(height: 1.2), maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (dm.user.description != null) SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                dm.user.description ?? '',
                                style: TextStyle(color: Colors.grey, height: 1.2),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: dm.user.status != null ? 8 : 20),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Icon(Icons.phone, size: 25, color: Colors.grey),
              if (!isMobile) SizedBox(width: 20),
              if (!isMobile) Container(width: 1, height: 30, color: Colors.grey),
              SizedBox(width: 20),
              Icon(
                Icons.info_outline,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              if (!isMobile) SizedBox(width: 5),
              if (!isMobile) Text('Details', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
              SizedBox(width: 20),
            ],
          ),
        ),
        Separator(vertical: false),
        Expanded(child: _chatView(dm.chats)),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100),
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            decoration: BoxDecoration(
              color: Color(0xFF232529),
              border: Border.all(color: Color(0xFF565856), width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                    maxLines: null,
                    onChanged: (text) => setState(() {}),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message #${dm.user.name} ${dm.user.status ?? ''}',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, height: 1.2),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.whatshot, color: Color(0xFFC7C8CA), size: 18),
                      SizedBox(width: 8),
                      Container(width: 1, height: 25, color: Color(0x40C7C8CA)),
                      SizedBox(width: 8),
                      Icon(Icons.format_bold, color: Colors.grey[700], size: 18),
                      SizedBox(width: 8),
                      RotatedBox(quarterTurns: 1, child: Icon(Icons.link, color: Colors.grey[700], size: 18)),
                      SizedBox(width: 8),
                      Icon(Icons.format_list_numbered, color: Colors.grey[700], size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.format_indent_increase, color: Colors.grey[700], size: 18),
                      Expanded(child: SizedBox()),
                      Icon(Icons.mood, color: Colors.grey[300], size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.attach_file, color: Colors.grey[300], size: 18),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _textController.text.isNotEmpty
                            ? () {
                                setState(() {
                                  _workspaces[_currentIndex]
                                      .first
                                      .dms[_workspaces[_currentIndex].first.currentDM]
                                      .chats
                                      .add(Chat()
                                        ..user = Utils.userLogged
                                        ..text = _textController.text
                                        ..timestamp = DateTime.now().millisecondsSinceEpoch);
                                  _textController.clear();
                                });
                              }
                            : null,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: _textController.text.isNotEmpty ? Color(0xFF007A5A) : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(child: Icon(Icons.send, color: Color(0xFFC7C8CA), size: 16)),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _chatView(List<Chat> chats) {
    chats.sort((first, second) => second.timestamp.compareTo(first.timestamp));
    return ListView.builder(
      reverse: true,
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        final chat = chats[index];
        var sameUser = index + 1 <= chats.length - 1 && chats[index + 1].user.id == chat.user.id;
        return ChatItem(chat: chat, sameUser: sameUser);
      },
      itemCount: chats.length,
    );
  }

  static Widget _menuSection(IconData icon, String text, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            SizedBox(width: 15),
            Container(
              height: 30,
              child: Icon(icon, color: Color(0xFFC7C8CA), size: 15),
            ),
            SizedBox(width: 10),
            Container(
              child: Text(text, style: TextStyle(color: Color(0xFFC7C8CA), fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleSection(String title, GestureTapCallback toggleTap, bool show, GestureTapCallback addTap) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SizedBox(width: 10),
          GestureDetector(
            onTap: toggleTap,
            child: Container(
              height: 40,
              child: Icon(show ? Icons.arrow_drop_down : Icons.arrow_right, color: Color(0xFFC7C8CA), size: 20),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Text(title, style: TextStyle(color: Color(0xFFC7C8CA), fontSize: 14)),
            ),
          ),
          InkWell(
            onTap: addTap,
            child: Icon(Icons.add, color: Color(0xFFC7C8CA), size: 20),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  _initChannels(bool clear) {
    if (clear) _channels.clear();
    _workspaces[_currentIndex].first.channels.asMap().forEach((index, channel) {
      setState(() => _channels
          .add(ChannelItem(key: GlobalKey<ChannelItemState>(), channel: channel, index: index, clickItem: _chanlItem)));
    });
  }

  _initDMs(bool clear) {
    if (clear) _dms.clear();
    _workspaces[_currentIndex].first.dms.asMap().forEach((index, dm) {
      setState(() => _dms.add(DMUserItem(
          key: GlobalKey<DMUserItemState>(),
          user: dm.user,
          index: index,
          closeItem: _closeItem,
          chatListener: _chatsItem)));
    });
  }
}

class ChatItem extends StatefulWidget {
  final Chat chat;
  final bool sameUser;

  const ChatItem({Key key, this.chat, this.sameUser}) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  var _hover = false;
  var text = '';
  var url = '';

  @override
  Widget build(BuildContext context) {
    text = widget.chat.text;
    final matches = Utils.regexImageUrl.allMatches(widget.chat.text);
    if (matches.length > 0) {
      url = widget.chat.text.substring(matches.first.start, matches.first.end);
      text = widget.chat.text.substring(0, matches.first.start);
    } else {
      url = '';
    }
    return MouseRegion(
      onHover: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            color: _hover ? Colors.white.withOpacity(0.05) : Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: widget.sameUser ? 5 : 10, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.sameUser)
                    Container(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(widget.chat.user.avatar, fit: BoxFit.cover),
                      ),
                    ),
                  SizedBox(width: 8 + (widget.sameUser ? 40.0 : 0.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.sameUser)
                          Row(
                            children: [
                              Text(widget.chat.user.name,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              SizedBox(width: 5),
                              if (widget.chat.user.status != null)
                                Text(widget.chat.user.status,
                                    style: TextStyle(color: Colors.white, height: 1.2),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        if (!widget.sameUser) SizedBox(height: 6),
                        if (text.isNotEmpty) Text(text, style: TextStyle(color: Colors.grey[400])),
                        if (url.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  url.split('/')[url.split('/').length - 1],
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 400),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(url),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_hover)
            Positioned(
              top: 0,
              right: 20,
              child: Transform(
                transform: Matrix4.identity()..translate(0, -15),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF232529),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[700], width: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {},
                              onHover: (_) {},
                              child: Tooltip(
                                message: 'Add reaction',
                                verticalOffset: -55,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700], width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  child: Icon(Icons.insert_emoticon, color: Colors.grey, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            InkWell(
                              onTap: () {},
                              onHover: (_) {},
                              child: Tooltip(
                                message: 'Start a thread',
                                verticalOffset: -55,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700], width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  child: Icon(Icons.chat, color: Colors.grey, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            InkWell(
                              onTap: () {},
                              onHover: (_) {},
                              child: Tooltip(
                                message: 'Share a message...',
                                verticalOffset: -55,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700], width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  child: Icon(Icons.forward, color: Colors.grey, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            InkWell(
                              onTap: () {},
                              onHover: (_) {},
                              child: Tooltip(
                                message: 'Save',
                                verticalOffset: -55,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700], width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  child: Icon(Icons.bookmark_border, color: Colors.grey, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            InkWell(
                              onTap: () {},
                              onHover: (_) {},
                              child: Tooltip(
                                message: 'More actions',
                                verticalOffset: -55,
                                textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[700], width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  child: Icon(Icons.more_vert, color: Colors.grey, size: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ChannelItem extends StatefulWidget {
  final int index;
  final Channel channel;
  final ClickItem clickItem;

  const ChannelItem({Key key, this.index, this.channel, this.clickItem}) : super(key: key);

  @override
  ChannelItemState createState() => ChannelItemState();
}

class ChannelItemState extends State<ChannelItem> {
  var _selected = false;

  void selected(bool value) => setState(() => _selected = value);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.clickItem(widget.index),
      child: Container(
        color: _selected ? Color(0xFF1064A3) : Colors.transparent,
        height: 30,
        child: Row(
          children: [
            SizedBox(width: 20),
            Container(
              height: 30,
              child: Icon(widget.channel.private ? Icons.lock : IconData(0x23, fontFamily: 'Roboto'),
                  color: _selected ? Colors.white : Color(0xAAC7C8CA), size: 15),
            ),
            SizedBox(width: 8),
            Container(
              child: Text(widget.channel.name,
                  style: TextStyle(color: _selected ? Colors.white : Color(0xAAC7C8CA), fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class DMUserItem extends StatefulWidget {
  final User user;
  final int index;
  final ClickItem chatListener;
  final ClickItem closeItem;

  const DMUserItem({Key key, this.user, this.index, this.chatListener, this.closeItem}) : super(key: key);

  @override
  DMUserItemState createState() => DMUserItemState();
}

class DMUserItemState extends State<DMUserItem> {
  var _selected = false;

  void selected(bool value) => setState(() => _selected = value);

  var _index;

  void index(int index) => setState(() => _index = index);

  var _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: () => widget.chatListener(_index == null ? widget.index : _index),
        child: Container(
          color: _selected ? Color(0xFF1064A3) : Colors.transparent,
          height: 30,
          child: Row(
            children: [
              SizedBox(width: 20),
              widget.user.online ? Utils.online(_selected) : Utils.offline(_selected),
              SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text(widget.user.name,
                        style:
                            TextStyle(color: _selected ? Colors.white : Color(0xAAC7C8CA), fontSize: 14, height: 1.2)),
                    if (Utils.userLogged.id == widget.user.id)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('(you)', style: TextStyle(color: Colors.white.withOpacity(0.4))),
                      ),
                    if (widget.user.status != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          widget.user.status,
                          style: TextStyle(color: Colors.grey[700], height: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Opacity(
                opacity: _hover ? 1 : 0,
                child: InkWell(
                  onTap: () => widget.closeItem(_index == null ? widget.index : _index),
                  child: Icon(Icons.clear, color: Color(0xFFC7C8CA), size: 18),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkspaceItem extends StatefulWidget {
  final int index;
  final bool selected;
  final Workspace workspace;
  final ClickItem clickItem;

  const WorkspaceItem({Key key, this.index, this.selected = false, this.workspace, this.clickItem}) : super(key: key);

  @override
  WorkspaceItemState createState() => WorkspaceItemState();
}

class WorkspaceItemState extends State<WorkspaceItem> {
  var _selected = false;

  void selected(bool value) => setState(() => _selected = value);

  var _hover = false;

  @override
  void initState() {
    super.initState();
    if (mounted) Future.microtask(() => setState(() => _selected = widget.selected));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.clickItem(widget.index),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            MouseRegion(
              onHover: (_) => setState(() => _hover = true),
              onExit: (_) => setState(() => _hover = false),
              child: Container(
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: _selected ? Colors.white : _hover ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      width: 3),
                ),
                child: widget.workspace.logo == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            widget.workspace.name.substring(0, 1),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(widget.workspace.logo),
                      ),
              ),
            ),
            if (!_selected)
              Container(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Container(
                      width: 12,
                      height: 12,
                      color: Color(0xFE1D2229),
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: Container(
                          width: 12,
                          height: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  final bool vertical;

  const Separator({Key key, @required this.vertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: vertical ? 1 : size.width,
      height: vertical ? size.height : 1,
      color: Color(0xFF34393F),
    );
  }
}

typedef ClickItem(int index);
typedef ChatListener<T>(T item);

class Utils {
  static final userLogged = User()
    ..id = 1
    ..name = 'Mariano Zorrilla'
    ..status = '💙'
    ..description = 'I clone apps!'
    ..avatar = 'https://pbs.twimg.com/profile_images/1222274976415281153/TVSI4DIx_400x400.jpg'
    ..online = true;

  static final simon = User()
    ..id = 2
    ..name = 'Simon'
    ..status = '🇬🇧'
    ..description = 'Admin https://github.com/slightfoot'
    ..avatar = 'https://pbs.twimg.com/profile_images/1017532253394624513/LgFqlJ4U_400x400.jpg'
    ..online = true;

  static final scott = User()
    ..id = 3
    ..name = 'Scott'
    ..avatar = 'https://pbs.twimg.com/profile_images/1050017782811713536/6tKkzfsI_400x400.jpg'
    ..online = true;

  static final nash = User()
    ..id = 4
    ..name = 'Nash Ramdial'
    ..avatar = 'https://pbs.twimg.com/profile_images/1180232818779021312/xlZcHrlQ_400x400.jpg'
    ..online = false;

  static final chris = User()
    ..id = 5
    ..name = 'Chris Sells'
    ..avatar = 'https://pbs.twimg.com/profile_images/1660905119/vikingme128x128_400x400.jpg'
    ..online = false;

  static final nilay = User()
    ..id = 6
    ..name = 'Nilay'
    ..avatar = 'https://pbs.twimg.com/profile_images/1132357550379134976/tRQLk7Je_400x400.jpg'
    ..online = false;

  static final tim = User()
    ..id = 6
    ..name = 'Tim Sneath'
    ..avatar = 'https://pbs.twimg.com/profile_images/653618067084218368/XlQA-oRl.jpg'
    ..online = true;

  static final ariel = User()
    ..id = 7
    ..name = 'Ariel Viera'
    ..status = '🇦🇷'
    ..avatar = 'https://pbs.twimg.com/profile_images/1204953056686809089/2wwFUZNZ_400x400.jpg'
    ..online = true;

  static final martin = User()
    ..id = 8
    ..name = 'Martin Aguinis'
    ..status = '🇦🇷'
    ..avatar = 'https://pbs.twimg.com/profile_images/1139005628846878721/lSg5Loq4_400x400.jpg'
    ..online = true;

  static final List<User> allUsers = [userLogged, chris, martin, ariel, nilay, simon, scott, tim, nash];

  static IconData get at => IconData(0x40, fontFamily: 'Roboto');

  static IconData get hash => IconData(0x23, fontFamily: 'Roboto');

  static Text online(bool selected) =>
      Text('\u25CF', style: TextStyle(color: selected ? Colors.grey[300] : Color(0xFF93E865), fontSize: 20));

  static Text offline(bool selected) =>
      Text('\u25CB', style: TextStyle(color: selected ? Colors.grey[300] : Colors.grey, fontSize: 20));

  static final RegExp regexpEmoji =
      RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  static final RegExp regexAlphaNum = RegExp(r'[a-zA-Z0-9]');
  static final RegExp regexImageUrl = RegExp(r'(https?:\/\/.*\.(?:png|jpg|gif))');

  static bool singleEmoji(Chat chat) {
    if (Utils.regexAlphaNum.hasMatch(chat.text)) {
      return false;
    } else {
      return Utils.regexpEmoji.hasMatch(chat.text);
    }
  }
}

class Tuple<F, S> {
  F first;
  S second;

  Tuple(this.first, this.second);
}

class Workspace {
  String name;
  String url;
  String logo;
  User user;
  List<User> users;
  List<Channel> channels;
  List<DM> dms;
  int currentChannel = 0;
  int currentDM = -1;
}

class User {
  int id;
  String name;
  String status;
  String description;
  String avatar;
  bool online;
}

class Channel extends BaseChat {
  String name;
  String topic;
  List<User> users;
  bool private;
}

class DM extends BaseChat {
  User user;
}

class Chat {
  int timestamp;
  String text;
  User user;
}

abstract class BaseChat {
  List<Chat> chats;
}


