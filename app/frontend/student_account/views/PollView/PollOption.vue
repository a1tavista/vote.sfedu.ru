<template>
  <el-card style="margin-bottom: 16px; width: 100%;">
    <el-radio :label="option.id" style="display: flex; align-items: center;">
      <div style="margin-left: 16px;">
        <h3>{{ option.title }}</h3>
        <p>{{ option.description }}</p>
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
