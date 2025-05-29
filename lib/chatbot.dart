import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFFFFE1FF); // Light Pink
  static const Color color2 = Color(0xFFE4B1F0); // Lavender
  static const Color color3 = Color(0xFF7E60BF); // Purple
}

class SafetyAdvisorScreen extends StatefulWidget {
  const SafetyAdvisorScreen({super.key});

  @override
  _SafetyAdvisorScreenState createState() => _SafetyAdvisorScreenState();
}

class _SafetyAdvisorScreenState extends State<SafetyAdvisorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [];

  final Map<String, List<Map<String, String>>> categories = {
    'Natural Disasters': [
      {
        'question': 'How to prepare for earthquakes?',
        'answer': 'Secure heavy furniture to walls, identify safe spots (under sturdy tables, away from windows), prepare an emergency kit with 3 days of supplies, and practice drop-cover-hold drills monthly.'
      },
      {
        'question': 'What to do during a volcanic eruption?',
        'answer': 'Follow evacuation orders immediately, protect yourself from ash fall with N95 masks and goggles, stay indoors with windows/doors closed if sheltering in place, and avoid low-lying areas.'
      },
      {
        'question': 'How to stay safe in floods?',
        'answer': 'Move to higher ground immediately, avoid walking/driving through flood waters (6 inches can knock you down), turn off electricity/gas if water enters, and follow designated evacuation routes.'
      },
      {
        'question': 'Preparing for hurricanes?',
        'answer': 'Install storm shutters, trim trees, secure outdoor items, know your evacuation zone, prepare emergency supplies including battery-powered radio, and reinforce garage doors.'
      },
      {
        'question': 'Wildfire safety measures?',
        'answer': 'Create defensible space around property, use fire-resistant materials, prepare evacuation bags with essentials, monitor air quality, and know multiple escape routes.'
      },
      {
        'question': 'Tsunami warning signs?',
        'answer': 'Natural warnings include strong/long earthquakes, unusual ocean behavior (rapid rising/receding), and loud ocean roars. Move immediately to high ground without waiting for official alerts.'
      },
      {
        'question': 'Surviving extreme heat?',
        'answer': 'Stay hydrated with water (avoid alcohol/caffeine), wear lightweight/light-colored clothing, use cooling centers, check on vulnerable neighbors, and never leave people/pets in vehicles.'
      },
      {
        'question': 'Winter storm preparation?',
        'answer': 'Insulate pipes, prepare emergency heating sources safely, keep rock salt for melting ice, maintain emergency kit with blankets, and winterize your vehicle.'
      },
      {
        'question': 'Landslide warning signs?',
        'answer': 'Watch for new cracks in foundations, tilting trees/fences, unusual water flow patterns, and sounds of moving debris. Relocate immediately if you suspect imminent landslide.'
      },
      {
        'question': 'Drought conservation tips?',
        'answer': 'Install water-efficient fixtures, collect rainwater, fix leaks immediately, prioritize essential water use, and replace lawns with drought-resistant landscaping.'
      },
      {
        'question': 'Tornado safety actions?',
        'answer': 'Go to basement or small interior room without windows, cover yourself with mattresses/blankets, wear helmets for head protection, and avoid mobile homes/vehicles.'
      },
      {
        'question': 'Volcanic ash cleanup?',
        'answer': 'Wear N95 masks and goggles, wet ash before removal to prevent airborne particles, avoid roof work if possible, and dispose ash in plastic bags to prevent drain clogging.'
      },
      {
        'question': 'Earthquake-proofing buildings?',
        'answer': 'Anchor heavy furniture, install automatic gas shutoff valves, reinforce cripple walls, secure water heaters, and consider seismic retrofitting for older structures.'
      },
      {
        'question': 'Flash flood preparedness?',
        'answer': 'Know nearby high ground routes, avoid camping in dry washes, monitor weather alerts, and remember that 12 inches of moving water can carry away most vehicles.'
      },
      {
        'question': 'Post-disaster sanitation?',
        'answer': 'Boil water until declared safe, disinfect surfaces with bleach solutions, properly dispose of spoiled food, and wash hands frequently with clean water and soap.'
      },
    ],
    'Toxic Hazards': [
      {
        'question': 'CO poisoning symptoms?',
        'answer': 'Headache, dizziness, weakness, nausea, vomiting, chest pain, confusion. Often described as "flu-like" symptoms without fever. Can lead to unconsciousness and death.'
      },
      {
        'question': 'Chemical spill response?',
        'answer': 'Evacuate upwind immediately, avoid contact, don\'t walk through spills, remove contaminated clothing, rinse skin with water for 15-20 minutes, and call emergency services.'
      },
      {
        'question': 'Radiation exposure signs?',
        'answer': 'Nausea/vomiting, diarrhea, skin burns, weakness, hair loss. In severe cases: bleeding, infections, and cardiovascular collapse. Seek medical attention immediately.'
      },
      {
        'question': 'Asbestos safety measures?',
        'answer': 'Never disturb asbestos materials, hire certified professionals for removal, use proper PPE during renovations, and monitor for deteriorating asbestos-containing materials.'
      },
      {
        'question': 'Mold exposure symptoms?',
        'answer': 'Nasal stuffiness, throat irritation, coughing, eye irritation, skin irritation. Severe reactions may include fever and difficulty breathing in immunocompromised individuals.'
      },
      {
        'question': 'Industrial accident response?',
        'answer': 'Follow plant emergency procedures, move upwind, use emergency showers if contaminated, account for all personnel, and avoid using phones/electronics that could spark.'
      },
      {
        'question': 'Biological hazard cleanup?',
        'answer': 'Use PPE (gloves, masks, goggles), disinfect with appropriate solutions (bleach for many pathogens), properly dispose contaminated materials, and wash thoroughly afterwards.'
      },
      {
        'question': 'Mercury spill procedure?',
        'answer': 'Evacuate area, ventilate, don\'t vacuum (spreads mercury), use stiff paper to gather beads, place in airtight container, and contact hazardous waste disposal.'
      },
      {
        'question': 'Lead poisoning prevention?',
        'answer': 'Test homes built before 1978 for lead paint, maintain painted surfaces, clean frequently with wet methods, wash hands often, and test children\'s blood lead levels.'
      },
      {
        'question': 'Pesticide safety?',
        'answer': 'Follow label instructions exactly, wear protective clothing, avoid spraying on windy days, store securely away from children/pets, and never mix different chemicals.'
      },
      {
        'question': 'Chlorine gas exposure?',
        'answer': 'Immediately move to fresh air, remove contaminated clothing, flush eyes/skin with water for 15 minutes, and seek medical attention for breathing difficulties.'
      },
      {
        'question': 'Hazardous material storage?',
        'answer': 'Store in original labeled containers, keep incompatible chemicals separate, ensure proper ventilation, use secondary containment, and maintain up-to-date SDS sheets.'
      },
      {
        'question': 'Fume hood safety?',
        'answer': 'Work with sash at proper height, keep storage minimal, check airflow before use, don\'t block vents, and maintain 6-inch clearance from opening when working.'
      },
      {
        'question': 'Chemical waste disposal?',
        'answer': 'Never pour down drains, use proper containers with labels, separate incompatible wastes, keep records of disposal, and use authorized hazardous waste services.'
      },
      {
        'question': 'Radon testing/mitigation?',
        'answer': 'Test homes every 2 years, use long-term test kits for accuracy, install mitigation systems if levels exceed 4 pCi/L, and seal foundation cracks to reduce entry.'
      },
    ],
    'Emergency Preparedness': [
      {
        'question': 'Basic emergency kit contents?',
        'answer': 'Water (1 gal/person/day for 3 days), non-perishable food, flashlight, batteries, first aid kit, medications, multi-tool, phone charger, cash, important documents copies.'
      },
      {
        'question': 'Family communication plan?',
        'answer': 'Designate out-of-area contact, ensure all members know emergency numbers, establish meeting places (near home and outside neighborhood), and practice regularly.'
      },
      {
        'question': 'Sheltering in place prep?',
        'answer': 'Seal windows/doors with plastic sheeting and duct tape, turn off ventilation systems, have air purifiers ready, and prepare for potential extended stays without utilities.'
      },
      {
        'question': 'Emergency water purification?',
        'answer': 'Boil for 1 minute (3 mins at high elevation), use household bleach (8 drops per gallon, wait 30 mins), or commercial water filters designed for pathogens.'
      },
      {
        'question': 'Power outage preparation?',
        'answer': 'Have flashlights/batteries (not candles), keep fridge/freezer closed, know how to manually open garage doors, and consider backup power for medical devices.'
      },
      {
        'question': 'Evacuation bag essentials?',
        'answer': '3 days supplies, medications, copies of IDs/insurance, cash, phone charger, change of clothes, personal hygiene items, emergency blanket, and comfort items for children.'
      },
      {
        'question': 'First aid training?',
        'answer': 'Learn CPR/AED use, how to stop bleeding, treat burns, recognize strokes/heart attacks, manage fractures, and respond to allergic reactions/choking.'
      },
      {
        'question': 'Pet emergency planning?',
        'answer': 'Prepare pet emergency kit (food, meds, leash/carrier), ensure ID tags are current, know pet-friendly shelters, and have recent photos for identification.'
      },
      {
        'question': 'Disaster documentation?',
        'answer': 'Photograph property before disasters, keep digital copies of important documents in secure cloud storage, and maintain insurance policy details accessible.'
      },
      {
        'question': 'Emergency sanitation?',
        'answer': 'Prepare portable toilets or bucket with plastic bags/lid, stock hygiene supplies (soap, sanitizer, feminine products), and know proper waste disposal methods.'
      },
      {
        'question': 'Vehicle emergency kit?',
        'answer': 'Jumper cables, flares/reflectors, blanket, water, snacks, first aid kit, tool kit, spare tire, phone charger, and cat litter for traction in snow.'
      },
      {
        'question': 'Special needs preparedness?',
        'answer': 'Extra medical supplies, backup power for equipment, list of medications/allergies, evacuation plan accounting for mobility issues, and caregiver instructions.'
      },
      {
        'question': 'Neighborhood preparedness?',
        'answer': 'Organize community response teams, identify vulnerable residents, share skills/resources, and establish communication trees for emergency alerts.'
      },
      {
        'question': 'Financial preparedness?',
        'answer': 'Maintain emergency savings, keep small bills on hand, store important financial documents securely, and understand insurance coverage details.'
      },
      {
        'question': 'Psychological first aid?',
        'answer': 'Remain calm, listen without judgment, provide comfort, connect people with resources, and watch for signs of severe distress requiring professional help.'
      },
    ],
  };

  String? selectedCategory;
  String? selectedQuestion;
  String? answer;

  void _sendMessage(String message) {
    setState(() {
      _chatMessages.add({'sender': 'user', 'message': message});
    });
  }

  void _sendBotAnswer(String question) {
    setState(() {
      selectedQuestion = question;
      final categoryQuestions = categories[selectedCategory!];
      final questionData = categoryQuestions!.firstWhere((qa) => qa['question'] == question);
      answer = questionData['answer'];
      _chatMessages.add({'sender': 'bot', 'message': answer!});
    });
  }

  void _showQuestions(String category) {
    setState(() {
      selectedCategory = category;
      selectedQuestion = null;
      answer = null;
      _sendMessage('I need information about $category');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Safety Advisor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.color3.withOpacity(0.8), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final chatMessage = _chatMessages[index];
                  return Align(
                    alignment: chatMessage['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: chatMessage['sender'] == 'user'
                            ? AppColors.color2.withOpacity(0.9)
                            : AppColors.color1.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatMessage['sender'] == 'user' ? 'You' : 'Safety Advisor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: chatMessage['sender'] == 'user'
                                  ? Colors.black
                                  : AppColors.color3,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            chatMessage['message']!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select a category"),
                value: selectedCategory,
                dropdownColor: AppColors.color1,
                onChanged: (category) => _showQuestions(category!),
                items: categories.keys.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: AppColors.color3),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (selectedCategory != null)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: categories[selectedCategory]!.length,
                  itemBuilder: (context, index) {
                    final questionData = categories[selectedCategory]![index];
                    return Card(
                      color: AppColors.color2.withOpacity(0.7),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          questionData['question']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          _sendMessage(questionData['question']!);
                          _sendBotAnswer(questionData['question']!);
                        },
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (message) {
                        if (message.trim().isNotEmpty) {
                          _sendMessage(message);
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.color3),
                    onPressed: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}