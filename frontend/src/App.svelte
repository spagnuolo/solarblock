<script lang="ts">
  import Market from "./Market.svelte";
  import Tailwind from "./Tailwind.svelte";

  const emojis = ["🛒", "💰", "🔍", "🗑️", "⚙️"];
</script>

<Tailwind />

<!-- screen -->
<main class="w-scree h-screen flex">
  <!-- left sidebar -->
  <div class="bg-gray-100 border-r-2">
    {#each emojis as emoji}
      <div class="rounded-full h-16 w-16 m-3 bg-gray-200 hover:bg-gray-300">
        <div class="flex justify-center items-center w-full h-full text-3xl">
          {emoji}
        </div>
      </div>
    {/each}
  </div>

  <!-- main -->
  <Market />
</main>
