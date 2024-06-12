import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';

class AnswerQuestionItem extends StatelessWidget{
  // Faqs faqs;
  var question;
  var answer;
  AnswerQuestionItem({required this.question,required this.answer});

  @override
  build(BuildContext context) {
    return ExpandableNotifier(
      child: Container(
        margin: EdgeInsetsDirectional.all(1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.MainGoku,
            width: 1,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(1.h),
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    hasIcon: true,
                    iconPlacement: ExpandablePanelIconPlacement.right,
                    iconColor: Colors.black,
                    collapseIcon: Icons.keyboard_arrow_up_outlined,
                    expandIcon: Icons.keyboard_arrow_down_outlined,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                    padding:  EdgeInsets.all(1.h),
                    child: Row(
                      children: [
                        Text(
                          question??"",
                          style:  TextStyle(fontSize: 12.sp,
                              fontFamily: 'alexandria_regular',
                              fontWeight: FontWeight.w300,
                              color: MyColors.Dark),
                        ),
                      ],
                    ),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var _ in Iterable.generate(1))
                        Padding(
                            padding:  EdgeInsets.only(bottom: 1.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 2,
                                  color: MyColors.MainGoku,
                                ),
                                SizedBox(height: 1.h,),
                                Text(answer??"",
                                  style:  TextStyle(fontSize: 12.sp,
                                      fontFamily: 'alexandria_regular',
                                      fontWeight: FontWeight.w300,
                                      color: MyColors.textColor),)
                              ],
                            )
                          //Text(answer!,),
                        ),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding:  EdgeInsets.only(
                        left: 1.h,
                        right: 1.h,
                        bottom: 1.h,
                      ),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}