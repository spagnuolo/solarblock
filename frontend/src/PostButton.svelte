<script lang="ts">
    export let label = "Button";
    export let url = "/";
    export let json = {};

    function handleBuy() {
        // Send and get json.
        let xhr = new XMLHttpRequest();
        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                let responseJSON = JSON.parse(xhr.responseText);
                console.log(responseJSON);
                window.location.href = "/"; // TODO: This is just a hack.
            }
        };
        let data = JSON.stringify(json);
        console.log(data);
        xhr.send(data);
    }
</script>

<button
    class="w-full p-2 bg-green-400 hover:bg-green-300 rounded"
    on:click={handleBuy}
>
    {label}
</button>
