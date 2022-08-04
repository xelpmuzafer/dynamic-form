import 'package:flutter/material.dart';
import 'package:surveynow/config/appColors.dart';
import 'package:surveynow/models/chatMessage.dart';
import 'package:surveynow/services/http_service.dart';
import 'package:surveynow/widgets/chatBubble.dart';
import 'package:surveynow/widgets/customButton.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key? key}) : super(key: key);
   
  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {

  Color chatBotBgcolor = const Color(0x00000029);

  final ScrollController _controller = ScrollController();

  TextEditingController textControlled = TextEditingController();

  List<Widget> messages = [];

  getReplyFromServer(id, selected_option) async {
    dynamic _response = await HttpService().getReply(id,selected_option );
   dynamic _reply = _response['data'];

    List<ChatMessage> temp = [];
    
    _reply.forEach((element) {
      temp.add(ChatMessage(
          id: element['id'],

          parentId: element['parent_id'],
          message: element['message'], callback: element['callback'], dbRowId: element['db_row_id'], type: element['type']));
    });

    setState(() {
      messages.add(ReceivedOptions(temp));
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  sendMessage() async {
    if (textControlled.text.toString() != "") {
      setState(() {
        messages.add(SentMessage(ChatMessage(
            id: messages.length + 1,
            parentId: 2,
            message: textControlled.text, type: '', callback: '', dbRowId: '')));
        textControlled.clear();
      });
      _controller.jumpTo(_controller.position.maxScrollExtent);
      getReplyFromServer(2,"");
    }
  }

  @override
  void initState() {
    
    super.initState();

    setState(() {
      messages.add(ReceivedMessage(ChatMessage(
          id: 1,
          parentId: 0,
          message: "Welcome to mitaan, are you looking for service?", 
          callback: '',
          dbRowId: "",
          type: "message"

          )));
    });
    getReplyFromServer(1, "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(

              children: [

       SizedBox(
        height: MediaQuery.of(context).size.height,
         child: Center(
           child: SizedBox(
            width: 100,
            height: 100,
             child: Image.asset(
              "assets/bird.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
      ),
           ),
         ),
       ),
    
                FractionallySizedBox(
      heightFactor: 0.97,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
                  color: const Color.fromARGB(71, 122, 148, 187),
                  borderRadius: BorderRadius.circular(40)),
          child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Container(
                      
       
                
                
          
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            children: List.generate(
                                    messages.length, (index) => messages[index])
                                .toList()),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: textControlled,
                                  decoration:  const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blue, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    hintText: 'Enter Message',
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                    ),
                                    onPressed: sendMessage,
                                    child: const Text("Send",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: AppColors.kPrimaryColor,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ))
                          ],
                        ),
                      ))
                ],
          ),
        ),
      ),
    ),
              ],
            )));
  }

  Container ReceivedOptions(List<ChatMessage> messageObjects) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            children: List.generate(
              messageObjects.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    messages.add(SentMessage(ChatMessage(
                        id: messageObjects[index].id!,
                        parentId: messageObjects[index].parentId!,
                        message: messageObjects[index].message!)));
                  });
                  getReplyFromServer(messageObjects[index].id, messageObjects[index].dbRowId);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.kPrimaryColor, width: 1)),
                  margin: const EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Text(
                        messageObjects[index].message!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container ReceivedMessage(ChatMessage messageObject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Align(
        alignment: Alignment.topLeft,
        child: CustomPaint(
          painter:
              ChatBubble(color: Colors.white, alignment: Alignment.topLeft),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Text(messageObject.message!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container SentMessage(ChatMessage messageObject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Align(
        alignment: Alignment
            .topRight, //Change this to Alignment.topRight or Alignment.topLeft
        child: CustomPaint(
          painter: ChatBubble(
              color: AppColors.kPrimaryColor, alignment: Alignment.topRight),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Text(
                  messageObject.message!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
