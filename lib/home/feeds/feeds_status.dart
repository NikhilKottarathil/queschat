abstract class PageScrollStatus {
  const PageScrollStatus();
}

class InitialStatus extends PageScrollStatus {
  const InitialStatus();
}
class ScrollToTop extends PageScrollStatus {
  const ScrollToTop();
}
class ScrollToBottom extends PageScrollStatus {
  const ScrollToBottom();
}

class Scrolling extends PageScrollStatus {
}

class LoadingMoreItems extends PageScrollStatus {
}


