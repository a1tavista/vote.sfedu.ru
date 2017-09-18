<script>
  import Question from './Question.vue';
  import request from '../../api/request';

  export default {
    data() {
      return {
        questions: {},
        answers: {},
        finished: false
      };
    },
    computed: {
      requiredQuestionsKeys() {
        let requiredKeys = [];
        for (let key in this.questions) {
          if (this.questions.hasOwnProperty(key)) {
            if (this.questions[key].required)
              requiredKeys.push(key);
          }
        }
        return requiredKeys;
      },
      answeredQuestionsKeys() {
        let answersFilled = [];
        for (let key in this.answers) {
          if (this.answers.hasOwnProperty(key)) {
            const answer = this.answers[key];
            if ((answer.options.length > 0 || answer.text !== null))
              answersFilled.push(key);
          }
        }
        return answersFilled;
      }
    },
    methods: {
      validateForm() {
        const vm = this;
        let success = true;
        this.requiredQuestionsKeys.forEach((key) => {
          if (+vm.answeredQuestionsKeys.indexOf(key) === -1) {
            success = false
          }
        });
        return success;
      },
      sendFormAnswer() {
        const vm = this;
        if (this.validateForm()) {
          request.post(`/api/surveys/${this.id}/answers.json`, {
              answers: this.answers
            })
            .then((response) => {
              vm.finished = true;
            }).catch((response) => {
              vm.$notify({
                title: 'Что-то пошло не так :(',
                type: 'warning',
                position: 'bottom center',
                text: 'Скорее всего, мы уже знаем о случившемся и спешим Вам на помощь.'
              });
            });
        } else {
          this.$notify({
            title: 'Ошибка :(',
            type: 'warning',
            position: 'bottom center',
            text: 'Вы ответили не на все обязательные вопросы анкеты.'
          });
        }
      }
    },
    mounted() {
      const vm = this;
      request.get(`/api/surveys/${this.id}/questions.json`)
        .then((response) => {
          vm.questions = response.data;
        });
    },
    components: {Question},
    props: ['id']
  }
</script>

<template>
  <div>
    <div class="survey-form" v-if="!finished">
      <question
        v-for="q in questions"
        :required="q.required"
        :text="q.text"
        :options="q.options"
        :free="q.freeAnswer"
        :multichoice="q.multichoice"
        v-model="answers[q.id]"
      ></question>
      <button class='btn' @click="sendFormAnswer" :disabled="!validateForm">Отправить ответ</button>
    </div>
    <div class="note" v-else>
      <p>Спасибо за участие в опросе!</p>
    </div>
  </div>
</template>
