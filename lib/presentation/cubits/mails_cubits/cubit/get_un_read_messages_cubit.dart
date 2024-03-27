import 'package:autism_mobile_app/domain/models/mail_models/un_read_mails_number.dart';
import 'package:autism_mobile_app/domain/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

part 'get_un_read_messages_state.dart';

class GetUnReadMessagesCubit extends Cubit<GetUnReadMessagesState> {
  GetUnReadMessagesCubit() : super(GetUnReadMessagesInitial());

  Repositories repositories = Repositories();

  Future<void> getNumberOfUnreadMessage() async {
    try {
      Response response = await repositories.getData(
          '/communication-management/communication/number-of-unread-message',
          null);

      String message = response.data['message'] != null
          ? response.data['message'].toString()
          : response.data['messages']
              .toString()
              .substring(1, response.data['messages'].toString().length - 1);

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        var body = response.data;

        UnreadMailsNumber.unreadMailsNumber = body['data'];

        emit(GetUnReadMessagesDone());
      } else {
        emit(GetUnReadMessagesFailed(failedMessage: message));
      }
    } catch (error) {
      print(error.toString());
      emit(GetUnReadMessagesError(
          errorMessage: 'تأكد من الاتصال بالانترنت، وحاول مجدداً'));
    }
  }
}
