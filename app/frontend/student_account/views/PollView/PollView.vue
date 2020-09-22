<template>
  <div class="page">
    <h1 class="page__title">{{ poll.title }}</h1>
    <p class="page__subtitle">Выберите кандидатуру из списка ниже, чтобы проголосовать.</p>
    <el-divider></el-divider>
    <div style="margin-top: 16px">
      <template v-if="poll.participated" >
        <div style="display: flex; align-items: center; margin-bottom: 16px;">
          <check-mark v-if="poll.participated"></check-mark>
          <span style="margin-left: 8px;">Ваш голос принят. Спасибо за участие!</span>
        </div>
        <el-button @click="$router.push({ path: `/` })" type="success">Вернуться к списку опросов</el-button>
      </template>
      <template v-else>
        <el-radio-group v-model="pollOptionId" size="small" style="width: 100%;">
          <poll-option v-for="option in poll.options" :option="option" />
        </el-radio-group>
        <el-button
          type="primary"
          style="width: 100%;"
          @click="leaveVoice"
          :disabled="pollOptionId == null"
        >Проголосовать</el-button>
      </template>
    </div>
  </div>
</template>

<script>

import pollsService from "../../api/pollsService";
import PollOption from "./PollOption";
import CheckMark from "../../components/CheckMark";

export default {
  mounted() {
    pollsService.show(this.$route.params.id).then((response) => this.poll = response.data);
  },
  data() {
    return {
      poll: {
        options: []
      },
      pollOptionId: null
    }
  },
  methods: {
    leaveVoice() {
      pollsService.leaveVoice(this.$route.params.id, this.pollOptionId)
        .then((response) => {
          this.poll.participated = true;
        })
        .catch((error) => {
          this.$message({
            message: error.response.data[0],
            type: 'warning'
          });
        });
    }
  },
  components: {
    PollOption,
    CheckMark
  }
}
</script>
