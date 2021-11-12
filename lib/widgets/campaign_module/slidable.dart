import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class SliderWidget extends StatefulWidget {
  final Widget back;
  final Widget done;
  final Widget status;
  final Widget slide;
  final double radius;
  const SliderWidget({
    Key? key,
    required this.radius,
    required this.done,
    required this.status,
    required this.back,
    required this.slide,
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final PageController controller = PageController(initialPage: 0);
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  GlobalKey _toolTipKey = GlobalKey();
  late double radiuss = widget.radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
      height: 900,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        physics: ClampingScrollPhysics(),
        children: [firstPage(), secondPage(), thirdPage()],
      ),
    );
  }

  Widget firstPage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Create Campaign',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color(0xff65BFB8))),
          SizedBox(
            height: 10,
          ),
          widget.status,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Number of Seeds'),
                    SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        final dynamic _toolTip = _toolTipKey.currentState;
                        _toolTip.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        key: _toolTipKey,
                        message:
                            "Number of seeds will determine the radius of the Campaign.",
                        child: Icon(
                          Icons.help_rounded,
                          color: Colors.black.withOpacity(0.7),
                          size: 13,
                        ),
                      ),
                    )
                  ]),
              widget.slide
            ],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                controller.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff65BFB8),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget secondPage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('What the campaign all about...',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color(0xff65BFB8))),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Campaign Name',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.299),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 50,
                child: TextField(
                  controller: campaignNameController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setCampaignName(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.299),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 200,
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setDescription(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                controller.animateToPage(2,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              });
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff65BFB8),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget thirdPage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('City'),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 200,
                height: 50,
                child: TextField(
                  controller: cityController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setCityName(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Address'),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 200,
                height: 50,
                child: TextField(
                  controller: addressController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setAddress(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date Start'),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 200,
                height: 50,
                child: TextField(
                  onChanged: (value) =>
                      {context.read(campaignProvider).setStartingDate(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          widget.done
        ],
      ),
    );
  }
}
