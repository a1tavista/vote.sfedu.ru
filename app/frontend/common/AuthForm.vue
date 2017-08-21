<script>
  export default {
    data() {
      return {
        identityName: ''
      };
    },
    computed: {
      identityUrl() {
        return `https://openid.sfedu.ru/server.php/idpage?user=${this.identityName}`;
      }
    },
    props: ['path', 'name']
  }
</script>

<template>
  <form :action="path" method="post" class="authorization">
    <input class="authorization__text-field" type="text" placeholder="Логин на sfedu.ru" v-model="identityName">
    <input type="hidden" :name="name" v-model="identityUrl">
    <slot></slot>
    <button class="authorization__submit-button">Войти</button>
  </form>
</template>
