local _ENV, csb_fix
local _ENV, dic
local _ENV, list
local file_name = "csb_fix.txt"
local isEditor = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor
function csb_fix:init()
	if self.inited then
		return
	end
	self.inited = true
	self:read()
end
function csb_fix:getCsbPath(target)
	local name = target:getName()
	assert(type(name) == "string", "name must be string")
	local t = target
	while t and not t.__csb_file_path__ do
		t = t:getParent()
	end
	local csbPath
	if t then
		csbPath = t.__csb_file_path__
	end
	if not csbPath then
		print_warn("csbPath is null", name)
		return ""
	end
	assert(type(csbPath) == "string", "csbPath must be string")
	if string.len(csbPath) == 0 or string.len(name) == 0 then
		return ""
	end
	return csbPath
end
function csb_fix:add(target)
	if isEditor or userSDKManager.isBeta() then
		local csbPath = self:getCsbPath(target)
		local name = target:getName()
		SoraDDelayCallOnce("csb_fix", function()
			SoraDShowMsgBox("提交csb_fix.txt,重导Gen_CCS\n" .. csbPath .. " " .. name)
		end)
	end
	if not isEditor then
		return
	end
	local csbPath = self:getCsbPath(target)
	self:init()
	local name = target:getName()
	print("csb_fix:add", csbPath, name)
	local key = csbPath .. " " .. name
	if dic[key] then
		return
	end
	dic[key] = true
	table.insert(list, key)
	table.sort(list)
	dump(list, "csb_fix===", 10)
	self:write()
end
function csb_fix:read()
	local file = io.open(file_name, "r")
	if not file then
		return
	end
	for line in file:lines() do
		local key = string.match(line, "^(.+)")
		if key then
			dic[key] = true
			table.insert(list, key)
		end
	end
	table.sort(list)
	file:close()
end
function csb_fix:write()
	local file = io.open(file_name, "w")
	file:write(table.concat(list, "\n"))
	file:close()
end
return csb_fix
