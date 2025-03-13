local dingllm = require 'dingllm'

local system_prompt =
  'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far.'

-- Define your models and their functions
local models = {
  {
    key = 'g',
    name = 'Groq',
    func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.groq.com/openai/v1/chat/completions',
        model = 'llama-3.1-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.groq.com/openai/v1/chat/completions',
        model = 'llama-3.1-70b-versatile',
        api_key_name = 'GROQ_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
  },
  {
    key = 'l',
    name = 'Llama405b-Instruct',
    func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://openrouter.ai/api/v1/chat/completions',
        model = 'nousresearch/hermes-3-llama-3.1-405b:extended',
        api_key_name = 'OPENROUTER_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://openrouter.ai/api/v1/chat/completions',
        model = 'nousresearch/hermes-3-llama-3.1-405b:extended',
        api_key_name = 'OPENROUTER_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
  },
  {
    key = 'b',
    name = 'Llama405b-BASE',
    func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://openrouter.ai/api/v1/chat/completions',
        model = 'meta-llama/llama-3.1-405b',
        api_key_name = 'OPENROUTER_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
        max_tokens = 1024,
        stop = { '\n\n' },
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://openrouter.ai/api/v1/chat/completions',
        model = 'meta-llama/llama-3.1-405b',
        api_key_name = 'OPENROUTER_API_KEY',
        system_prompt = system_prompt,
        replace = true,
        max_tokens = 1024,
        stop = { '\n\n' },
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
  },
  {
    key = 'c',
    name = 'ChatGPT',
    func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.openai.com/v1/chat/completions',
        model = 'gpt-4o',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.openai.com/v1/chat/completions',
        model = 'gpt-4o',
        api_key_name = 'OPENAI_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_openai_spec_curl_args, dingllm.handle_openai_spec_data)
    end,
  },
  {
    key = 'a',
    name = 'Anthropic',
    func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.anthropic.com/v1/messages',
        model = 'claude-3-5-sonnet-20240620',
        api_key_name = 'ANTHROPIC_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.anthropic.com/v1/messages',
        model = 'claude-3-5-sonnet-20240620',
        api_key_name = 'ANTHROPIC_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    end,
  },
  {
    key = 'o',
    name = 'Ollama',
    func = function()
      dingllm.invoke_ollama_and_stream_into_editor({
        model = 'llama3.2:3b',
        system_prompt = helpful_prompt,
        replace = false,
        ollama_url = 'http://localhost:11434/api/generate',
      }, dingllm.make_ollama_spec_curl_args, dingllm.handle_ollama_spec_data)
    end,
    replace_func = function()
      dingllm.invoke_ollama_and_stream_into_editor({
        model = 'llama3.2:3b',
        system_prompt = system_prompt,
        replace = true,
        ollama_url = 'http://localhost:11434/api/generate',
      }, dingllm.make_ollama_spec_curl_args, dingllm.handle_ollama_spec_data)
    end,
  },
}

local function handle_api_error(err)
  vim.api.nvim_err_writeln('API Error: ' .. tostring(err))
end

local function show_model_prompt(mode)
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
  end

  local prompt = mode .. ' mode. Select a model:\n'
  for _, model in ipairs(models) do
    prompt = prompt .. model.key .. ': ' .. model.name .. '\n'
  end
  print(prompt)

  local char = vim.fn.getchar()
  local key = vim.fn.nr2char(char)

  for _, model in ipairs(models) do
    if key == model.key then
      local success, result = pcall(function()
        if mode == 'Help' then
          return model.func()
        else
          return model.replace_func()
        end
      end)

      if not success then
        handle_api_error(result)
      end
      return
    end
  end

  print 'Invalid selection'
end

-- Set up keymaps
vim.keymap.set({ 'n', 'v' }, '<leader>lh', function()
  show_model_prompt 'Help'
end, { desc = 'LLM Help' })
vim.keymap.set({ 'n', 'v' }, '<leader>lr', function()
  show_model_prompt 'Replace'
end, { desc = 'LLM Replace' })

-- Set up individual model keymaps
for _, model in ipairs(models) do
  -- Help mappings
  vim.keymap.set({ 'n', 'v' }, '<leader>lh' .. model.key, model.func, { desc = model.name })
  -- Replace mappings
  vim.keymap.set({ 'n', 'v' }, '<leader>lr' .. model.key, model.replace_func, { desc = model.name })
end

-- Optional: Set up which-key integration
local ok, wk = pcall(require, 'which-key')
if ok then
  wk.setup()
end
