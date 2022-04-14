local function next_tuple(table)
  for k, v in pairs(table) do
    return { k, v }
  end
end

local function apply_action(action, client)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end

  if action.command then
    local command = type(action.command) == 'table' and action.command or action
    local fn = client.commands[command.command] or vim.lsp.commands[command.command]
    if fn then
      local enriched_ctx = vim.deepcopy(ctx)
      enriched_ctx.client_id = client.id
      fn(command, enriched_ctx)
    else
      vim.lsp.buf.execute_command(command)
    end
  end
end

local function do_action(action_tuple)
  if not action_tuple then
    return
  end

  local client = vim.lsp.get_client_by_id(action_tuple[1])
  local action = action_tuple[2]
  if not action.edit
      and client
      and type(client.resolved_capabilities.code_action) == 'table'
      and client.resolved_capabilities.code_action.resolveProvider then

    client.request('codeAction/resolve', action, function(err, resolved_action)
      if err then
        vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
        return
      end
      apply_action(resolved_action, client)
    end)
  else
    apply_action(action, client)
  end
end

local function on_quickfix_results(results)
  local quickfixes = {}
  for client_id, result in pairs(results) do
    for _, action in pairs(result.result or {}) do
      table.insert(quickfixes, { client_id, action })
    end
  end

  if #quickfixes == 0 then
    vim.notify('No quickfixes available', vim.log.levels.INFO)
    return
  end

  if #quickfixes == 1 then
    for client_id, quickfix in pairs(quickfixes) do
      local title = quickfix[2].title:gsub('\r\n', '\\r\\n')
      vim.notify(string.format(
        'Quickfix: %s',
        title:gsub('\n', '\\n')
      ), vim.log.levels.INFO)
      do_action(quickfix)
      return
    end
  end

  vim.ui.select(quickfixes, {
    prompt = 'Code actions:',
    kind = 'codeaction',
    format_item = function(quickfix_tuple)
      local title = quickfix_tuple[2].title:gsub('\r\n', '\\r\\n')
      return title:gsub('\n', '\\n')
    end,
  }, do_action)
end

return function() 
  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
    only = {"quickfix"}
  }

  vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(results)
    on_quickfix_results(results)
  end)
end

-- vim:sw=2 ts=2 et
