import Vue from 'vue';
import AuthForm from '../common/AuthForm.vue';
import SurveyForm from '../components/SurveyForm';
import MultiselectField from '../components/MultiselectField';
import Notifications from 'vue-notification';

Vue.use(Notifications);

new Vue({
  el: '#common-app',
  components: {
    AuthForm,
    SurveyForm,
    MultiselectField,
  }
});
