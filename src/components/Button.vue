<script lang="ts" setup>
const { variant = 'primary' } = defineProps<{
  variant?: 'primary' | 'secondary'
}>()
</script>

<template>
  <button
    class="flex-center cursor-pointer px-3 mx-2 leading-6"
    :class="`button-${variant}`"
  >
    <slot />
  </button>
</template>

<style>
.button-primary {
  box-sizing: border-box;
  background: linear-gradient(to top, #9352a1 60%, #a460b2 20%);
  box-shadow: 0 5px #534775, 0 -5px #a460b2, 0 10px #000, 0 -10px #000,
    -5px 0 #534775, -10px 0 #000, 5px 0 #534775, 10px 0 #000, 5px 5px #000,
    -5px -5px #000, -5px 5px #000, 5px -5px #000, inset 0 -5px #534775;
}

.button-primary:active,
.button-primary:hover {
  box-sizing: border-box;
  background: linear-gradient(to top, #b175be 60%, #c38cce 20%);
  box-shadow: 0 5px #6b5d92, 0 -5px #c38cce, 0 10px #000, 0 -10px #000,
    -5px 0 #6b5d92, -10px 0 #000, 5px 0 #6b5d92, 10px 0 #000, 5px 5px #000,
    -5px -5px #000, -5px 5px #000, 5px -5px #000, inset 0 -5px #6b5d92;
}

.button-secondary {
  box-sizing: border-box;
  background: linear-gradient(to top, #DB0000 60%, #FF0000 20%);
  box-shadow: 0 5px #B60000, 0 -5px #FF0000, 0 10px #000, 0 -10px #000,
    -5px 0 #B60000, -10px 0 #000, 5px 0 #B60000, 10px 0 #000, 5px 5px #000,
    -5px -5px #000, -5px 5px #000, 5px -5px #000, inset 0 -5px #B60000;
}

.button-secondary:active,
.button-secondary:hover {
  box-sizing: border-box;
  background: linear-gradient(to top, #FF4949 60%, #FF6D6D 20%);
  box-shadow: 0 5px #ED0000, 0 -5px #FF6D6D, 0 10px #000, 0 -10px #000,
    -5px 0 #ED0000, -10px 0 #000, 5px 0 #ED0000, 10px 0 #000, 5px 5px #000,
    -5px -5px #000, -5px 5px #000, 5px -5px #000, inset 0 -5px #ED0000;
}
</style>
