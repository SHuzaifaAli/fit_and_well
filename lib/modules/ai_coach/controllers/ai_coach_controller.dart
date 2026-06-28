import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../modules/nutrition/controllers/nutrition_controller.dart';

/// Chat message model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessage copyWith({String? content, bool? isLoading}) {
    return ChatMessage(
      id: id,
      content: content ?? this.content,
      isUser: isUser,
      timestamp: timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AiCoachController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxInt requestsUsedToday = 0.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  static const String _openAiUrl =
      'https://api.openai.com/v1/chat/completions';

  int get dailyLimit {
    final user = _auth.currentUser.value;
    if (user == null) return AppConstants.freeAiRequestsPerDay;
    return user.isPremium
        ? AppConstants.premiumAiRequestsPerDay
        : AppConstants.freeAiRequestsPerDay;
  }

  bool get canSendMessage =>
      requestsUsedToday.value < dailyLimit;

  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _addWelcomeMessage() {
    final user = _auth.currentUser.value;
    final name = user?.name.split(' ').first ?? 'there';

    messages.add(ChatMessage(
      id: 'welcome',
      content:
          'Hi $name! 👋 I\'m your AI fitness coach. I can help you with:\n\n'
          '• Personalized meal plans\n'
          '• Workout recommendations\n'
          '• Nutrition advice\n'
          '• Progress analysis\n\n'
          'What would you like help with today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendMessage({String? predefinedMessage}) async {
    final text = predefinedMessage ?? messageController.text.trim();
    if (text.isEmpty) return;
    if (!canSendMessage) {
      Get.snackbar(
        'Daily Limit Reached',
        'Upgrade to Premium for unlimited AI requests',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    messageController.clear();

    // Add user message
    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Add loading indicator
    final loadingId = 'loading_${DateTime.now().millisecondsSinceEpoch}';
    messages.add(ChatMessage(
      id: loadingId,
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    ));

    isTyping.value = true;
    _scrollToBottom();

    try {
      final response = await _callOpenAI(text);
      requestsUsedToday.value++;

      // Replace loading with response
      final idx = messages.indexWhere((m) => m.id == loadingId);
      if (idx != -1) {
        messages[idx] = ChatMessage(
          id: loadingId,
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      final idx = messages.indexWhere((m) => m.id == loadingId);
      if (idx != -1) {
        messages[idx] = ChatMessage(
          id: loadingId,
          content:
              'Sorry, I couldn\'t process your request. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        );
      }
    } finally {
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  Future<String> _callOpenAI(String userMessage) async {
    final user = _auth.currentUser.value;
    final apiKey = const String.fromEnvironment('OPENAI_API_KEY');

    // Build system context
    final systemPrompt = _buildSystemPrompt(user);

    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        // Include last 10 messages for context
        ..._getConversationHistory(),
        {'role': 'user', 'content': userMessage},
      ],
      'max_tokens': 600,
      'temperature': 0.7,
    });

    final response = await http
        .post(
          Uri.parse(_openAiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded');
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  String _buildSystemPrompt(user) {
    final buffer = StringBuffer();
    buffer.writeln(
        'You are a professional AI fitness and nutrition coach. Be concise, motivating, and practical.');
    buffer.writeln(
        'Provide specific, actionable advice tailored to the user\'s profile.');
    buffer.writeln('Format responses clearly with bullet points when listing items.');

    if (user != null) {
      buffer.writeln('\nUser Profile:');
      if (user.name.isNotEmpty) buffer.writeln('- Name: ${user.name}');
      if (user.age != null) buffer.writeln('- Age: ${user.age} years');
      if (user.gender != null) buffer.writeln('- Gender: ${user.gender}');
      if (user.weight != null) buffer.writeln('- Weight: ${user.weight}kg');
      if (user.height != null) buffer.writeln('- Height: ${user.height}cm');
      if (user.goal != null) buffer.writeln('- Goal: ${user.goal}');
      if (user.activityLevel != null)
        buffer.writeln('- Activity Level: ${user.activityLevel}');
      if (user.dietPreference != null && user.dietPreference != 'none')
        buffer.writeln('- Diet Preference: ${user.dietPreference}');
    }

    // Add today's nutrition context if available
    try {
      final nutritionController = Get.find<NutritionController>();
      buffer.writeln('\nToday\'s Nutrition:');
      buffer.writeln(
          '- Calories consumed: ${nutritionController.totalCalories.toStringAsFixed(0)} kcal');
      buffer.writeln(
          '- Daily goal: ${nutritionController.dailyCalorieGoal.toStringAsFixed(0)} kcal');
      buffer.writeln(
          '- Protein: ${nutritionController.totalProtein.toStringAsFixed(0)}g');
      buffer.writeln(
          '- Carbs: ${nutritionController.totalCarbs.toStringAsFixed(0)}g');
      buffer.writeln(
          '- Fat: ${nutritionController.totalFat.toStringAsFixed(0)}g');
    } catch (_) {}

    return buffer.toString();
  }

  List<Map<String, String>> _getConversationHistory() {
    final nonLoadingMessages =
        messages.where((m) => !m.isLoading).toList();
    final recent = nonLoadingMessages.length > 10
        ? nonLoadingMessages.sublist(nonLoadingMessages.length - 10)
        : nonLoadingMessages;

    return recent
        .where((m) => m.id != 'welcome')
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendQuickPrompt(String prompt) {
    sendMessage(predefinedMessage: prompt);
  }

  void clearChat() {
    messages.clear();
    _addWelcomeMessage();
  }
}
