import Vue from 'vue'
import Router from 'vue-router'
import MainView from "../views/MainView/MainView";
import PollView from "../views/PollView/PollView";
import StageTeachersView from "../views/StageTeachersView/StageTeachersView";
import StageFeedbackView from "../views/StageFeedbackView/StageFeedbackView";
import SelectTeachersView from "../views/SelectTeachersView/SelectTeachersView";

Vue.use(Router);

export default new Router({
  mode: 'history',
  base: '/student',
  scrollBehavior: () => ({y: 0}),
  routes: [
    { path: '/', component: MainView },
    { path: '/polls/:id', component: PollView },
    { path: '/stages/:id', component: StageTeachersView },
    { path: '/stages/:stageId/teachers/:id', component: StageFeedbackView },
    { path: '/stages/:id/teachers', component: SelectTeachersView }
  ]
})
