import axios from 'axios';

const request = axios.create({
  timeout: 5000,
});

request.interceptors.request.use(config => {
  let csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  config.headers['X-CSRF-Token'] = csrfToken;

  return config;
});

export default request;
