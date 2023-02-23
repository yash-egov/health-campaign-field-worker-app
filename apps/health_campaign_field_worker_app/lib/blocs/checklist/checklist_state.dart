part of 'checklist_bloc.dart';


abstract class ChecklistState {
  const ChecklistState();
}

class InitialChecklistState extends ChecklistState{

}

class ChecklistLoadingState extends ChecklistState{

}


class ChecklistLoadedState extends ChecklistState{
  final List<Survey> survey;
  ChecklistLoadedState({required this.survey});
}