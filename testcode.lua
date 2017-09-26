return function(find, ...)

	local arg = {...}
--	local xdev = nil

	local function hook(self, f, mode, attr, misc)

		assert(attr.dev, "no attr.dev")
--		if attr.dev then
--			if xdev~=nil and xdev~= attr.dev then -- dev changed!
--				f="#(not-same-dev) "
--			else
--				f="ok "
--			end
--			xdev=attr.dev
--		end

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

	local function hook(f, mode, attr, misc)
		print((misc.level or "").." "..f..(mode=="directory" and "/" or ""))
	end

	local function hookerr(f, mode, attr, misc)
		io.stderr:write(""..f..": Permission denied ?\n")
	end

	return find(arg[1], {depth=nil, attr=nil--[["mode"]], hook_ok = hook, hook_error = hookerr, maxdepth=2, mindepth=1})
end
