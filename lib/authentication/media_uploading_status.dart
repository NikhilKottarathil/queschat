abstract class MediaSelectingStatus {
  const MediaSelectingStatus();
}

class InitialStatus extends MediaSelectingStatus {
  const InitialStatus();
}

class Updating extends MediaSelectingStatus {}

class UpdatedSuccessfully extends MediaSelectingStatus {}

class UpdateFailed extends MediaSelectingStatus {
  final Exception exception;

  UpdateFailed(this.exception);
}