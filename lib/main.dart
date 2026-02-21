import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const AarohiApp());
}

class AarohiApp extends StatelessWidget {
  const AarohiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aarohi",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ProfileSetupPage(),
    );
  }
}

////////////////////////////////////////////////////////////
/// USER MODEL
////////////////////////////////////////////////////////////

class UserModel {
  String name;
  String bio;
  String skills;
  String startupIdea;
  String location;
  String experience;
  String role;

  UserModel({
    required this.name,
    required this.bio,
    required this.skills,
    required this.startupIdea,
    required this.location,
    required this.experience,
    required this.role,
  });
}

////////////////////////////////////////////////////////////
/// PROFILE SETUP PAGE
////////////////////////////////////////////////////////////

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final name = TextEditingController();
  final bio = TextEditingController();
  final skills = TextEditingController();
  final idea = TextEditingController();
  final location = TextEditingController();
  String experience = "Beginner";
  String role = "Normal User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Your Entrepreneur Profile"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildField("Full Name", name),
            buildField("Bio", bio),
            buildField("Skills (comma separated)", skills),
            buildField("Startup Idea", idea),
            buildField("Location", location),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: experience,
              items: ["Beginner", "Intermediate", "Experienced"]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => experience = val!),
              decoration: const InputDecoration(labelText: "Experience Level"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: role,
              items: ["Normal User", "VIP User"]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => role = val!),
              decoration: const InputDecoration(labelText: "Account Type"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber),
              onPressed: () {
                UserModel user = UserModel(
                  name: name.text,
                  bio: bio.text,
                  skills: skills.text,
                  startupIdea: idea.text,
                  location: location.text,
                  experience: experience,
                  role: role,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HomePage(user: user)),
                );
              },
              child: const Text("Continue",
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME PAGE
////////////////////////////////////////////////////////////

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      Dashboard(role: widget.user.role),
      AIBot(user: widget.user),
      ProfilePage(user: widget.user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Aarohi Platform"),
        backgroundColor: Colors.indigo,
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.amber,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), label: "AI Guide"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// DASHBOARD
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/// DASHBOARD PAGE
////////////////////////////////////////////////////////////

class Dashboard extends StatelessWidget {
  final String role;
  const Dashboard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    List<String> features = [
      "Startup Analyzer",
      "Pitch Slot",
      "Investment Planner",
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            if (features[i] == "Startup Analyzer") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>  StartupAnalyzerPage()),
              );
            } else if (features[i] == "Pitch Slot") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>  PitchSlotPage()),
              );
            } else if (features[i] == "Investment Planner") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>  InvestmentPlannerPage()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                features[i],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// AI BOT
////////////////////////////////////////////////////////////

class AIBot extends StatefulWidget {
  final UserModel user;
  const AIBot({super.key, required this.user});

  @override
  State<AIBot> createState() => _AIBotState();
}

class _AIBotState extends State<AIBot> {
  final controller = TextEditingController();
  List<String> messages = [];

  Future<void> generateResponse(String idea) async {
    await Future.delayed(const Duration(seconds: 1));

    String response =
        "Hello ${widget.user.name} 👩‍💼\n\n"
        "Based on your idea: \"$idea\"\n\n"
        "Market Check: Similar ideas exist but you can differentiate.\n\n"
        "Feasibility: Practically possible.\n\n"
        "Steps:\n"
        "1. Market research in ${widget.user.location}\n"
        "2. Build MVP\n"
        "3. Branding & marketing\n"
        "4. Look for sponsors\n\n"
        "Estimated Cost: ₹50,000 approx\n\n"
        "Suggestion: Use your skills (${widget.user.skills}) to strengthen execution.";

    setState(() {
      messages.add(response);
    });
  }

  void send() {
    if (controller.text.isEmpty) return;
    String idea = controller.text;
    setState(() {
      messages.add("You: $idea");
    });
    controller.clear();
    generateResponse(idea);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: messages
                .map((msg) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(msg),
                      ),
                    ))
                .toList(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: "Ask about your startup idea"),
              ),
            ),
            IconButton(
                onPressed: send,
                icon: const Icon(Icons.send, color: Colors.amber))
          ],
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// PROFILE PAGE
////////////////////////////////////////////////////////////

class ProfilePage extends StatelessWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.person,
                  size: 80, color: Colors.amber),
              const SizedBox(height: 10),
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text(user.role),
              const Divider(),
              ListTile(
                title: const Text("Bio"),
                subtitle: Text(user.bio),
              ),
              ListTile(
                title: const Text("Skills"),
                subtitle: Text(user.skills),
              ),
              ListTile(
                title: const Text("Startup Idea"),
                subtitle: Text(user.startupIdea),
              ),
              ListTile(
                title: const Text("Location"),
                subtitle: Text(user.location),
              ),
              ListTile(
                title: const Text("Experience"),
                subtitle: Text(user.experience),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////
/// STARTUP ANALYZER PAGE
////////////////////////////////////////////////////////////

class StartupAnalyzerPage extends StatefulWidget {
  @override
  _StartupAnalyzerPageState createState() => _StartupAnalyzerPageState();
}

class _StartupAnalyzerPageState extends State<StartupAnalyzerPage> {
  final ideaController = TextEditingController();
  String result = "";

  void analyze() {
    String idea = ideaController.text;

    setState(() {
      result =
          "Problem Solved:\nYour idea addresses a real-world gap.\n\n"
          "Target Audience:\nWomen entrepreneurs, students, small business owners.\n\n"
          "Suggestion:\nFocus on marketing and digital presence.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Startup Analyzer")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ideaController,
              decoration: const InputDecoration(
                  labelText: "Enter Your Startup Idea"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyze,
              child: const Text("Analyze"),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// PITCH SLOT PAGE
////////////////////////////////////////////////////////////

class PitchSlotPage extends StatefulWidget {
  @override
  _PitchSlotPageState createState() => _PitchSlotPageState();
}

class _PitchSlotPageState extends State<PitchSlotPage> {
  List<String> slots = [
    "10:00 AM",
    "12:00 PM",
    "2:00 PM",
    "4:00 PM"
  ];

  String? selectedSlot;
  String message = "";

  void bookSlot() {
    if (selectedSlot != null) {
      setState(() {
        message = "Slot $selectedSlot booked successfully!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pitch Slot Booking")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text("Select Time Slot"),
              value: selectedSlot,
              items: slots
                  .map((slot) =>
                      DropdownMenuItem(value: slot, child: Text(slot)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSlot = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: bookSlot,
              child: const Text("Book Slot"),
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// INVESTMENT PLANNER PAGE
////////////////////////////////////////////////////////////

class InvestmentPlannerPage extends StatefulWidget {
  @override
  _InvestmentPlannerPageState createState() =>
      _InvestmentPlannerPageState();
}

class _InvestmentPlannerPageState
    extends State<InvestmentPlannerPage> {

  final expenseController = TextEditingController();
  final revenueController = TextEditingController();

  String result = "";

  void calculate() {
    double expense =
        double.tryParse(expenseController.text) ?? 0;
    double revenue =
        double.tryParse(revenueController.text) ?? 0;

    setState(() {
      if (revenue > expense) {
        result =
            "Good plan! Estimated Profit: ₹${revenue - expense}";
      } else {
        result =
            "Risky plan. You may face loss of ₹${expense - revenue}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Investment Planner")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Estimated Expenses"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: revenueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Expected Revenue"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculate,
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}