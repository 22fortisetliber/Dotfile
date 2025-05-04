return {
	{
		"AstroNvim/astrolsp",
   	---@type AstroLSPOpts
  	opts = {
    	mappings = {
  			n = {
					gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
				},
			},
		},
	},
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = {
			mappings = {
				n = {
					-- navigate buffer tabs with `H` and `L`
        	L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        	H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
					["<Leader>bD"] = {
          	function()
            	require("astroui.status.heirline").buffer_picker(
              	function(bufnr) require("astrocore.buffer").close(bufnr) end
            	)
          	end,
          	desc = "Pick to close",
					},
					["<Leader>b"] = { desc = "Buffers" },
					["<Down>"] = {"<C-e>", desc="Scroll Down"},
					["<Up>"] = {"<C-y>", desc="Scroll Up"},
					["<A-Up>"] = {"<{>", desc="Jump Up"},
					["<A-Down>"] = {"<}>", desc="Jump Down"},
					["<A-h>"]= {":BufferLineCycleNext<CR>", desc="Next"},
					["<A-b>"]= {":BufferLineCyclePrev<CR>", desc="Prev"},
				},
			},
		},
	},
}
