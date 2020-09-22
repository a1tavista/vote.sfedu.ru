import api from '../../api/request';

export default {
  index: () => api.get('/api/students_api/polls.json'),
  show: (pollId) => api.get(`/api/students_api/polls/${pollId}.json`),
  leaveVoice: (pollId, pollOptionId) => api.post(`/api/students_api/polls/${pollId}/vote.json`, { pollOptionId})
};
