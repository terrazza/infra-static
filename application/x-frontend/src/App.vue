<template>
  <el-config-provider>
    <el-container>
      <el-header>
        <title-bar></title-bar>
      </el-header>
      <el-container class="overflow-hidden">
        <el-aside width="200px">
          <side-bar class="main"></side-bar>
        </el-aside>
        <el-scrollbar class="main">
          <el-main>
            <router-view></router-view>
          </el-main>
        </el-scrollbar>
      </el-container>
    </el-container>
  </el-config-provider>
</template>

<style>
#app {
  color: var(--el-text-color-primary);
  height: 100vh;
  display: flex;
}

.el-header {
  border-bottom: 1px solid var(--el-border-color);
}
.el-aside .el-menu.main {
  height: 100%;
}
.el-scrollbar.main {
  width: 100%;
}
.action svg.icon {
  height: 1.2rem;
}
</style>
