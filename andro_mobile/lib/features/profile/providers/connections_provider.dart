import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { none, pending, connected }

class ConnectionsState {
  final Map<String, ConnectionStatus> outgoing;
  final Set<String> incomingRequests;

  const ConnectionsState({
    required this.outgoing,
    required this.incomingRequests,
  });

  ConnectionsState copyWith({
    Map<String, ConnectionStatus>? outgoing,
    Set<String>? incomingRequests,
  }) =>
      ConnectionsState(
        outgoing: outgoing ?? this.outgoing,
        incomingRequests: incomingRequests ?? this.incomingRequests,
      );

  ConnectionStatus statusFor(String userId) =>
      outgoing[userId] ?? ConnectionStatus.none;

  List<String> get connectedIds => outgoing.entries
      .where((e) => e.value == ConnectionStatus.connected)
      .map((e) => e.key)
      .toList();

  List<String> get sentPendingIds => outgoing.entries
      .where((e) => e.value == ConnectionStatus.pending)
      .map((e) => e.key)
      .toList();
}

class ConnectionsNotifier extends Notifier<ConnectionsState> {
  @override
  ConnectionsState build() => const ConnectionsState(
        outgoing: {
          'u2': ConnectionStatus.connected,
          'u3': ConnectionStatus.connected,
          'u5': ConnectionStatus.connected,
          'u7': ConnectionStatus.connected,
          'u9': ConnectionStatus.connected,
        },
        incomingRequests: {'u4', 'u8'},
      );

  void connect(String userId) {
    state = state.copyWith(
      outgoing: {...state.outgoing, userId: ConnectionStatus.pending},
    );
  }

  void accept(String userId) {
    final incoming = Set<String>.from(state.incomingRequests)..remove(userId);
    state = state.copyWith(
      outgoing: {...state.outgoing, userId: ConnectionStatus.connected},
      incomingRequests: incoming,
    );
  }

  void decline(String userId) {
    final incoming = Set<String>.from(state.incomingRequests)..remove(userId);
    state = state.copyWith(incomingRequests: incoming);
  }

  void withdraw(String userId) {
    final updated = Map<String, ConnectionStatus>.from(state.outgoing)
      ..remove(userId);
    state = state.copyWith(outgoing: updated);
  }

  void disconnect(String userId) {
    final updated = Map<String, ConnectionStatus>.from(state.outgoing)
      ..remove(userId);
    state = state.copyWith(outgoing: updated);
  }
}

final connectionsProvider =
    NotifierProvider<ConnectionsNotifier, ConnectionsState>(
  ConnectionsNotifier.new,
);
