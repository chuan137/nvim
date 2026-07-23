return {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            lineLength = 120,
            logLevel = "debug",
            lint = {
                select = { "E", "F" },
                ignore = { "E722" },
            },
        },
    },
}
