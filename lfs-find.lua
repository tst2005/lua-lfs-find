-- See http://lua-users.org/wiki/DirTreeIterator
local M = {}

-- the lfs API return a table in most case, except if you ask only one mode.
-- this workaround make we always get a table
local workaround = function(attr, wantedattr)
	if type(wantedattr)=="string" and type(attr)=="string" then
		return {[wantedattr]=attr}
	end
	--assert(type(attr) == "table", "attr is not a table")
	return attr
end

function M:_attrdir(path, level)
	assert(type(path)=="string", "invalid path argument")
	local lfs = assert(self.lfs)
	local opt = assert(self.opt)
	local hook_ok = assert(opt.hook_ok)
	local depth = opt.depth
	local wantedattr = opt.attr
	local misc = {level=level}
	local mindepth_ok = not opt.mindepth or (level >= opt.mindepth)
	local maxdepth_ok = not opt.maxdepth or (level < opt.maxdepth)

	local attr
	local ok, err = pcall(function()
		attr = lfs.symlinkattributes(path, opt.attr) -- get attribute (no-follow)
	end)
	misc.attr=attr
	if not ok then
		opt.hook_error(path, attr and attr.mode or "", attr, misc)
		return
	end
	attr = workaround(attr, opt.attr) -- we want a `attr` table

	if attr.mode == "directory" then
		if not depth and mindepth_ok then opt.hook_ok(path, attr.mode, attr, misc) end
		--if not opt.maxdepth or (level < opt.maxdepth) then
		if maxdepth_ok then
			if not pcall(function()
				for file in lfs.dir(path) do
					if file ~= "." and file ~= ".." then
						local subpath = path..'/'..file
						self:_attrdir(subpath, level+1)
					end
				end
			end) then
				opt.hook_error(path, attr and attr.mode or "", attr, misc)
			end
		end
		if depth and mindepth_ok then hook_ok(path, attr.mode, attr, misc) end
	else
		if mindepth_ok then
			-- is a file or everything except directory
			hook_ok(path, attr.mode, attr, misc)
		end
	end
end

local function tablecopy(src, dst)
	if dst==nil then dst={} end
	for k,v in pairs(src) do
		dst[k] = v
	end
	return dst
end

local function default_hook_error(path, mode, attr, misc)
end
local function default_hook_ok(path, mode, attr, misc)
end

local default_opt = {hook_error=default_hook_error, hook_ok=default_hook_ok, depth=nil, attr=nil, mindepth=nil, maxdepth=nil}
function M:find(path, opt)
	if self.lfs==nil then 
		self.lfs = require "lfs"
	end
	self.opt = tablecopy(opt, tablecopy(default_opt))
	return self:_attrdir(path, 0)
end

setmetatable(M, {__call = function(_, ...) return M:find(...) end})
return M
