<script>
  export default {
    data() {
      return {
        identityName: ''
      };
    },
    computed: {
      identityUrl() {
        if(this.identityName) {
          const name = this.identityName.split('@')[0].trim();
          return `https://openid.sfedu.ru/server.php/idpage?user=${name}`;
        }
        else
          return '';
      }
    },
    props: ['path', 'name']
  }
</script>

<template>
  <form :action="path" method="post" class="authorization-form">
    <h3 class="authorization-form__title">Вход в личный кабинет</h3>
    <input class="authorization-form__input" type="text" placeholder="Логин на sfedu.ru" v-model="identityName">
    <input type="hidden" :name="name" v-model="identityUrl">
    <slot></slot>
    <button class="btn authorization-form__submit-button">Войти</button>
  </form>
</template>
