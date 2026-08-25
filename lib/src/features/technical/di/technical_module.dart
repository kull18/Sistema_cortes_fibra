import '../../../core/di/app_container.dart';
import '../domain/repositories/technical_repository.dart';
import '../domain/usecases/get_events_usecase.dart';
import '../domain/usecases/get_event_usecase.dart';
import '../domain/usecases/get_unread_notifications_count_usecase.dart';
import '../domain/usecases/list_central_offices_usecase.dart';
import '../domain/usecases/get_central_office_usecase.dart';
import '../domain/usecases/create_central_office_usecase.dart';
import '../domain/usecases/update_central_office_usecase.dart';
import '../domain/usecases/delete_central_office_usecase.dart';
import '../domain/usecases/create_event_usecase.dart';
import '../domain/usecases/update_event_usecase.dart';
import '../domain/usecases/get_event_photo_upload_url_usecase.dart';
import '../domain/usecases/create_event_photo_usecase.dart';
import '../domain/usecases/list_event_photos_usecase.dart';
import '../domain/usecases/list_event_comments_usecase.dart';
import '../domain/usecases/create_event_comment_usecase.dart';
import '../domain/usecases/delete_event_comment_usecase.dart';
import '../domain/usecases/list_notifications_usecase.dart';
import '../domain/usecases/mark_notification_as_read_usecase.dart';

class TechnicalModule {
  final AppContainer container;

  TechnicalModule(this.container);

  TechnicalRepository provideTechnicalRepository() => container.technicalRepository;

  GetEventsUseCase provideGetEventsUseCase() {
    return GetEventsUseCase(provideTechnicalRepository());
  }

  GetEventUseCase provideGetEventUseCase() {
    return GetEventUseCase(provideTechnicalRepository());
  }

  GetUnreadNotificationsCountUseCase provideGetUnreadNotificationsCountUseCase() {
    return GetUnreadNotificationsCountUseCase(provideTechnicalRepository());
  }

  ListCentralOfficesUseCase provideListCentralOfficesUseCase() {
    return ListCentralOfficesUseCase(provideTechnicalRepository());
  }

  GetCentralOfficeUseCase provideGetCentralOfficeUseCase() {
    return GetCentralOfficeUseCase(provideTechnicalRepository());
  }

  CreateCentralOfficeUseCase provideCreateCentralOfficeUseCase() {
    return CreateCentralOfficeUseCase(provideTechnicalRepository());
  }

  UpdateCentralOfficeUseCase provideUpdateCentralOfficeUseCase() {
    return UpdateCentralOfficeUseCase(provideTechnicalRepository());
  }

  DeleteCentralOfficeUseCase provideDeleteCentralOfficeUseCase() {
    return DeleteCentralOfficeUseCase(provideTechnicalRepository());
  }

  CreateEventUseCase provideCreateEventUseCase() {
    return CreateEventUseCase(provideTechnicalRepository());
  }

  UpdateEventUseCase provideUpdateEventUseCase() {
    return UpdateEventUseCase(provideTechnicalRepository());
  }

  GetEventPhotoUploadUrlUseCase provideGetEventPhotoUploadUrlUseCase() {
    return GetEventPhotoUploadUrlUseCase(provideTechnicalRepository());
  }

  CreateEventPhotoUseCase provideCreateEventPhotoUseCase() {
    return CreateEventPhotoUseCase(provideTechnicalRepository());
  }

  ListEventPhotosUseCase provideListEventPhotosUseCase() {
    return ListEventPhotosUseCase(provideTechnicalRepository());
  }

  ListEventCommentsUseCase provideListEventCommentsUseCase() {
    return ListEventCommentsUseCase(provideTechnicalRepository());
  }

  CreateEventCommentUseCase provideCreateEventCommentUseCase() {
    return CreateEventCommentUseCase(provideTechnicalRepository());
  }

  DeleteEventCommentUseCase provideDeleteEventCommentUseCase() {
    return DeleteEventCommentUseCase(provideTechnicalRepository());
  }

  ListNotificationsUseCase provideListNotificationsUseCase() {
    return ListNotificationsUseCase(provideTechnicalRepository());
  }

  MarkNotificationAsReadUseCase provideMarkNotificationAsReadUseCase() {
    return MarkNotificationAsReadUseCase(provideTechnicalRepository());
  }
}
