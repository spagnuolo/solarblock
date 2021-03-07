<script lang="ts">
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    let txn;
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/4 h-full text-lg shadow-inner">
    <div class="title">Info</div>
    {#if txn}
        <Transaktion {txn} />
    {:else}
        <p class="bg-blue-300 text-center">Wähle einen Eintrag aus.</p>
    {/if}
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Meine Energie</div>
    <Table bind:txn fetchURL={"http://localhost:8080/getOwn"} />

    <div class="title">Energie die ich verkaufe</div>
    <Table bind:txn fetchURL={"http://localhost:8080/getOwnSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
