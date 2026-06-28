import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../controllers/ai_coach_controller.dart';

class AiCoachScreen extends GetView<AiCoachController> {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark ? AppColors.white : AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: isDark ? AppColors.black : AppColors.white,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Coach',
                  style: AppTypography.titleMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Obx(() => Text(
                      controller.isTyping.value
                          ? 'Typing...'
                          : 'Online',
                      style: AppTypography.bodySmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    )),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () => _confirmClear(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Daily limit indicator ──────────────────────────────────────
          Obx(() {
            final user = Get.find<dynamic>(); // auth controller
            final isPremium = false; // simplified
            if (isPremium) return const SizedBox.shrink();

            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXl,
                  vertical: AppConstants.spacingSm),
              color: isDark ? AppColors.gray800 : AppColors.gray100,
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Text(
                      '${controller.requestsUsedToday.value}/${controller.dailyLimit} requests used today',
                      style: AppTypography.bodySmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.subscription),
                    child: Text(
                      'Upgrade',
                      style: AppTypography.labelSmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // ── Quick Prompts ──────────────────────────────────────────────
          Obx(() {
            if (controller.messages.length > 1) {
              return const SizedBox.shrink();
            }
            return _buildQuickPrompts(isDark);
          }),

          // ── Messages ───────────────────────────────────────────────────
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _MessageBubble(
                      message: message,
                      isDark: isDark,
                    ).animate(delay: 50.ms).fadeIn().slideY(
                          begin: 0.05,
                          end: 0,
                          duration: AppConstants.animFast,
                        );
                  },
                )),
          ),

          // ── Input Bar ─────────────────────────────────────────────────
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts(bool isDark) {
    final prompts = [
      '🍽️ Suggest a meal plan for today',
      '💪 What workout should I do today?',
      '📊 Analyze my nutrition',
      '🎯 How to reach my goal faster?',
    ];

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                controller.sendQuickPrompt(prompts[index]),
            child: Container(
              margin: const EdgeInsets.only(
                  right: AppConstants.spacingSm, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray800 : AppColors.gray100,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
              child: Center(
                child: Text(
                  prompts[index],
                  style: AppTypography.bodySmallDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.spacingMd,
        right: AppConstants.spacingMd,
        top: AppConstants.spacingMd,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom +
            AppConstants.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              style: AppTypography.bodyMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Ask your AI coach...',
                hintStyle: AppTypography.bodyMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                filled: true,
                fillColor:
                    isDark ? AppColors.gray800 : AppColors.gray100,
              ),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Obx(() => GestureDetector(
                onTap: controller.isTyping.value
                    ? null
                    : controller.sendMessage,
                child: AnimatedContainer(
                  duration: AppConstants.animFast,
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: controller.isTyping.value
                        ? (isDark ? AppColors.gray600 : AppColors.gray300)
                        : (isDark ? AppColors.white : AppColors.black),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    size: 18,
                    color: controller.isTyping.value
                        ? (isDark ? AppColors.gray400 : AppColors.gray500)
                        : (isDark ? AppColors.black : AppColors.white),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _confirmClear() {
    Get.dialog(AlertDialog(
      title: const Text('Clear Chat'),
      content: const Text('This will clear all messages. Continue?'),
      actions: [
        TextButton(
            onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            Get.back();
            controller.clearChat();
          },
          child: const Text('Clear'),
        ),
      ],
    ));
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (message.isLoading) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : AppColors.gray100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusLg),
              topRight: Radius.circular(AppConstants.radiusLg),
              bottomRight: Radius.circular(AppConstants.radiusLg),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TypingDot(delay: 0, isDark: isDark),
              const SizedBox(width: 4),
              _TypingDot(delay: 200, isDark: isDark),
              const SizedBox(width: 4),
              _TypingDot(delay: 400, isDark: isDark),
            ],
          ),
        ),
      );
    }

    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.gray800 : AppColors.gray100),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppConstants.radiusLg),
            topRight: const Radius.circular(AppConstants.radiusLg),
            bottomLeft: isUser
                ? const Radius.circular(AppConstants.radiusLg)
                : const Radius.circular(4),
            bottomRight: isUser
                ? const Radius.circular(4)
                : const Radius.circular(AppConstants.radiusLg),
          ),
        ),
        child: Text(
          message.content,
          style: AppTypography.bodyMediumDark.copyWith(
            color: isUser
                ? (isDark ? AppColors.black : AppColors.white)
                : (isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary),
          ),
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final int delay;
  final bool isDark;

  const _TypingDot({required this.delay, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray500 : AppColors.gray400,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .fadeIn(
            delay: Duration(milliseconds: delay),
            duration: const Duration(milliseconds: 400))
        .then()
        .fadeOut(duration: const Duration(milliseconds: 400));
  }
}
