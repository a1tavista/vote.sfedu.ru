<template>
  <div class="page">
    <h1 class="page__title">Оценка качества преподавания</h1>
    <p class="page__subtitle">Анкеты преподавателей, которые вели дисциплины за указанный период.</p>
    <el-divider></el-divider>
    <div class="stage-teachers-list">
      <stage-teacher
        class="stage-teachers-list__item"
        v-for="item in items"
        :key="item.id"
        :id="item.id"
        :name="item.name"
        :stage-id="7"
        :participated="item.participated"
      />
    </div>
  </div>
</template>

<script>
import StageTeacher from "./StageTeacher";
import stagesTeachersService from "../../api/stagesTeachersService";

export default {
  mounted() {
    stagesTeachersService.index(this.$route.params.id).then((response) => {
      this.items = this.items.concat(response.data.available);
      this.items = this.items.concat(response.data.evaluated);
    });
  },
  data() {
    return {
      items: []
    }
  },
  methods: {
  },
  components: {
    StageTeacher
  }
}
</script>
