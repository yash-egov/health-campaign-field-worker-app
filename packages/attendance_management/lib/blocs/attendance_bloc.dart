import 'dart:async';

import 'package:attendance_management/attendance_management.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Part of the code generated by Freezed for immutable classes
part 'attendance_bloc.freezed.dart';

// Type definition for emitter used in the AttendanceBloc
typedef AttendanceSearchEmitter = Emitter<AttendanceStates>;

/*
  @author  Ramkrishna-egov
  */
// AttendanceBloc responsible for managing attendance-related state
class AttendanceBloc extends Bloc<AttendanceEvents, AttendanceStates> {
  // Constructor initializing the initial state and setting up event handlers
  AttendanceBloc(super.initialState) {
    on(_onInitial);
    on(_onLoadAttendanceRegisterData);
    on(_onLoadSelectedRegisterData);
    on(_onLoadMoreAttendanceRegisters);
  }

  // Event handler for InitialAttendance event
  void _onInitial(
    InitialAttendance event,
    Emitter<AttendanceStates> emit,
  ) async {
    emit(const RegisterLoading());
    // Getting attendance registers using a singleton instance
    final registers = await AttendanceSingleton().getAttendanceRegisters(
      limit: 10,
      offset: 0,
    );
    add(AttendanceEvents.loadAttendanceRegisters(
        registers: registers!, limit: 10, offset: 0));
  }

  // Event handler for LoadAttendanceRegisterData event
  void _onLoadAttendanceRegisterData(
    LoadAttendanceRegisterData event,
    Emitter<AttendanceStates> emit,
  ) async {
    // Get the current state
    final currentState = state;

    // Check if the current state is RegisterLoaded
    if (currentState is RegisterLoaded) {
      // Append the new registers to the existing ones
      final updatedRegisters = currentState.registers + event.registers;

      // Emit the new state with the updated registers
      emit(RegisterLoaded(
        registers: updatedRegisters,
        limit: currentState.limit,
        offset: currentState.offset + event.limit,
      ));
    } else {
      // Emit the new state with the loaded registers
      emit(RegisterLoaded(
        registers: event.registers,
        limit: event.limit,
        offset: event.offset + event.limit,
      ));
    }
  }

  // Event handler for LoadSelectedAttendanceRegisterData event
  void _onLoadSelectedRegisterData(
    LoadSelectedAttendanceRegisterData event,
    Emitter<AttendanceStates> emit,
  ) async {
    emit(const RegisterLoading());
    // Finding and emitting the selected register based on ID
    final selectedRegister =
        await event.registers.where((e) => e.id == event.registerID).first;
    emit(SelectedRegisterLoaded(
      selectedRegister: selectedRegister,
    ));
  }

  FutureOr<void> _onLoadMoreAttendanceRegisters(
      LoadMoreAttendanceRegisterData event,
      Emitter<AttendanceStates> emit) async {
    // Getting more attendance registers using a singleton instance
    final registers = await AttendanceSingleton().loadMoreAttendanceRegisters(
        limit: event.limit!, offSet: event.offset!);

    // Get the current state
    final currentState = state;

    // Check if the current state is RegisterLoaded
    if (currentState is RegisterLoaded) {
      // Append the new registers to the existing ones
      final updatedRegisters = currentState.registers + registers!;

      // Emit the new state with the updated registers
      emit(currentState.copyWith(
          registers: updatedRegisters,
          offset: event.offset! + event.limit!,
          limit: event.limit!));
    }
  }
}

// Freezed class for defining attendance-related events
@freezed
class AttendanceEvents with _$AttendanceEvents {
  const factory AttendanceEvents.initial() = InitialAttendance;
  const factory AttendanceEvents.loadAttendanceRegisters(
      {required List<AttendanceRegisterModel> registers,
      required int limit,
      required int offset}) = LoadAttendanceRegisterData;
  const factory AttendanceEvents.loadSelectedRegister(
      {required final List<AttendanceRegisterModel> registers,
      required final String registerID}) = LoadSelectedAttendanceRegisterData;
  const factory AttendanceEvents.loadMoreAttendanceRegisters(
      {int? limit, int? offset}) = LoadMoreAttendanceRegisterData;
}

// Freezed class for defining attendance-related states
@freezed
class AttendanceStates with _$AttendanceStates {
  const factory AttendanceStates.registerLoading() = RegisterLoading;
  const factory AttendanceStates.registerLoaded({
    required final List<AttendanceRegisterModel> registers,
    @Default(0) int offset,
    @Default(10) int limit,
  }) = RegisterLoaded;
  const factory AttendanceStates.selectedRegisterLoaded({
    final AttendanceRegisterModel? selectedRegister,
  }) = SelectedRegisterLoaded;

  const factory AttendanceStates.registerError(String message) = RegisterError;
}
