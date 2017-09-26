local lfs = require"lfs"
local find = require"lfs-find"
find.lfs = lfs
require"testcode"(find, ...)
