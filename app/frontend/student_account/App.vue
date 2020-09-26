<template>
  <el-container>

    <el-main>
      <router-view></router-view>
    </el-main>
  </el-container>
</template>

<script>
import MainView from "./views/MainView/MainView";
import PollView from "./views/PollView/PollView";

export default {
  components: {
    MainView,
    PollView
  }
}
</script>
