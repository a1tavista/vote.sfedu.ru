<script>
  export default {
    data() {
      return {
        chosenOptions: [],
        freeAnswer: null,
      }
    },
    computed: {
      freeAnswerChoosed() {
        if(this.options.length == 0 && this.free)
          return true;
        return this.handledAnswers.indexOf("free") > -1;
      },
      handledAnswers() {
        let options = [];
        if(!this.multichoice) {
          options.push(this.chosenOptions);
        } else {
          options = Object.assign([], this.chosenOptions);
        }
        return options;
      }
    },
    watch: {
      chosenOptions() {
        this.$emit('input', {
          options: this.handledAnswers.filter(Number),
          text: this.freeAnswerChoosed ? this.freeAnswer : null
        });
      },
      freeAnswer() {
        this.$emit('input', {
          options: this.handledAnswers.filter(Number),
          text: this.freeAnswerChoosed ? this.freeAnswer : null
        });
      }
    },
    methods: {
      optionID(id) {
        return `option${id}`
      }
    },
    props: ['required', 'text', 'multichoice', 'free', 'options', 'value']
  }
</script>

<template>
  <div class="survey-form-question">
    <h3 class="survey-form-question__title">
      <span v-if="required">* </span>{{ text }}
    </h3>
    <div class="survey-form-question__options">
      <div class="survey-form-question__option" v-for="item in options">
        <div class="survey-form-question__option-box">
          <input type="checkbox" :id="optionID(item.id)" :value='item.id' v-model='chosenOptions' v-if='multichoice'>
          <input type="radio" :id="optionID(item.id)" :value='item.id' v-model='chosenOptions' v-else>
        </div>
        <label class="survey-form-question__option-label" :for="optionID(item.id)">
          {{ item.text }}
        </label>
      </div>

      <div class="survey-form-question__option" v-if="free && options.length > 0">
        <div class="survey-form-question__option-box">
          <input type="checkbox" value='free' v-model='chosenOptions' v-if='multichoice'>
          <input type="radio" value='free' v-model='chosenOptions' v-else>
        </div>
        <div class="survey-form-question__option-text">
          <input type="text" v-model="freeAnswer" placeholder="Укажите Ваш ответ" :disabled="!freeAnswerChoosed">
        </div>
      </div>

      <div class="survey-form-question__option" v-else-if="free && options.length == 0">
        <div class="survey-form-question__option-text">
          <textarea v-model="freeAnswer" placeholder="Укажите Ваш ответ"></textarea>
        </div>
      </div>
    </div>
  </div>
</template>
