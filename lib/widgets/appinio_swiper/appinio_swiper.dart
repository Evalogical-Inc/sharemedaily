// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quotify/config/constants/colors.dart';
// import 'package:quotify/config/constants/enums/quote_actions.dart';
// import 'package:quotify/widgets/appinio_swiper/controllerts.dart';
// import 'package:quotify/widgets/appinio_swiper/enums.dart';
// export 'package:quotify/widgets/appinio_swiper/enums.dart';
// import 'package:quotify/widgets/appinio_swiper/types.dart';
// import 'package:quotify/widgets/appinio_swiper/swiper_provider.dart';
// import 'package:screenshot/screenshot.dart';

// // import 'package:appinio_swiper/appinio_swiper.dart';

// class AppinioSwiper extends StatefulWidget {
//   /// widget builder for creating cards
//   final CardsBuilder cardsBuilder;

//   ///cards count
//   final int cardsCount;

//   ///background cards count
//   final int backgroundCardsCount;

//   /// controller to trigger unswipe action
//   final AppinioSwiperController? controller;

//   /// duration of every animation
//   final Duration duration;

//   /// add listener to check when the card is swiping
//   final void Function(AppinioSwiperDirection direction)? onSwiping;

//   /// padding of the swiper
//   final EdgeInsetsGeometry padding;

//   /// maximum angle the card reaches while swiping
//   final double maxAngle;

//   /// set to true if verticalSwipe should be disabled, exception: triggered from the outside
//   final AppinioSwipeOptions swipeOptions;

//   /// threshold from which the card is swiped away
//   final int threshold;

//   /// set to true if swiping should be disabled, exception: triggered from the outside
//   final bool isDisabled;

//   /// set to false if unswipe should be disabled
//   final bool allowUnswipe;

//   /// set to true if you want to loop the items
//   final bool loop;

//   /// set to true if the user can unswipe as many cards as possible
//   final bool unlimitedUnswipe;

//   /// function that gets called with the new index and detected swipe direction when the user swiped or swipe is triggered by controller
//   final OnSwipe? onSwipe;

//   /// function that gets called when there is no widget left to be swiped away
//   final VoidCallback? onEnd;

//   /// function that gets triggered when the swiper is disabled
//   final VoidCallback? onTapDisabled;

//   /// function that gets called with the boolean true when the last card gets unswiped and with the boolean false when there is no card to unswipe
//   final OnUnSwipe? unswipe;

//   /// direction in which the card gets swiped when triggered by controller, default set to right
//   final AppinioSwiperDirection direction;

//   final QuoteActions? quoteAction;

//   final ScreenshotController screenshotController;

//   const AppinioSwiper(
//       {Key? key,
//       required this.cardsBuilder,
//       required this.cardsCount,
//       this.controller,
//       this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//       this.duration = const Duration(milliseconds: 200),
//       this.maxAngle = 30,
//       this.threshold = 50,
//       this.backgroundCardsCount = 1,
//       this.isDisabled = false,
//       this.loop = false,
//       this.swipeOptions = const AppinioSwipeOptions.all(),
//       this.allowUnswipe = true,
//       this.unlimitedUnswipe = false,
//       this.onTapDisabled,
//       this.onSwipe,
//       this.onSwiping,
//       this.onEnd,
//       this.unswipe,
//       this.direction = AppinioSwiperDirection.right,
//       this.quoteAction,
//       required this.screenshotController})
//       : assert(maxAngle >= 0 && maxAngle <= 360),
//         assert(threshold >= 1 && threshold <= 100),
//         assert(direction != AppinioSwiperDirection.none),
//         super(key: key);

//   @override
//   State createState() => _AppinioSwiperState();
// }

