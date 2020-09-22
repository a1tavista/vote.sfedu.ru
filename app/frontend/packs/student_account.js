import Vue from 'vue';
import router from '../student_account/router';

import ElementUI from 'element-ui';
import locale from 'element-ui/lib/locale/lang/en';
Vue.use(ElementUI, { locale });

import App from '../student_account/App.vue';

const app = new Vue({el: '#application', router, render: h => h(App)});
export {app, router}
