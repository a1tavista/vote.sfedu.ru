<template>
  <el-card style="margin-bottom: 16px; width: 100%;">
    <el-radio :label="option.id" style="display: flex; align-items: center;">
      <div class="poll-option">
        <div
          v-if="option.imageUrl"
          class="poll-option__image"
          :style="`background-image: url(${option.imageUrl});`"
        />
        <div class="poll-option__info">
          <h3>{{ option.title }}</h3>
          <p>{{ option.description }}</p>
        </div>
      </div>
    </el-radio>
  </el-card>
</template>

<script>
import CheckMark from "../../components/CheckMark";

export default {
  props: {
    option: Object
  },
  components: {
    CheckMark
  }
}
</script>
