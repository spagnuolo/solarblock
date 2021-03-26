<script lang="ts">
  import Create from "./Create.svelte";
  import Energy from "./Energy.svelte";
  import Footer from "./Footer.svelte";
  import Market from "./Market.svelte";
  import Tailwind from "./Tailwind.svelte";

  let credits = 0;
  async function getCredits() {
    const response = await fetch("/getCredits");
    let data = await response.json();

    if (response.ok) {
      credits = data;
      return data;
    } else {
      throw new Error("Couldn't fetch data.");
    }
  }
  getCredits();

  let panels = [
    { emoji: "⚡", active: true, component: "Energy", name: "Meine Energie" },
    { emoji: "🛒", active: false, component: "Market", name: "Marktplatz" },
    // { emoji: "🔍", active: false, component: "", name: "" },
    // { emoji: "⚙️", active: false, component: "", name: "" },
  ];

  // Add create panel only for OrgNetzbetreiber.
  let org = "";
  $: if (org === "OrgNetzbetreiber") {
    addCreatePanel();
  }

  function addCreatePanel() {
    panels = [
      ...panels,
      { emoji: "🔌", active: false, component: "", name: "Create" },
    ];
  }

  // Highlight only the selected panel.
  function handleSelection(index: number) {
    // Update credits.
    getCredits();

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
<main class="w-screen h-screen flex flex-col">
  <div class="w-full h-full flex">
    <!-- left sidebar -->
    <div class="bg-gray-100">
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
      <Energy {credits} />
    {:else if panels[1].active}
      <Market {credits} />
    {:else if panels[2].active}
      <Create />
    {/if}
  </div>

  <!-- footer -->
  <Footer bind:org />
</main>

<style>
  .selected {
    @apply bg-blue-400;
  }
</style>
