<template>
  <div class="page">
    <h1 class="page__title">Оценка качества преподавания</h1>
    <p class="page__subtitle">Анкеты преподавателей, которые вели дисциплины за указанный период.</p>
    <el-divider></el-divider>
    <div class="stage-teachers-list">
      <div class="stage-teachers-list__actions">
        <el-button size="mini" v-if="stageAttendee.fetchingStatus !== 'in_progress'" @click="refreshTeachers">
          Обновить список преподавателей
        </el-button>
        <el-button size="mini" @click="$router.push({ path: `/stages/${stageId}/teachers` })">
          Выбрать преподавателей из списка
        </el-button>
      </div>

      <template v-if="stageAttendee.fetchingStatus === 'done'">
        <stage-teacher
          class="stage-teachers-list__item"
          v-for="item in items"
          :key="item.id"
          :id="item.id"
          :name="item.name"
          :stage-id="stageId"
          :participated="item.participated"
        />
      </template>
      <template v-else-if="stageAttendee.fetchingStatus === 'in_progress'">
        <div class="stage-teachers-list__message">
          <div :v-loading="true">
            <h1>Загрузка...</h1>
          </div>
          <p>Загружаем список преподавателей. Это может занять некоторое время (от одной до десяти минут).</p>
        </div>
      </template>
      <template v-else-if="stageAttendee.fetchingStatus === 'failed'">
        <div class="stage-teachers-list__message">
          Не удалось получить актуальный список преподавателей.
          Возможно, проблема вызвана техническими работами на стороне 1С:Университет.
          Попробуйте вернуться сюда через несколько часов и попробовать снова обновить список преподавателей.
        </div>
      </template>
      <template v-else-if="stageAttendee.fetchingStatus === 'fresh'">
        <div class="stage-teachers-list__message">
          Добро пожаловать! Нажмите "Обновить список преподавателей", чтобы приступить к оцениванию.
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import StageTeacher from "./StageTeacher";
import stagesTeachersService from "../../api/stagesTeachersService";

export default {
  mounted() {
    this.fetchTeachers();
  },
  data() {
    return {
      items: [],
      stageAttendee: {
        fetchingStatus: 'fresh',
        choosingStatus: 'not_selected'
      },
      attempts: 10
    }
  },
  methods: {
    fetchTeachers() {
      stagesTeachersService.index(this.stageId).then((response) => {
        this.items = this.items.concat(response.data.available);
        this.items = this.items.concat(response.data.evaluated);

        this.stageAttendee.fetchingStatus = response.data.stageAttendee.fetchingStatus;
        this.stageAttendee.choosingStatus = response.data.stageAttendee.choosingStatus;

        if(this.needToRepeatQuery) {
          this.repeatFetching();
        }
      });
    },
    refreshTeachers() {
      stagesTeachersService.refreshTeachers(this.stageId).then((response) => {
        this.stageAttendee.fetchingStatus = 'in_progress';
      }).catch((error) => {
        this.$message({
          message: error.response.data[0],
          type: 'warning'
        });
      })
    },
    repeatFetching() {
      if(this.attempts === 0) {
        this.stageAttendee.fetchingStatus = 'failed';
        return;
      }

      setTimeout(() => { this.fetchTeachers(); this.attempts -= 1; }, 5000);
    }
  },
  computed: {
    stageId() {
      return this.$route.params.id;
    },
    needToRepeatQuery() {
      return this.stageAttendee.fetchingStatus === 'in_progress';
    }
  },
  components: {
    StageTeacher
  }
}
</script>
