local lfs
if false then
	local _ = require"syscall"
	lfs = require"syscall.lfs"
else
	lfs = require "lfs"
end

-- See http://lua-users.org/wiki/DirTreeIterator


local function attrdir(path, opt, hook_ok, hook_error)
	local depth = opt.depth
	local wantedattr = opt.attr
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local subpath = path..'/'..file
			local attr = lfs.symlinkattributes(subpath, wantedattr) -- get attribute (no-follow)
			if type(wantedattr)=="string" and type(attr)=="string" then attr={[wantedattr]=attr} end
			--assert(type(attr) == "table")
			if attr.mode == "directory" then
				if not depth then hook_ok(subpath, attr.mode, attr) end
				if not pcall(attrdir, subpath, opt, hook_ok, hook_error) then
					hook_error(subpath, attr.mode or "", attr)
				end
				if depth then hook_ok(subpath, attr.mode, attr) end
			else
				hook_ok(subpath, attr.mode, attr)
			end
		end
	end
end

local function hook(f, mode, attr)
	if mode == "directory" then
		print(f)
		for name, value in pairs(attr) do
			print(f, name, value)
		end
	else
		print(f)
		for name, value in pairs(attr) do
			print(f, name, value)
		end
	end
end

local function hook(f, mode, attr)
	print(f..(mode=="directory" and "/" or ""))
end

local function hookerr(f, mode, attr)
	io.stderr:write(""..f..": Permission denied\n")
end

attrdir(arg[1], {depth=true, attr="mode"}, hook, hookerr)
