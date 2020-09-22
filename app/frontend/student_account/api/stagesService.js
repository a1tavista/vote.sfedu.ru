import api from '../../api/request';

export default {
  index: () => api.get('/api/students_api/stages.json'),
};
