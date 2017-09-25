
if not pcall(require, "ffi") then
	print("use luajit man!")
	os.exit(1)
end

-- if syscall.lfs is not available yet
if not pcall(require, "syscall.lfs") then local _ = require "syscall" end
-- try to require syscall (in case of bundle, lfs will be preloaded)

local lfs = require"syscall.lfs"
local find = require"lfs-find"(lfs)
require"testcode"(find, ...)
