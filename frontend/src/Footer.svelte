<script lang="ts">
    export let org = "Organization";

    async function getRequest() {
        let response = await fetch("/getInfo");
        let data = await response.json();

        if (response.ok) {
            org = data.organization;
            return data;
        } else {
            throw new Error("Couldn't fetch data.");
        }
    }

    let promise = getRequest();
    // setInterval(() => {
    //     promise = getRequest();
    // }, 10 * 1000);
</script>

<div
    class="absolute bottom-0 left-0 w-screen bg-gray-600 text-center text-white text-xl p-2"
>
    {#await promise}
        <p>...verbinden</p>
    {:then data}
        <p>
            {data.organization} 🌐 {data.peer}
        </p>
    {:catch error}
        <p class="bg-red-600">Keine Verbindung</p>
    {/await}
</div>
