<template>
  <div id="app">
    <SimonTheGame/>
  </div>
</template>

<script>
import SimonTheGame from './components/SimonTheGame.vue'

export default {
  name: 'App',
  components: {
    SimonTheGame
  }
}
</script>

<style>
body {
    background-color: #C3C3C3;
}

#app {
  font-family: Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 40px;
}
</style>
