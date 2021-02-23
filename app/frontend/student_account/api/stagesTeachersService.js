import api from '../../api/request';

export default {
  index: (stageId) => api.get(`/api/students_api/stages/${stageId}/teachers.json`),
  rosterIndex: (stageId) => api.get(`/api/students_api/stages/${stageId}/roster.json`),
  newFeedback: (stageId, teacherId) => api.get(`/api/students_api/stages/${stageId}/teachers/${teacherId}/feedback.json`),
  leaveFeedback: (feedback) => api.post(
    `/api/students_api/stages/${feedback.stageId}/teachers/${feedback.teacherId}/feedback.json`,
    { feedback }
  ),
  refreshTeachers: (stageId) => api.post(`/api/students_api/stages/${stageId}/teachers/refresh`)
};
