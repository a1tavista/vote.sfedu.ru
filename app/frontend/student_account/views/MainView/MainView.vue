<template>
  <div class="page">
    <h1 class="page__title">Активные опросы</h1>
    <p class="page__subtitle">Выберите активный опрос из списка ниже и помогите университету стать лучше.</p>
    <el-divider></el-divider>
    <template v-if="items.length > 0">
      <app-voting
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
      <div v-loading="loading" v-if="attempts > 0">
        <h1>Загрузка...</h1>
      </div>
      <p v-else>
        Нет активных опросов. Приходите позднее и следите за СИЦ вашего структурного подразделения,
        где студенческий совет публикует информацию о предстоящих опросах.
      </p>
      <p>
        Если вы не видите опрос по вашему актуальному структурному подразделению, то попробуйте зайти сюда через пару минут.
        Возможно, мы не можем получить ваши зачётные книжки из 1С:Университет.
      </p>
    </div>
  </div>
</template>

<script>
import MainViewVoteCard from "./MainViewVoteCard";
import stagesService from "../../api/stagesService";
import pollsService from "../../api/pollsService";

export default {
  mounted() {
    this.loading = true;
    this.fetchData();
  },
  data() {
    return {
      items: [],
      loading: false,
      attempts: 10
    }
  },
  methods: {
    fetchData() {
      pollsService.index().then((response) => {
        this.items = this.items.concat(response.data);
        this.loading = response.data.length === 0;
        if(response.data.length === 0) setTimeout(() => { this.fetchData(); this.attempts -= 1; }, 5000);
      });
    }
  },
  components: {
    AppVoting: MainViewVoteCard
  }
}
</script>
