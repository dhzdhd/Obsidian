<script lang="ts">
  import { goto } from '$app/navigation';
</script>

<div class="flex h-screen w-screen flex-col items-center justify-center gap-10 bg-gray-800">
  <h1 class="text-6xl font-semibold text-green-500">Page does not exist!</h1>
  <button
    on:click={() => goto('/')}
    class="ml-4 rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
    >Go back</button
  >
</div>