// class _AppinioSwiperState extends State<AppinioSwiper>
//     with SingleTickerProviderStateMixin {
//   double _left = 0;
//   double _top = 0;
//   double _total = 0;
//   double _angle = 0;
//   double _maxAngle = 0;
//   double _scale = 0.9;
//   double _difference = 40;
//   final double _backgroundCardsDifference = 40;
//   final double _backgroundCardsScaleDifference = 0.1;
//   int currentIndex = 0;

//   int _swipeType = 0; // 1 = swipe, 2 = unswipe, 3 = goBack
//   bool _tapOnTop = true; //position of starting drag point on card

//   late AnimationController _animationController;
//   late Animation<double> _leftAnimation;
//   late Animation<double> _topAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _differenceAnimation;
//   late Animation<double> _unSwipeLeftAnimation;
//   late Animation<double> _unSwipeTopAnimation;
//   final Map<int, AppinioSwiperDirection> _swiperMemo =
//       {}; //keep track of the swiped items to unswipe from the same direction

//   bool _unSwiped =
//       false; // set this to true when user swipe the card and false when they unswipe to make sure they unswipe only once

//   bool _horizontal = false;
//   bool _isUnswiping = false;
//   int _swipedDirectionVertical = 0; //-1 left, 1 right
//   int _swipedDirectionHorizontal = 0; //-1 bottom, 1 top
//   late ScreenshotController screenshotController;
//   AppinioSwiperDirection detectedDirection = AppinioSwiperDirection.none;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.controller != null) {
//       widget.controller!
//         //swipe widget from the outside
//         ..addListener(() {
//           if (widget.controller!.state == AppinioSwiperState.swipe) {
//             if (currentIndex < widget.cardsCount) {
//               switch (widget.direction) {
//                 case AppinioSwiperDirection.right:
//                   _swipeHorizontal(context);
//                   break;
//                 case AppinioSwiperDirection.left:
//                   _swipeHorizontal(context);
//                   break;
//                 case AppinioSwiperDirection.top:
//                   _swipeVertical(context);
//                   break;
//                 case AppinioSwiperDirection.bottom:
//                   _swipeVertical(context);
//                   break;
//                 case AppinioSwiperDirection.none:
//                   break;
//               }
//               _animationController.forward();
//             }
//           }
//         })
//         //swipe widget left from the outside
//         ..addListener(() {
//           if (widget.controller!.state == AppinioSwiperState.swipeLeft) {
//             if (currentIndex < widget.cardsCount) {
//               _left = -1;
//               _swipeHorizontal(context);
//               _animationController.forward();
//             }
//           }
//         })
//         //swipe widget right from the outside
//         ..addListener(() {
//           if (widget.controller!.state == AppinioSwiperState.swipeRight) {
//             if (currentIndex < widget.cardsCount) {
//               _left = widget.threshold + 1;
//               _swipeHorizontal(context);
//               _animationController.forward();
//             }
//           }
//         })
//         //swipe widget up from the outside
//         ..addListener(() {
//           if (widget.controller!.state == AppinioSwiperState.swipeUp) {
//             if (currentIndex < widget.cardsCount) {
//               _top = -1;
//               _swipeVertical(context);
//               _animationController.forward();
//             }
//           }
//         })
//         //swipe widget down from the outside
//         ..addListener(() {
//           if (widget.controller!.state == AppinioSwiperState.swipeDown) {
//             if (currentIndex < widget.cardsCount) {
//               _top = widget.threshold + 1;
//               _swipeVertical(context);
//               _animationController.forward();
//             }
//           }
//         })
//         //unswipe widget from the outside
//         ..addListener(() {
//           if (!widget.unlimitedUnswipe && _unSwiped) return;
//           if (widget.controller!.state == AppinioSwiperState.unswipe) {
//             if (widget.allowUnswipe) {
//               if (!_isUnswiping) {
//                 if (currentIndex > 0) {
//                   _unswipe();
//                   widget.unswipe?.call(true);
//                   _animationController.forward();
//                 } else {
//                   widget.unswipe?.call(false);
//                 }
//               }
//             }
//           }
//         });
//     }

