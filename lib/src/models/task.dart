class Task {
  const Task(
    this.title,
    this.isCompleted,
  );

  final String title;
  final bool isCompleted;

  Task copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      title ?? this.title,
      isCompleted ?? this.isCompleted,
    );
  }
}
