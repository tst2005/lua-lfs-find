return function(find, ...)

	local arg = {...}
--	local xdev = nil


--[[
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
]]--

	local filetypes = require "shortmodes"

	local function hook_ok(f, mode, attr, misc)
		print(filetypes[mode].." "..(misc.level or "").." "..f..(mode=="directory" and "/" or ""))
	end
--[[
	local function hook_dir(f, mode, attr, misc)
		if mode ~= "directory" then
			print("f is not a directory: "..tostring(mode))
		end
	end
	local function hook_file(f, mode, attr, misc)
		local typ = filetypes[mode]
		if mode ~="directory" and typ~=true then
			if not typ then typ="#" end
			print((misc.level or "").." "..tostring(typ).." "..f..(mode=="directory" and "/" or ""))
		end
	end
]]--
	local hook_file = hook_ok
	local hook_dir = hook_ok

	local function hook_err(f, mode, attr, misc)
		io.stderr:write(""..f..": Permission denied ?"..(misc.errmsg and misc.errmsg or "").."\n")
	end

	return find(arg[1], {
		depth=nil,
		attr=nil--[["mode"]],
		hook_dir = hook_dir,
		hook_file = hook_file,
		hook_error = hook_err,
		maxdepth=nil,
		mindepth=nil,
	})
end
