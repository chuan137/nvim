return {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            logLevel = "debug",
            lint = {
                select = { "E", "F" },
            },
        },
    },
}
