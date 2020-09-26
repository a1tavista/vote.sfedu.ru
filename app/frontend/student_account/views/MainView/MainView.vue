<template>
  <div class="page">
    <h1 class="page__title">Активные опросы</h1>
    <p class="page__subtitle">Выберите активный опрос из списка ниже и помогите университету стать лучше.</p>
    <el-divider></el-divider>
    <template v-if="items.length > 0">
      <app-voting
        v-loading="loading"
        v-for="item in items" :key="item.meta.source"

        :title="item.title"
        :description="item.description"
        :participated="item.participated"
        :starts-at="item.startsAtLocalized"
        :ends-at="item.endsAtLocalized"
        :meta="item.meta"

        style="margin-bottom: 16px;"
      />
    </template>
    <div v-else>
      Нет активных опросов. Приходите позднее и следите за СИЦ вашего структурного подразделения,
      где студенческий совет публикует информацию о предстоящих опросах.
    </div>
  </div>
</template>

<script>
import MainViewVoteCard from "./MainViewVoteCard";
import stagesService from "../../api/stagesService";
import pollsService from "../../api/pollsService";

export default {
  mounted() {
    this.loading = true

    stagesService.index().then((response) => { this.items = this.items.concat(response.data); this.loading = false });
    pollsService.index().then((response) => { this.items = this.items.concat(response.data); this.loading = false; });
  },
  data() {
    return {
      items: [],
      loading: false
    }
  },
  methods: {
  },
  components: {
    AppVoting: MainViewVoteCard
  }
}
</script>
