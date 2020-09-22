<template>
  <el-card class="voting">
    <div slot="header" class="voting__header">
      <span class="voting__title">{{ title }}</span>
    </div>
    <div class="voting-description">
      <p class="voting-description__item voting-description__item_lg-offset" v-if="!!description">
        {{ description }}
      </p>
      <div class="voting-description__item voting-description__item_lg-offset">
        <dl class="voting-property voting-description__item">
          <dt class="voting-property__name">Начало</dt>
          <dd class="voting-property__value">{{ startsAt }}</dd>
        </dl>
        <dl class="voting-property voting-description__item">
          <dt class="voting-property__name">Завершение</dt>
          <dd class="voting-property__value">{{ endsAt }}</dd>
        </dl>
      </div>
    </div>
    <div class="voting__action">
      <template v-if="participated">
        <check-mark v-if="participated"></check-mark>
        <span style="margin-left: 8px;">Спасибо за участие!</span>
      </template>
      <el-button @click="$router.push({ path: `/${meta.resource}/${meta.id}` })" v-else>Перейти к опросу</el-button>
    </div>
  </el-card>
</template>

<script>
import CheckMark from "../../components/CheckMark";

export default {
  props: {
    title: String,
    description: String,
    startsAt: String,
    endsAt: String,
    participated: Boolean,
    meta: Object
  },
  components: {
    CheckMark
  }
}
</script>
