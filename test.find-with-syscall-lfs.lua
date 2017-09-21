
if not pcall(require, "ffi") then
	print("use luajit man!")
	os.exit(1)
end
--local _ = require"syscall"
local lfs = require"syscall.lfs"
local find = require"lfs-find"(lfs)
require"testcode"(find, ...)
