import 'package:base/res/values/base_colors.dart';
import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;

  ContainerCard({ this.image, this.title, this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:BaseColors.of(context).commonWhiteColor,

      ),
      child: Row(
        children: [Image.asset(image,),
          SizedBox(width : 8.0),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Text(title, style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold,color: BaseColors.of(context).blackColor,)),
                    Text(subtitle, style: TextStyle(fontSize: 12.0,color: BaseColors.of(context).textGreyColor,)),


                  ],
                ),
                Icon(icon,
                  color: BaseColors.of(context).blackColor,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}