test:
	nvim --headless --noplugin -u ./scripts/minimal_init.lua -c "lua require('plenary.test_harness').test_directory('tests', { minimal_init = './scripts/minimal_init.lua' })"