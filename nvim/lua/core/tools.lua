local M = {}

local function get_tools()
    local lsps = { "lua_ls" }
    local linters = { "selene" }
    local formatters = { "luaformatter" }

    local function add_if_exist(binary, list, items)
        if vim.fn.executable(binary) == 1 then
            for _, item in ipairs(items) do
                table.insert(list, item)
            end
        end
    end

    add_if_exist("python3", lsps, { "pyright", "yamlls" })
    add_if_exist("ansible", lsps, { "ansiblels" })
    add_if_exist("sh", lsps, { "bashls", "dockerls" })
    add_if_exist("terraform", lsps, { "terraformls" })
    add_if_exist("node", lsps, { "jsonls", "eslint-lsp" })
    add_if_exist("go", lsps, { "gopls" })

    add_if_exist("python3", linters, { "bandit", "yamllint" })
    add_if_exist("ansible", linters, { "ansible-lint" })
    add_if_exist("sh", linters, { "shellcheck", "hadolint", "actionlint" })
    add_if_exist("terraform", linters, { "tflint" })
    add_if_exist("node", linters, { "jsonlint", "eslint_d" })
    add_if_exist("go", linters, { "golangci-lint" })

    add_if_exist("python3", formatters, { "black" })
    add_if_exist("sh", formatters, { "beautysh" })
    add_if_exist("terraform", formatters, { "terraform" })
    add_if_exist("node", formatters, { "prettier", "prettierd" })
    add_if_exist("go", formatters, { "gofumpt" })

    return lsps, linters, formatters
end

local lsps, linters, formatters = get_tools()

M.lsp_to_install = lsps
M.linters_to_install = linters
M.formatters_to_install = formatters

M.all_tools = {}

for _, item in ipairs(linters) do
    table.insert(M.all_tools, item)
end

for _, item in ipairs(formatters) do
    table.insert(M.all_tools, item)
end

return M
