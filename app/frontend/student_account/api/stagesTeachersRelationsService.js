import api from '../../api/request';

export default {
  addRelation: (stageId, teacherId) => api.post(`/api/students_api/stages/${stageId}/teachers/${teacherId}/relation.json`),
  removeRelation: (stageId, teacherId) => api.delete(`/api/students_api/stages/${stageId}/teachers/${teacherId}/relation.json`)
};
