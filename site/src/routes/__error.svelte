<script lang="ts">
  import { goto } from '$app/navigation';
</script>

<div class="flex flex-col items-center justify-center w-screen h-screen gap-10 bg-gray-800">
  <h1 class="text-6xl text-green-500 font-semibold">404 | Page does not exist!</h1>
  <button
    on:click={() => goto('/')}
    class="px-6 py-2 ml-4 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
    >Go back</button
  >
</div>
