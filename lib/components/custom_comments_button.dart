import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/components/signin_first.dart';
import 'package:masahaty/provider/change_language.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_comments.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../models/comments&replies_model.dart';
import '../core/constants/constants.dart';

class CustomCommentsButton extends StatelessWidget {
  const CustomCommentsButton({
    super.key,
    required this.id,
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(CoustomBorderTheme.normalBorderRaduis))),
        context: context,
        builder: (context) {
          return CommentSection(id: id);
        },
      ),
      icon: const Icon(Icons.insert_comment_outlined),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              CoustomBorderTheme.normalBorderRaduis,
            ),
            side: const BorderSide(
              width: 1,
              color: CustomColorsTheme.dividerColor,
            ),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class CommentSection extends ConsumerStatefulWidget {
  const CommentSection({
    super.key,
    required this.id,
  });
  final String id;

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  get currentLanguage => ref.read(currentLanguageProvider);
  get currentUser => ref.read(currentUserProvider);
  List<Comment> comments = [];
  CommentsService commentsService = CommentsService();

  Future<void> fetchData() async {
    dynamic temp = await commentsService.commentsGetById(
        token: currentUser?.token, id: widget.id);
    setState(() {
      comments = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentUser?.token != null) {
      fetchData();
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isReplying = false;
  String replyingToId = '';
  String replyingToName = '';
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isReplying = false;
        replyingToId = '';
      });
    }
  }

  Future<void> _addCommentOrReply() async {
    if (_isReplying && replyingToId.isNotEmpty) {
      await _addReply(replyingToId, _controller.text);
    } else {
      await _addComment(_controller.text);
    }
    _controller.clear();
    _isReplying = false;
    replyingToId = '';
    await fetchData(); // Fetch data again to refresh the comments list
  }

  Future<void> _addComment(String comment) async {
    await commentsService.commentsPost(
      token: currentUser.token,
      id: widget.id,
      content: comment,
      parentCommentId: null,
    );
  }

  Future<void> _addReply(String parentCommentId, String reply) async {
    await commentsService.commentsPost(
      token: currentUser.token,
      id: widget.id,
      content: reply,
      parentCommentId: parentCommentId,
    );
  }

  bool _showAllReplies = false;

  @override
  Widget build(BuildContext context) {
    return currentUser?.token != null
        ? Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 600,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: comments.isNotEmpty
                        ? ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return _buildCommentItem(comments[index], index);
                            },
                          )
                        : Center(
                            child:
                                Text(AppLocalizations.of(context)!.noComments),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(CustomPageTheme.smallPadding),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: CustomColorsTheme.handColor,
                          width: CoustomBorderTheme.borderWidth * 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              hintText: _isReplying
                                  ? "${AppLocalizations.of(context)!.reply} $replyingToName"
                                  : AppLocalizations.of(context)!.addComment,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: _controller.text.isNotEmpty
                                ? CustomColorsTheme.headLineColor
                                : CustomColorsTheme.buttonColor,
                          ),
                          onPressed: _controller.text.isNotEmpty
                              ? () {
                                  _focusNode.unfocus();
                                  _addCommentOrReply();
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SignInFirst(context);
  }

  Widget _buildCommentItem(Comment comment, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onLongPress: () async {
            await _deleteComment(comment);
          },
          leading: const CircleAvatar(),
          title: Text(comment.user.fullName,
              style: const TextStyle(fontSize: CustomFontsTheme.mediumSize)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.content,
                  style: const TextStyle(fontSize: CustomFontsTheme.bigSize)),
              Row(
                children: [
                  Text(
                    DateFormat('d.M.yyyy')
                        .format(comment.creationDate)
                        .toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: comment.replies.isNotEmpty
                        ? () {
                            setState(() {
                              _showAllReplies = !_showAllReplies;
                            });
                          }
                        : null,
                    child: Text(
                        "${_showAllReplies ? AppLocalizations.of(context)!.hide : AppLocalizations.of(context)!.show} · ${comment.replies.length} ${AppLocalizations.of(context)!.reply}"),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isReplying = true;
                        replyingToId = comment.id;
                        replyingToName = comment.user.fullName;
                      });
                      _focusNode.requestFocus();
                    },
                    child: Text(AppLocalizations.of(context)!.reply),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_showAllReplies) ..._buildReplyItems(comment),
      ],
    );
  }

  List<Widget> _buildReplyItems(Comment comment) {
    return comment.replies.map((reply) {
      String arrowDirection = currentLanguage.languageCode == 'en' ? '>' : '<';
      String ifArabic =
          "${comment.user.fullName} $arrowDirection ${reply.user.fullName}";
      String ifEnglish =
          "${reply.user.fullName} $arrowDirection ${comment.user.fullName} ";
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListTile(
          onLongPress: () async {
            await _deleteReply(reply);
          },
          onTap: () {
            setState(() {
              _isReplying = true;
              replyingToId = comment.id;
            });
            _focusNode.requestFocus();
          },
          leading: const CircleAvatar(),
          title:
              Text(currentLanguage.languageCode == 'en' ? ifEnglish : ifArabic),
          subtitle: Text(reply.content),
        ),
      );
    }).toList();
  }

  Future<void> _deleteComment(Comment comment) async {
    if (currentUser.id == comment.user.id) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 60,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () async {
                  try {
                    await commentsService.commentsDelete(
                      token: currentUser.token,
                      id: widget.id,
                      commentId: comment.id,
                    );
                    Navigator.pop(context); // Close the dialog
                    await fetchData();
                  } catch (e) {
                    print('Error in deleting comment: $e');
                  }
                },
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ),
          );
        },
      );
    } else {
      // Show edit button or any other action for non-owners
    }
  }

  Future<void> _deleteReply(Reply reply) async {
    if (currentUser.id == reply.user.id) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 60,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () async {
                  try {
                    await commentsService.commentsDelete(
                      token: currentUser.token,
                      id: widget.id,
                      commentId: reply.commentId,
                    );
                    Navigator.pop(context); // Close the dialog
                    await fetchData();
                  } catch (e) {
                    print('Error in deleting reply: $e');
                  }
                },
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ),
          );
        },
      );
    } else {
      // Show edit button or any other action for non-owners
    }
  }
}
