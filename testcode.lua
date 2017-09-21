return function(find, ...)
	
	local arg = {...}
	
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
	
	return find(arg[1], {depth=true, attr=nil--[["mode"]], hook_ok = hook, hook_error = hookerr})
end
