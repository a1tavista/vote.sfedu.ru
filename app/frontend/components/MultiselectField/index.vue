<template>
  <div>
    <multiselect v-model="selectValue"
                 :options="options"
                 :multiple="true"
                 :close-on-select="false"
                 :clear-on-select="false"
                 :hide-selected="true"
                 :preserve-search="true"
                 placeholder="Выберите или начните вводить"
                 label="name"
                 track-by="name"
                 select-label="Нажмите Enter">
      <template slot="noResult" scope="props">Ничего не найдено</template>
      <template slot="tag" scope="props">
              <span class="multiselect__custom-tag">
                <span class="multiselect__value" v-text="props.option.name"></span>
                <span class="multiselect__custom-remove" @click="props.remove(props.option)"></span>
              </span>
      </template>
    </multiselect>
    <div style="display: none" ref="options">
      <slot></slot>
    </div>
    <input v-for="optionId in selectedIds" type="hidden" :name="name" :value="optionId">
    <input v-if="selectedIds.length === 0" type="hidden" :name="name" value="">
  </div>
</template>

<script>
  import Multiselect from 'vue-multiselect';

  export default {
    data() {
      return {
        selectValue: [],
        options: [],
      }
    },
    mounted() {
      const options = this.$refs.options.querySelectorAll('option');
      options.forEach(option => {
        const optionObject = {
          id: option.value,
          name: option.innerHTML
        };

        this.options.push(optionObject);
        if(option.selected) {
          this.selectValue.push(optionObject);
        }
      });
    },
    computed: {
      selectedIds() {
        if (this.selectValue.length === 0)
          return [];
        return this.selectValue.map((option) => option.id);
      }
    },
    components: {
      Multiselect
    },
    props: {
      name: {
        type: String,
        required: true
      },
      id: {
        type: String
      }
    }
  }
</script>
