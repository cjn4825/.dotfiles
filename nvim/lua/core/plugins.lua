local ensure_packer = function()
  local fn = vim.fn local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'ntpeters/vim-better-whitespace'
    use 'morhetz/gruvbox'
    use 'nvim-lualine/lualine.nvim'
    use 'akinsho/bufferline.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'tpope/vim-commentary'
    use 'jiangmiao/auto-pairs'
    use 'famiu/bufdelete.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use "nvim-telescope/telescope-fzy-native.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"
    use 'j-morano/buffer_manager.nvim'
    use 'kdheepak/lazygit.nvim'

    use {--mason lsp
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use {'L3MON4D3/LuaSnip', run = "make install_jsregexp"}
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'
    use 'mfussenegger/nvim-jdtls'
    use 'tpope/vim-fugitive'
    use 'christoomey/vim-tmux-navigator'
    use 'lewis6991/gitsigns.nvim'
    use 'Wansmer/treesj'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
