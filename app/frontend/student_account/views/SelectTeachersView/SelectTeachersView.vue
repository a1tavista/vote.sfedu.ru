<template>
  <div class="page">
    <h1 class="page__title">Добавление преподавателей в список</h1>
    <p class="page__subtitle">Ниже представлены анкеты преподавателей, которые можно свободно добавить в список.</p>
    <el-divider></el-divider>
    <el-table
      :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
      style="width: 100%">
      <el-table-column
        label="Фамилия, имя, отчество"
        prop="name">
      </el-table-column>
      <el-table-column
        align="right">
        <template slot="header" slot-scope="scope">
          <el-input
            v-model="search"
            size="mini"
            placeholder="Начните вводить для поиска..."/>
        </template>
        <template slot-scope="scope">
          <el-button
            size="medium"
            :type="scope.row.selected ? 'danger' : 'normal'"
            @click="handleClick(scope.$index, scope.row)"
            :disabled="scope.row.formState === 'sent'"
          >
            <i :class="scope.row.selected ? 'el-icon-remove' : 'el-icon-circle-plus'"></i>
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import stagesTeachersService from "../../api/stagesTeachersService";
import stagesTeachersRelationsService from "../../api/stagesTeachersRelationsService";

export default {
  data() {
    return {
      tableData: [],
      search: '',
    }
  },
  mounted() {
    stagesTeachersService.rosterIndex(this.stageId).then((response) => {
      this.tableData = this.tableData.concat(response.data.availableTeachers);
      this.tableData = this.tableData.concat(response.data.selectedTeachers);
      this.tableData.map(teacher => teacher.formState = 'initial');
    });
  },
  computed: {
    stageId() {
      return this.$route.params.id;
    }
  },
  methods: {
    handleClick(index, row) {
      if(row.formState === 'sent')
        return;

      if(!row.selected) {
        stagesTeachersRelationsService.addRelation(this.stageId, row.id).then(_ => {
          row.selected = true;
          row.formState = 'initial';
          this.$message({
            message: `${row.name} успешно добавлен(а) в список для оценивания`
          });
        }).catch((error) => {
          row.formState = 'failed';
          this.$message({
            message: error.response.data[0],
            type: 'warning'
          });
        });
      } else {
        stagesTeachersRelationsService.removeRelation(this.stageId, row.id)
          .then(_ => {
            row.selected = false;
            row.formState = 'initial';
            this.$message({
              message: `${row.name} успешно удален(а) из списка для оценивания`
            });
          })
          .catch((error) => {
            row.formState = 'failed';
            this.$message({
              message: error.response.data[0],
              type: 'warning'
            });
          });
      }

      row.formState = 'sent';
      console.log(index, row);
    }
  },
}
</script>
