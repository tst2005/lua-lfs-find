
if not pcall(require, "ffi") then
	print("use luajit man!")
	os.exit(1)
end

do local _ = require "for.lfs.use.syscall.lfs" end
assert(require"lfs")

local find = require "lfs-find"

require"testcode"(find, ...)
