module Events
  RegisteredNewUser = Class.new(RailsEventStore::Event)
  UserAuthenticated = Class.new(RailsEventStore::Event)

  RegisteredNewStudent = Class.new(RailsEventStore::Event)
  StudentDroppedTeachersList = Class.new(RailsEventStore::Event)
  StudentRequestedTeachers = Class.new(RailsEventStore::Event)

  ReceivedInvalidTeacher = Class.new(RailsEventStore::Event)

  NewAnswerReceived = Class.new(RailsEventStore::Event)
end
