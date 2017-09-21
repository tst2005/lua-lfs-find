-- See http://lua-users.org/wiki/DirTreeIterator

return function(lfs)
	local lfs = lfs 
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
	return attrdir
end
