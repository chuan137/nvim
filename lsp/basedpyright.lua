return {
    settings = {
        basedpyright = {
            analysis = {
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "none",
                },
                inlayHints = {
                    callArgumentNames = true,
                    variableTypes = true,
                },
                typeCheckingMode = "standard",
            },
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
            },
        },
    },
}
