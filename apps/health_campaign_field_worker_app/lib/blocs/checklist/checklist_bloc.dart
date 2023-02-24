import 'package:bloc/bloc.dart';

import '../../models/question.dart';

part 'checklist_event.dart';

part 'checklist_state.dart';

/// todo - make things dynamic
List<Survey> survey = [
  Survey(
    question: 'This is my question 1 ',
    alert: 'Alert for no 1',
  ),
  Survey(
    question: 'This is my question 2 ',
    alert: 'Alert for no 2',
  ),
  Survey(
    question: 'This is my question 3 ',
    alert: 'Alert for no 3',
  ),
  Survey(
    question: 'This is my question 4 ',
    alert: 'Alert for no 4',
  ),
  Survey(
    question: 'This is my question 5 ',
    alert: 'Alert for no 5',
  ),
  Survey(
    question: 'This is my question 6 ',
    alert: 'Alert for no 6',
  ),
  Survey(
    question: 'This is my question 7 ',
    alert: 'Alert for no 7',
  ),
  Survey(
    question: 'This is my question 8 ',
    alert: 'Alert for no 7',
  ),
];

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  List<String> reasons = [];
  List<bool> choices = [];

  ChecklistBloc() : super(InitialChecklistState()) {
    on<InitializeChecklist>(_onInitChecklist);
    on<UpdateAnswer>(_onUpdateAnswer);
    on<SubmitChecklist>(_onSubmitChecklist);
  }

  _onInitChecklist(InitializeChecklist event, Emitter<ChecklistState> state) {
    /// make API calls
    int numberOfQuestions = survey.length;
    emit(ChecklistLoadingState());
    for (var i = 0; i < numberOfQuestions; i++) {
      choices.add(true);
      reasons.add("");
    }
    emit(ChecklistLoadedState(survey: survey));
  }

  _onUpdateAnswer(UpdateAnswer event, Emitter<ChecklistState> state) {
    print('########## in the bloc -- updating the answer -------');
    choices[event.index] = event.option;
    reasons[event.index] = event.reason;
  }

  _onSubmitChecklist(SubmitChecklist event, Emitter<ChecklistState> state) {
    /// perform repository operation here
  }
}
