import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:masahaty/provider/current_user.dart';
import 'package:masahaty/services/dio_comments.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../../../models/comments_model.dart';
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
          return CommentSection(
            id: id,
          );
        },
      ),
      icon: const Icon(
        Icons.insert_comment_outlined,
      ),
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
  get currentUser => ref.read(currentUserProvider);
  List<Comment> comments = [];
  CommentsService commentsService = CommentsService();

  Future<void> fetchData() async {
    dynamic temp = await commentsService.commentsGetById(
        token: currentUser.token, id: widget.id);
    setState(() {
      comments = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
  bool _replyingToReply = false;
  bool _isReplying = false;
  int _replyingToIndex = -1;

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isReplying = false;
        _replyingToIndex = -1;
      });
    }
  }

  void _addCommentOrReply() {
    if (_isReplying && _replyingToIndex >= 0) {
      _addReply(_replyingToIndex, _controller.text);
    } else {
      _addComment(_controller.text);
    }
    _controller.clear();
    _isReplying = false;
    _replyingToIndex = -1;
  }

  void _addComment(String comment) {
    setState(() {
      comments.add(
        Comment(
          id: '4',
          deleted: false,
          creationDate: DateFormat('d.M.yyyy').format(DateTime.now()),
          content: comment,
          user: User(
              id: currentUser.id,
              fullName: currentUser.fullName,
              phoneNumber: ''),
          replies: [],
        ),
      );
      _controller.clear();
    });
  }

  void _addReply(int index, String reply) {
    setState(() {
      comments[index].replies.add(
            Reply(
              commentId: comments[index].id,
              content: reply,
              user: User(
                  id: currentUser.id,
                  fullName: currentUser.fullName,
                  phoneNumber: currentUser.phoneNumber),
              creationDate: DateTime.now().toIso8601String(),
            ),
          );
    });
  }

  String replyingTo = '';
  bool _showAllReplies = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      child: Text(AppLocalizations.of(context)!.noComments),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(CustomPageTheme.smallPadding),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: CustomColorsTheme.handColor,
                          width: CoustomBorderTheme.borderWidth * 2))),
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
                            ? "${AppLocalizations.of(context)!.reply} $replyingTo"
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
                            if (_controller.text.isNotEmpty) {
                              _addCommentOrReply();
                              _focusNode
                                  .unfocus(); // Add this line to remove focus
                              setState(() {});
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
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
                    comment.creationDate.toString(),
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
                        _replyingToIndex = index;
                        replyingTo = comment.user.fullName;
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
        if (_showAllReplies) ..._buildReplyItems(comment, index),
      ],
    );
  }
  List<Widget> _buildReplyItems(Comment comment, int index) {
    return comment.replies.map((reply) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListTile(
          onTap: () {
            setState(() {
                        _isReplying = true;
                        _replyingToIndex = index;
                        replyingTo = comment.user.fullName;
                      });
                      _focusNode.requestFocus();
          },
          leading: const CircleAvatar(),
          title: Text("${reply.user.fullName} < ${comment.user.fullName}"),
          subtitle: Text(reply.content),
        ),
      );
    }).toList();
  }
}
