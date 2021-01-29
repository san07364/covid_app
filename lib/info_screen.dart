import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/coronadr.svg",
              textTop: "Get to know",
              textBottom: "About Covid-19.",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Symptoms",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom1.png",
                            title: "Muscle Pain",
                            isActive: true,
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom2.png",
                            title: "Runny Nose",
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom3.png",
                            title: "Headache",
                            isActive: true,
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom4.png",
                            title: "Chest Pain",
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom5.png",
                            title: "Dry Cough",
                            isActive: true,
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                        Container(
                          child: SymptomCard(
                            image: "assets/images/symptom6.png",
                            title: "Fever",
                          ),
                          margin: EdgeInsets.all(5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Prevention", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  PreventCard(
                    text:
                        "Maintain a distance of approximately 6 feet from others in public places.",
                    image: "assets/images/prevention1.png",
                    title: "SOCIAL DISTANCING",
                  ),
                  PreventCard(
                    text:
                        "Clean your hands often. Use soap and water, or an alcohol-based hand rub.",
                    image: "assets/images/prevention2.png",
                    title: "WASH YOUR HANDS",
                  ),
                  PreventCard(
                    text: "Stay home if you feel unwell.",
                    image: "assets/images/prevention3.png",
                    title: "STAY AT HOME",
                  ),
                  PreventCard(
                    text:
                        "Keeping your house tidy gives you a safe space from infections.",
                    image: "assets/images/prevention4.png",
                    title: "CLEAN AND DISINFECT",
                  ),
                  PreventCard(
                    text:
                        "Wear facemask to reduce the risk of serving as the source of disease and also reduce the risk of getting sick.",
                    image: "assets/images/prevention5.png",
                    title: "WEAR FACEMASK",
                  ),
                  PreventCard(
                    text:
                        "Cover your nose and mouth with your bent elbow or a tissue when you cough or sneeze.",
                    image: "assets/images/prevention6.png",
                    title: "COVER COUGH",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
