<template>
  <div class="page">
    <h1 class="page__title">{{ teacher.name }}</h1>
    <p class="page__subtitle">Тут предметы, которые преподает препод.</p>
    <el-divider></el-divider>
    <div>
      <template v-if="formState.done">
        <div style="display: flex; align-items: center; margin-bottom: 16px;">
          <check-mark></check-mark>
          <span style="margin-left: 8px;">Ваше мнение принято. Спасибо за участие!</span>
        </div>
        <el-button @click="$router.push({ path: `/stages/${stage.id}` })" type="success">Вернуться к списку преподавателей</el-button>
      </template>
      <template v-else>
        <div :gutter="20" v-for="question in questions" style="display: flex; justify-content: space-between; margin: 24px 0;">
          <div style="max-width: 600px;">{{ question.text }}</div>
          <div style="min-width: 200px;">
            <el-radio-group  v-model="question.rate" size="mini">
              <el-radio-button :label="item" v-for="item in 10" />
            </el-radio-group>
          </div>
        </div>

        <el-button
          type="primary"
          style="width: 100%;"
          @click="sendFeedback"
          :disabled="!isSubmitEnabled || formState.sent || formState.done"
        >Проголосовать</el-button>
      </template>
    </div>
  </div>
</template>

<script>
import stagesTeachersService from "../../api/stagesTeachersService";

export default {
  mounted() {
    stagesTeachersService
      .newFeedback(this.$route.params.stageId, this.$route.params.id)
      .then((response) => {
        this.stage = response.data.stage;
        this.teacher = response.data.teacher;
        this.questions = response.data.questions.map((question) => (
          {
            id: question.id,
            text: question.text,
            rate: null
          }
        ));
      });
  },
  data() {
    return {
      stage: {},
      teacher: {},
      questions: [],
      formState: {
        sent: false,
        done: false
      }
    }
  },
  computed: {
    isSubmitEnabled() {
      return this.questions.map((question) => question.rate).every((v) => v != null);
    }
  },
  methods: {
    sendFeedback() {
      const feedback = {
        stageId: this.stage.id,
        teacherId: this.teacher.id,
        answers: this.questions.map((question) => ({ questionId: question.id, rate: question.rate }))
      }

      this.formState.sent = true;

      stagesTeachersService
        .leaveFeedback(feedback)
        .then((_response) => (this.formState.done = true))
        .catch((error) => {
          this.$message({
            message: error.response.data[0],
            type: 'warning'
          });
        });
    }
  },
  components: {
  }
}
</script>
