part of 'checklist_bloc.dart';

abstract class ChecklistEvent {
  const ChecklistEvent();
}

class InitializeChecklist extends ChecklistEvent{
  InitializeChecklist();
}

class UpdateAnswer extends ChecklistEvent {
  int index;
  bool option;
  String reason;

  UpdateAnswer({required this.index, required this.option, this.reason = ''});
}


class SubmitChecklist extends ChecklistEvent{
  SubmitChecklist();
}