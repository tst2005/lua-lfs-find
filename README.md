# lfs-find

A find-like implementation using LuaFileSystem.

```lua
local find = require "lfs-find"

local function hook_ok(f, mode, attr, misc)
	local letter = modes:sub(1,1)
	local level = misc.level or ""
	local trailingslash = mode=="directory" and "/" or ""
	print( ("%s %s %s%s\n"):format( letter, level, f, trailingslash) )
end
find(".", { hook_file=hook_ok, hook_dir=hook_ok, maxdepth=1 })
--[[
d 0 ./
f 1 ./test.find-with-syscall-lfs.lua
f 1 ./shortmodes.lua
f 1 ./README.md
f 1 ./testcode.lua
d 1 ./.git/
f 1 ./lfs-find.lua
f 1 ./test.find-with-lfs.lua
]]--
```

## Supported features

* depth : `find -depth` Process each directory's contents before the directory itself.
* mindepth : `-mindepth <levels>` Do not apply any tests or actions at levels less than levels (a non-negative integer). `mindepth=1` means process all files except the starting-points.
* maxdepth : `-maxdepth <levels>` Descend at most levels (a non-negative integer) levels of directories below the starting-points. `maxdepth=0` means only apply the tests and actions to the starting-points themselves.
* callbacks with depth level calculation

## Pending feature

* mount : Don't descend directories on other filesystems.

