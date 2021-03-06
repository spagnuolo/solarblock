<script lang="ts">
  import Energy from "./Energy.svelte";
  import Market from "./Market.svelte";
  import Tailwind from "./Tailwind.svelte";

  const panels = [
    { name: "Meine Energie", emoji: "⚡", active: true },
    { name: "Marktplatz", emoji: "🛒", active: false },
    { name: "", emoji: "🔍", active: false },
    { name: "", emoji: "🗑️", active: false },
    { name: "", emoji: "⚙️", active: false },
  ];

  function handleSelection(index: number) {
    // Deactivate all.
    for (let i = 0; i < panels.length; i++) {
      panels[i].active = false;
    }

    // Activate selection.
    panels[index].active = true;
  }
</script>

<Tailwind />

<!-- screen -->
<main class="w-scree h-screen flex">
  <!-- left sidebar -->
  <div class="bg-gray-100 border-r-2">
    {#each panels as panel, index}
      <div
        class="{panel.active
          ? 'selected'
          : ''} rounded-full h-16 w-16 m-3 bg-gray-200 hover:bg-gray-300 cursor-pointer"
        on:click={() => handleSelection(index)}
      >
        <div class="flex justify-center items-center w-full h-full text-3xl">
          {panel.emoji}
        </div>
      </div>
    {/each}
  </div>

  <!-- main -->
  {#if panels[0].active}
    <Energy />
  {:else if panels[1].active}
    <Market />
  {/if}
</main>

<style>
  .selected {
    @apply bg-blue-300;
  }
</style>
