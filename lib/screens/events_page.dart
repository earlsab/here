import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 228, 228, 228), 
     body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Events",
                      style: const TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff4682a9),
                      height: 44/30,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Viewing as SU/CCS (Member)",
                      style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4682a9),
                      fontStyle: FontStyle.italic,
                      height: 14/15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                
                const Spacer(), // For space between greeting and buttons
              
                Column( // Notifications button
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Color.fromARGB(255, 41, 112, 150),
                        size: 30,),
                    ),
                  ],
                ),
                Column( // Settings button
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.settings_outlined,
                        color: Color.fromARGB(255, 41, 112, 150),
                        size: 30,),
                    ),
                  ],
                )
              ]
            ),

            SizedBox(
              height: 20,
            ),
            
            Divider(
              color: Color.fromARGB(255, 170, 181, 200)
            ),
            
            Row( // Ongoing Events
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ongoing events",
                          style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff153d58),
                      height: 38/20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                const Spacer(),

                Column( //Plus button
                  children: [
                    Text( 
                      "+",
                          style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 32,
                      color: Color(0xff153d58),
                      height: 38/20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )
              ]
            )
          ]
        ),
      )
     )
    );
  }
}