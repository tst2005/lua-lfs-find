-- See http://lua-users.org/wiki/DirTreeIterator
local workaround = function(attr)
	if type(wantedattr)=="string" and type(attr)=="string" then
		return {[wantedattr]=attr}
	end
	assert(type(attr) == "table")
	return attr
end

return function(lfs)
	local lfs = lfs 
	local function attrdir(path, opt)
		local hook_ok, hook_error = opt.hook_ok, hook_error
		local depth = opt.depth
		local wantedattr = opt.attr

		-- TODO: pcall(lfs.* ...) in case of error

		local attr
		local ok, err = pcall(
			function()
				attr = lfs.symlinkattributes(path, opt.attr) -- get attribute (no-follow)
			end
		)
		if not ok then
			hook_error(path, attr and attr.mode or "", attr)
			return
		end
		attr = workaround(attr)
		
		if attr.mode == "directory" then
			if not depth then opt.hook_ok(path, attr.mode, attr) end
			if not pcall(function()
				for file in lfs.dir(path) do
					if file ~= "." and file ~= ".." then
						local subpath = path..'/'..file
						attrdir(subpath, opt)
					end
				end
			end) then
				opt.hook_error(path, attr and attr.mode or "", attr)
			end
			if depth then hook_ok(path, attr.mode, attr) end
		else
			hook_ok(path, attr.mode, attr)
		end
	end
	return attrdir
end