//     if (widget.maxAngle > 0) {
//       _maxAngle = widget.maxAngle * (pi / 180);
//     }

//     _animationController =
//         AnimationController(duration: widget.duration, vsync: this);
//     _animationController.addListener(() {
//       //when value of controller changes
//       if (_animationController.status == AnimationStatus.forward) {
//         setState(() {
//           if (_swipeType != 2) {
//             _left = _leftAnimation.value;
//             _top = _topAnimation.value;
//           }
//           if (_swipeType == 2) {
//             _left = _unSwipeLeftAnimation.value;
//             _top = _unSwipeTopAnimation.value;
//           }
//           _scale = _scaleAnimation.value;
//           _difference = _differenceAnimation.value;
//         });
//       }
//     });

//     _animationController.addStatusListener((status) {
//       //when status of controller changes
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           if (_swipeType == 1) {
//             _swiperMemo[currentIndex] = _horizontal
//                 ? (_swipedDirectionHorizontal == 1
//                     ? AppinioSwiperDirection.right
//                     : AppinioSwiperDirection.left)
//                 : (_swipedDirectionVertical == 1
//                     ? AppinioSwiperDirection.top
//                     : AppinioSwiperDirection.bottom);
//             _swipedDirectionHorizontal = 0;
//             _swipedDirectionVertical = 0;
//             _horizontal = false;
//             if (widget.loop) {
//               if (currentIndex < widget.cardsCount - 1) {
//                 currentIndex++;
//               } else {
//                 currentIndex = 0;
//               }
//             } else {
//               currentIndex++;
//             }
//             widget.onSwipe?.call(currentIndex, detectedDirection);
//             if (currentIndex == widget.cardsCount) {
//               widget.onEnd?.call();
//             }
//           } else if (_swipeType == 2) {
//             _isUnswiping = false;
//           }
//           _animationController.reset();
//           _left = 0;
//           _top = 0;
//           _total = 0;
//           _angle = 0;
//           _scale = 0.9;
//           _difference = 40;
//           _swipeType = 0;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _animationController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return Container(
//           padding: widget.padding,
//           child: LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               var deviceSize = MediaQuery.of(context).size;
//               return Stack(
//                 clipBehavior: Clip.none,
//                 fit: StackFit.expand,
//                 children: [
//                   if (widget.loop || currentIndex < widget.cardsCount - 1)
//                     ..._backgroundCards(constraints, deviceSize),
//                   if (currentIndex < widget.cardsCount)
//                     _foregroundItem(
//                         context, constraints, widget.screenshotController)
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   List<Widget> _backgroundCards(BoxConstraints constraints, Size deviceSize) {
//     List<Widget> backgroundCards = [];
//     int i = currentIndex + 1;
//     int j = 1;
//     double difference = _difference;
//     double scale = _scale;
//     while ((i < widget.cardsCount || widget.loop) &&
//         j <= widget.backgroundCardsCount) {
//       backgroundCards
//           .add(_backgroundItem(constraints, i, difference, scale, deviceSize));
//       difference += _backgroundCardsDifference;
//       scale -= _backgroundCardsScaleDifference;
//       i++;
//       j++;
//     }
//     return backgroundCards.reversed.toList();
//   }

//   Widget _backgroundItem(BoxConstraints constraints, int index,
//       double difference, double scale, Size deviceSize) {
//     return Positioned(
//       top: 0,
//       left: -30,
//       right: -30,
//       bottom: 0,
//       child: Container(
//         color: Colors.transparent,
//         child: Transform.scale(
//           scale: 0.9,
//           child: SizedBox(
//             child: widget.cardsBuilder(
//               context,
//               (index % widget.cardsCount),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _foregroundItem(BuildContext context, BoxConstraints constraints,
//       ScreenshotController screenshotController) {
//     final swiperState = Provider.of<SwiperProvider>(context, listen: false);

//     return Positioned(
//       left: _left,
//       top: _top,
//       child: Stack(
//         children: [
//           GestureDetector(
//             child: Transform.rotate(
//               angle: _angle,
//               child: Stack(
//                 children: [
//                   Screenshot(
//                     controller: screenshotController,
//                     child: Container(
//                       constraints: constraints,
//                       child: widget.cardsBuilder(context, currentIndex),
//                     ),
//                   ),
//                   _buildStamp(context)
//                 ],
//               ),
//             ),
//             onTap: () {
//               if (widget.isDisabled) {
//                 widget.onTapDisabled?.call();
//               }
//             },
//             onPanStart: (tapInfo) {
//               if (!widget.isDisabled) {
//                 swiperState.startPosition(tapInfo);
//                 // RenderBox renderBox = context.findRenderObject() as RenderBox;
//                 // Offset position = renderBox.globalToLocal(tapInfo.globalPosition);

//                 // if (position.dy < renderBox.size.height / 2) _tapOnTop = true;
//               }
//             },
//             onPanUpdate: (tapInfo) {
//               if (!widget.isDisabled) {
//                 swiperState.updatePosition(tapInfo);
//                 setState(() {
//                   final swipeOption = widget.swipeOptions;

//                   if (swipeOption.allDirections) {
//                     _left += tapInfo.delta.dx;
//                     _top += tapInfo.delta.dy;
//                   } else if (swipeOption.horizontal) {
//                     _left += tapInfo.delta.dx;
//                   } else if (swipeOption.vertical) {
//                     _top += tapInfo.delta.dy;
//                   } else {
//                     AppinioSwiperDirection direction = _calculateDirection(
//                         top: _top + tapInfo.delta.dy,
//                         left: _left + tapInfo.delta.dx);
//                     if (direction == AppinioSwiperDirection.right &&
//                         swipeOption.right) {
//                       _left += tapInfo.delta.dx;
//                     } else if (direction == AppinioSwiperDirection.left &&
//                         swipeOption.left) {
//                       _left += tapInfo.delta.dx;
//                     } else if (direction == AppinioSwiperDirection.top &&
//                         swipeOption.top) {
//                       _top += tapInfo.delta.dy;
//                     } else if (direction == AppinioSwiperDirection.bottom &&
//                         swipeOption.bottom) {
//                       _top += tapInfo.delta.dy;
//                     }
//                   }

//                   _total = _left + _top;
//                   _calculateAngle();
//                   _calculateScale();
//                   _calculateDifference();
//                 });
//                 _onSwiping();
//               }
//             },
//             onPanEnd: (tapInfo) {
//               if (!widget.isDisabled) {
//                 swiperState.endPosition();
//                 _tapOnTop = true;
//                 _onEndAnimation();
//                 _animationController.forward();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStamp(BuildContext context) {
//     final swiperState = Provider.of<SwiperProvider>(context, listen: false);
//     final action = swiperState.getAction();

//     switch (action) {
//       case QuoteActions.favorite:
//         return Positioned(
//           top: 30,
//           left: 30,
//           child: _stamp(
//             AppColors.green,
//             'LIKE',
//           ),
//         );
//       case QuoteActions.remove:
//         return Positioned(
//           top: 30,
//           right: 30,
//           child: _stamp(
//             Colors.red,
//             'REMOVE',
//           ),
//         );
//       default:
//         return const SizedBox();
//     }
//   }

//   Widget _stamp(Color color, String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: color,
//           width: 2,
//         ),
//       ),
//       child: Text(
//         text,
//         style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
//       ),
//     );
//   }

//   AppinioSwiperDirection _calculateDirection(
//       {required double top, required double left}) {
//     AppinioSwiperDirection direction;
//     if (left < 0) {
//       direction = top < 0
//           ? (left < top
//               ? AppinioSwiperDirection.left
//               : AppinioSwiperDirection.top)
//           : (left.abs() > top
//               ? AppinioSwiperDirection.left
//               : AppinioSwiperDirection.bottom);
//     } else {
//       direction = top < 0
//           ? (left < top.abs()
//               ? AppinioSwiperDirection.top
//               : AppinioSwiperDirection.right)
//           : (left > top
//               ? AppinioSwiperDirection.right
//               : AppinioSwiperDirection.bottom);
//     }
//     return direction;
//   }

//   Future<void> _onSwiping() async {
//     widget.onSwiping?.call(_calculateDirection(top: _top, left: _left));
//   }

//   void _calculateAngle() {
//     if (_angle <= _maxAngle && _angle >= -_maxAngle) {
//       (_tapOnTop == true)
//           ? _angle = (_maxAngle / 100) * (_left / 10)
//           : _angle = (_maxAngle / 100) * (_left / 10) * -1;
//     }
//   }

//   void _calculateScale() {
//     if (_scale <= 1.0 && _scale >= 0.9) {
//       _scale =
//           (_total > 0) ? 0.9 + (_total / 5000) : 0.9 + -1 * (_total / 5000);
//     }
//   }

//   void _calculateDifference() {
//     if (_difference >= 0 && _difference <= _difference) {
//       _difference = (_total > 0) ? 40 - (_total / 10) : 40 + (_total / 10);
//     }
//   }

//   void _onEndAnimation() {
//     if (_left < -widget.threshold || _left > widget.threshold) {
//       _swipeHorizontal(context);
//     } else if (_top < -widget.threshold || _top > widget.threshold) {
//       _swipeVertical(context);
//     } else {
//       _goBack(context);
//     }
//   }

//   //moves the card away to the left or right
//   void _swipeHorizontal(BuildContext context) {
//     _unSwiped = false;
//     setState(() {
//       _swipeType = 1;
//       _leftAnimation = Tween<double>(
//         begin: _left,
//         end: (_left == 0)
//             ? (widget.direction == AppinioSwiperDirection.right)
//                 ? MediaQuery.of(context).size.width
//                 : -MediaQuery.of(context).size.width
//             : (_left > widget.threshold)
//                 ? MediaQuery.of(context).size.width
//                 : -MediaQuery.of(context).size.width,
//       ).animate(_animationController);
//       _topAnimation = Tween<double>(
//         begin: _top,
//         end: _top + _top,
//       ).animate(_animationController);
//       _scaleAnimation = Tween<double>(
//         begin: _scale,
//         end: 1.0,
//       ).animate(_animationController);
//       _differenceAnimation = Tween<double>(
//         begin: _difference,
//         end: 0,
//       ).animate(_animationController);
//     });
//     if (_left > widget.threshold ||
//         _left == 0 && widget.direction == AppinioSwiperDirection.right) {
//       _swipedDirectionHorizontal = 1;
//       detectedDirection = AppinioSwiperDirection.right;
//     } else {
//       _swipedDirectionHorizontal = -1;
//       detectedDirection = AppinioSwiperDirection.left;
//     }
//     (_top <= 0) ? _swipedDirectionVertical = 1 : _swipedDirectionVertical = -1;
//     _horizontal = true;
//   }

//   //moves the card away to the top or bottom
//   void _swipeVertical(BuildContext context) {
//     _unSwiped = false;
//     setState(() {
//       _swipeType = 1;
//       _leftAnimation = Tween<double>(
//         begin: _left,
//         end: _left + _left,
//       ).animate(_animationController);
//       _topAnimation = Tween<double>(
//         begin: _top,
//         end: (_top == 0)
//             ? (widget.direction == AppinioSwiperDirection.bottom)
//                 ? MediaQuery.of(context).size.height
//                 : -MediaQuery.of(context).size.height
//             : (_top > widget.threshold)
//                 ? MediaQuery.of(context).size.height
//                 : -MediaQuery.of(context).size.height,
//       ).animate(_animationController);
//       _scaleAnimation = Tween<double>(
//         begin: _scale,
//         end: 1.0,
//       ).animate(_animationController);
//       _differenceAnimation = Tween<double>(
//         begin: _difference,
//         end: 0,
//       ).animate(_animationController);
//     });
//     if (_top > widget.threshold ||
//         _top == 0 && widget.direction == AppinioSwiperDirection.bottom) {
//       _swipedDirectionVertical = -1;
//       detectedDirection = AppinioSwiperDirection.bottom;
//     } else {
//       _swipedDirectionVertical = 1;
//       detectedDirection = AppinioSwiperDirection.top;
//     }
//     (_left >= 0)
//         ? _swipedDirectionHorizontal = 1
//         : _swipedDirectionHorizontal = -1;
//   }

//   //moves the card back to starting position
//   void _goBack(BuildContext context) {
//     setState(() {
//       _swipeType = 3;
//       _leftAnimation = Tween<double>(
//         begin: _left,
//         end: 0,
//       ).animate(_animationController);
//       _topAnimation = Tween<double>(
//         begin: _top,
//         end: 0,
//       ).animate(_animationController);
//       _scaleAnimation = Tween<double>(
//         begin: _scale,
//         end: 0.9,
//       ).animate(_animationController);
//       _differenceAnimation = Tween<double>(
//         begin: _difference,
//         end: 40,
//       ).animate(_animationController);
//     });
//   }

//   //unswipe the card: brings back the last card that was swiped away
//   void _unswipe() {
//     _unSwiped = true;
//     _isUnswiping = true;
//     if (widget.loop) {
//       if (currentIndex == 0) {
//         currentIndex = widget.cardsCount - 1;
//       } else {
//         currentIndex--;
//       }
//     } else {
//       if (currentIndex > 0) {
//         currentIndex--;
//       }
//     }
//     _swipeType = 2;
//     //unSwipe horizontal
//     if (_swiperMemo[currentIndex] == AppinioSwiperDirection.right ||
//         _swiperMemo[currentIndex] == AppinioSwiperDirection.left) {
//       _unSwipeLeftAnimation = Tween<double>(
//         begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.right)
//             ? MediaQuery.of(context).size.width
//             : -MediaQuery.of(context).size.width,
//         end: 0,
//       ).animate(_animationController);
//       _unSwipeTopAnimation = Tween<double>(
//         begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.top)
//             ? -MediaQuery.of(context).size.height / 4
//             : MediaQuery.of(context).size.height / 4,
//         end: 0,
//       ).animate(_animationController);
//       _scaleAnimation = Tween<double>(
//         begin: 1.0,
//         end: _scale,
//       ).animate(_animationController);
//       _differenceAnimation = Tween<double>(
//         begin: 0,
//         end: _difference,
//       ).animate(_animationController);
//     }
//     //unSwipe vertical
//     if (_swiperMemo[currentIndex] == AppinioSwiperDirection.top ||
//         _swiperMemo[currentIndex] == AppinioSwiperDirection.bottom) {
//       _unSwipeLeftAnimation = Tween<double>(
//         begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.right)
//             ? MediaQuery.of(context).size.width / 4
//             : -MediaQuery.of(context).size.width / 4,
//         end: 0,
//       ).animate(_animationController);
//       _unSwipeTopAnimation = Tween<double>(
//         begin: (_swiperMemo[currentIndex] == AppinioSwiperDirection.top)
//             ? -MediaQuery.of(context).size.height
//             : MediaQuery.of(context).size.height,
//         end: 0,
//       ).animate(_animationController);
//       _scaleAnimation = Tween<double>(
//         begin: 1.0,
//         end: _scale,
//       ).animate(_animationController);
//       _differenceAnimation = Tween<double>(
//         begin: 0,
//         end: _difference,
//       ).animate(_animationController);
//     }

//     setState(() {});
//   }
// }
