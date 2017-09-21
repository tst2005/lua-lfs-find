--local _ = require"syscall"
local lfs = require"syscall.lfs"
local find = require"lfs-find"(lfs)
require"testcode"(find, ...)
