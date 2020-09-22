<template>
  <el-card>
    <div class="stage-teacher">
      <div class="stage-teacher__name">{{ name }}</div>
      <div class="stage-teacher__action">
        <check-mark v-if="participated" />
        <el-button @click="$router.push({ path: `/stages/${stageId}/teachers/${id}` })" v-else>Заполнить анкету</el-button>
      </div>
    </div>
  </el-card>
</template>

<script>
import CheckMark from "../../components/CheckMark";

export default {
  props: {
    id: Number,
    stageId: Number,
    name: String,
    participated: Boolean
  },
  components: {
    CheckMark
  }
}
</script>
