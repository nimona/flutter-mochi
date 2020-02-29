class ConversationItem {
  ConversationItem({
    this.id,
    this.title,
    this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;
}

final List<ConversationItem> items = <ConversationItem>[
  ConversationItem(
    id: "item-1-id",
    title: 'David Hall',
    subtitle: 'This is the first item.',
  ),
  ConversationItem(
    id: "item-2-id",
    title: 'Christine Cruz',
    subtitle: 'This is the second item.',
  ),
  ConversationItem(
    id: "item-3-id",
    title: 'Aaron Turner',
    subtitle: 'This is the third item.',
  ),
];
