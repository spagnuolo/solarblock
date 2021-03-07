<script lang="ts">
    import Table from "./Table.svelte";
    import Transaktion from "./Transaktion.svelte";

    let txn;

    function handleBuy() {
        // Send and get json.
        var xhr = new XMLHttpRequest();
        var url = "http://localhost:8080/buyEnergy";
        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var json = JSON.parse(xhr.responseText);
                console.log(json);
            }
        };
        var data = JSON.stringify({
            seller: txn.Record.seller,
            energyNumber: txn.Record.energyNumber,
        });
        console.log(data);
        xhr.send(data);
    }
</script>

<!-- left control -->
<div class="bg-gray-200 w-1/4 h-full text-lg shadow-inner">
    <div class="title">Kaufen</div>
    {#if txn}
        <Transaktion bind:txn />
        <div class="m-full p-2">
            <button
                class="w-full p-2 bg-green-400 hover:bg-green-300 rounded"
                on:click={handleBuy}
            >
                Kaufen?
            </button>
        </div>
    {:else}
        <p class="bg-blue-300 text-center">Wähle ein Angebot aus.</p>
    {/if}
</div>

<!-- right main window -->
<div class="bg-gray-100 w-full h-full text-lg">
    <div class="title">Markplatz</div>
    <Table bind:txn fetchURL={"http://localhost:8080/getSelling"} />
</div>

<style lang="postcss">
    .title {
        @apply my-10 text-3xl ml-10;
    }
</style>
