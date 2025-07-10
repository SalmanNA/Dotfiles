return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1])
      local cmd = { vim.fn.stdpath('data') .. '/mason/bin/jdtls' }
      require('jdtls').start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
      })
    end,
  },
}

