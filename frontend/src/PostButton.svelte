<script lang="ts">
    export let label = "Button";
    export let url = "/";
    export let json = {};
    export let active = true;

    function handlePost() {
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
    class="w-full my-2 p-2 bg-blue-400 hover:bg-blue-300 rounded"
    on:click={handlePost}
    disabled={!active}
>
    {label}
</button>
