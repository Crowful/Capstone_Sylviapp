import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/theme&language_notifier.dart';
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
  var selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now())
      setState(() {
        selectedDate = picked;
      });
  }

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
        color: Theme.of(context).cardColor,
        shape: BoxShape.rectangle,
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
          Row(children: [
            widget.back,
            SizedBox(
              width: 10,
            ),
            Text('Create Campaign',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xff65BFB8))),
          ]),
          SizedBox(
            height: 10,
          ),
          Text('Slide to see the requirements of your desired campaign',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black54)),
          SizedBox(
            height: 20,
          ),
          widget.status,
          SizedBox(
            height: 30,
          ),
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
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
          SizedBox(
            height: 10,
          ),
          Text(
              'Your campaign will not go directly to the active campaigns, it wil review first by sylviapp. Enjoy creating campaign organizer !',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black54)),
          SizedBox(
            height: 20,
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
          ),
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
          Text('About the Campaign',
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
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                child: TextField(
                  maxLines: 5,
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
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
          Text('Campaign Information',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color(0xff65BFB8))),
          SizedBox(
            height: 10,
          ),
          Text(
              'Input the City of the campaign, the meetup address and the desired date you want the campaign to start',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black54)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
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
            height: 10,
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
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date Start'),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context).whenComplete(() {
                    if (selectedDate != null) {
                      context
                          .read(campaignProvider)
                          .setStartingDate(selectedDate.toString());
                    } else {
                      Fluttertoast.showToast(msg: 'you did not select a date');
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: 200,
                  height: 50,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.date_range)),
                  ),
                  // child: TextField(
                  //   onChanged: (value) =>
                  //       {context.read(campaignProvider).setStartingDate(value)},
                  //   decoration: InputDecoration(
                  //       focusColor: Color(0xff65BFB8),
                  //       contentPadding: EdgeInsets.all(15),
                  //       border: InputBorder.none),
                  // ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          widget.done
        ],
      ),
    );
  }
}
