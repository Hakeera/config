local M = {}

-- Função para verificar se o LSP está funcionando
function M.check_lsp()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    print("❌ Nenhum cliente LSP ativo")
    return false
  end
  
  for _, client in ipairs(clients) do
    print("✅ Cliente LSP ativo: " .. client.name)
    if client.name == "gopls" then
      print("✅ gopls está rodando")
      print("   - Capabilities: " .. vim.inspect(client.server_capabilities))
    end
  end
  return true
end

-- Função para verificar se o nvim-cmp está funcionando
function M.check_cmp()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    print("❌ nvim-cmp não está carregado")
    return false
  end
  
  print("✅ nvim-cmp está carregado")
  
  -- Verificar sources
  local sources = cmp.get_config().sources
  if sources then
    print("✅ Sources do cmp:")
    for i, source_group in ipairs(sources) do
      for j, source in ipairs(source_group) do
        print("   - " .. source.name)
      end
    end
  end
  
  return true
end

-- Função para verificar se o cmp_nvim_lsp está funcionando
function M.check_cmp_lsp()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if not ok then
    print("❌ cmp_nvim_lsp não está carregado")
    return false
  end
  
  print("✅ cmp_nvim_lsp está carregado")
  return true
end

-- Função para verificar snippets
function M.check_snippets()
  local ok, luasnip = pcall(require, "luasnip")
  if not ok then
    print("❌ LuaSnip não está carregado")
    return false
  end
  
  print("✅ LuaSnip está carregado")
  
  -- Verificar se há snippets carregados
  local snippets = luasnip.get_snippets("go")
  if snippets and #snippets > 0 then
    print("✅ " .. #snippets .. " snippets Go carregados")
  else
    print("⚠️  Nenhum snippet Go encontrado")
  end
  
  return true
end

-- Função para verificar tudo
function M.check_all()
  print("=== Verificação da configuração ===")
  M.check_lsp()
  M.check_cmp()
  M.check_cmp_lsp()
  M.check_snippets()
  print("=== Fim da verificação ===")
end

-- Comandos para usar no Neovim
vim.api.nvim_create_user_command("CheckLSP", M.check_lsp, {})
vim.api.nvim_create_user_command("CheckCmp", M.check_cmp, {})
vim.api.nvim_create_user_command("CheckAll", M.check_all, {})

return M
