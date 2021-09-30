abstract class PostBlogEvent {}

class SelectMedia extends PostBlogEvent {
  final  media,context;

  SelectMedia({this.media,this.context});
}
class HeadingChanged extends PostBlogEvent {
  final String heading;

  HeadingChanged({this.heading});
}

class ContentChanged extends PostBlogEvent {
  final String content;

  ContentChanged({this.content});
}


class PostBlogSubmitted extends PostBlogEvent {}
class ClearAllFields extends PostBlogEvent {}

