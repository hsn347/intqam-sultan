if not imgui then
	_ENV = imgui
end
imgui = imgui
local bit = require("bit32")
local buf = "Quick brown fox"
local float = 3
local isToolbarOpened = true
local _ENV, ComboBoxPackMap
local _ENV, ShowNameMap
local _ENV, drawFuncList
local __TRACKBACK__ = function(errorMessage)
	print("__TRACKBACK__")
	print("----------------------------------------")
	print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
	local errorMsg = debug.traceback("", 2)
	print(errorMsg)
	print("----------------------------------------")
end
imgui.__TRACKBACK__ = __TRACKBACK__
imgui._config_visualDump_sortKey = true
function imgui.setup_mainmenu()
	if imgui.beginMainMenuBar() then
		if imgui.beginMenu("File") then
			imgui.endMenu()
		end
		if imgui.beginMenu("Edit") then
			if imgui.menuItem("Undo") then
				print("undo")
			end
			if imgui.menuItem("Redo") then
				print("redo")
			end
			imgui.separator()
			if imgui.menuItem("Cut") then
				print("cut")
			end
			imgui.endMenu()
		end
		imgui.endMainMenuBar()
	end
end
function imgui.dump(value, desciption, nesting)
	if type(nesting) ~= "number" then
		nesting = 3
	end
	local _ENV, lookupTable = type(nesting), type(nesting)
	local _ENV, result = nesting, nesting
	local _v = function(v)
		if type(v) == "string" then
			v = "\"" .. v .. "\""
		end
		return tostring(v)
	end
	local traceback = string.split(debug.traceback("", 2), "\n")
	local function _dump(value, desciption, indent, nest, keylen)
		desciption = desciption or "<var>"
		spc = ""
		if type(keylen) == "number" then
			spc = string.rep(" ", keylen - string.len(_v(desciption)))
		end
		if type(value) ~= "table" then
			result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
		elseif lookupTable[value] then
			result[#result + 1] = string.format("%s%s%s = *REF*", indent, tostring(desciption), tostring(spc))
		else
			lookupTable[value] = true
			if nest > nesting then
				result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, tostring(desciption))
			else
				result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
				local indent2 = indent .. "    "
				local _ENV, keys = "    ", "    "
				local keylen = 0
				local _ENV, values = indent, indent
				for k, v in pairs(value) do
					keys[#keys + 1] = k
					local vk = _v(k)
					local vkl = string.len(vk)
					if keylen < vkl then
						keylen = vkl
					end
					values[k] = v
				end
				table.sort(keys, function(a, b)
					if type(a) == "number" and type(b) == "number" then
						return a < b
					else
						return tostring(a) < tostring(b)
					end
				end)
				for i, k in ipairs(keys) do
					_dump(values[k], k, indent2, nest + 1, keylen)
				end
				result[#result + 1] = string.format("%s}", indent)
			end
		end
	end
	_dump(value, desciption, "- ", 1)
	for i, line in ipairs(result) do
		imgui.text(line)
	end
end
function imgui.h_getValueString(v)
	if type(v) == "string" then
		v = "\"" .. v .. "\""
	end
	return tostring(v)
end
function imgui.h_checkTableHasSub(v_t)
	if type(v_t) ~= "table" then
		return false
	end
	for key, value in pairs(v_t) do
		return true
	end
	return false
end
function imgui.h_dumpVisitLuaValue(lvalue, desciption, uid_prefix)
	desciption = desciption or "<var>"
	uid_prefix = uid_prefix or "uid_"
	local text = desciption .. " = " .. imgui.h_getValueString(lvalue)
	local node_flags = bit.bor(imgui.ImGuiTreeNodeFlags_OpenOnArrow, imgui.ImGuiTreeNodeFlags_OpenOnDoubleClick)
	local uid = uid_prefix .. desciption
	imgui.PushID(uid)
	imgui.AlignTextToFramePadding()
	local typeStr = type(lvalue)
	if typeStr == "table" or typeStr == "userdata" then
		local t_var = lvalue
		if typeStr == "userdata" then
			_ENV = nil
			t_var, (nil)._Metatable_ = nil, getmetatable(lvalue)
			local mt = tolua.getpeer(lvalue)
			if mt then
				for k, v in pairs(mt) do
					t_var[k] = v
				end
			end
		end
		local hasSub = imgui.h_checkTableHasSub(t_var)
		if hasSub then
			local node_open = imgui.TreeNodeEx(uid, node_flags, text)
			if imgui.BeginPopupContextItem("##item context menu" .. uid) then
				imgui.inputText("##edit" .. uid, text, 256, imgui.ImGuiInputTextFlags_ReadOnly)
				imgui.EndPopup()
			end
			if node_open then
				if imgui._config_visualDump_sortKey then
					local _ENV, showKeys = imgui._config_visualDump_sortKey, imgui._config_visualDump_sortKey
					for key, _ in pairs(t_var) do
						table.insert(showKeys, key)
					end
					table.sort(showKeys)
					for _, key in ipairs(showKeys) do
						local value = t_var[key]
						imgui.h_dumpVisitLuaValue(value, imgui.h_getValueString(key), uid_prefix .. "_" .. desciption)
					end
				else
					for key, value in pairs(t_var) do
						imgui.h_dumpVisitLuaValue(value, imgui.h_getValueString(key), uid_prefix .. "_" .. desciption)
					end
				end
				imgui.TreePop()
			end
		else
			node_flags = bit.bor(node_flags, bit.bor(imgui.ImGuiTreeNodeFlags_Leaf, imgui.ImGuiTreeNodeFlags_NoTreePushOnOpen))
			imgui.TreeNodeEx(uid, node_flags, text)
			if imgui.BeginPopupContextItem("##item context menu" .. uid) then
				imgui.inputText("##edit" .. uid, text, 256, imgui.ImGuiInputTextFlags_ReadOnly)
				imgui.EndPopup()
			end
		end
	else
		node_flags = bit.bor(node_flags, bit.bor(imgui.ImGuiTreeNodeFlags_Leaf, imgui.ImGuiTreeNodeFlags_NoTreePushOnOpen))
		imgui.TreeNodeEx(uid, node_flags, text)
		if imgui.BeginPopupContextItem("##item context menu" .. uid) then
			imgui.inputText("##edit" .. uid, text, 256, imgui.ImGuiInputTextFlags_ReadOnly)
			imgui.EndPopup()
		end
	end
	imgui.PopID()
end
function imgui.GetTableAddrUID(t)
	local n = 0
	if type(t) == "table" then
		local s = tostring(t)
		n = imgui.GetID(s)
	end
	return n
end
function imgui.h_buildEnumItemPack(enumTable, enumName)
	local _ENV, tempItems
	local _ENV, itemKeys
	local _ENV, indexMap
	local _ENV, v2kMap
	local itemsStr
	for k, v in pairs(enumTable) do
		table.insert(itemKeys, k)
	end
	table.sort(itemKeys)
	if not ShowNameMap[enumName] then
		local _ENV, showNames = ShowNameMap[enumName], ShowNameMap[enumName]
	end
	for i, k in ipairs(itemKeys) do
		local v = enumTable[k]
		indexMap[k] = i
		v2kMap[v] = k
		local nickname = showNames[v] and "(" .. showNames[v] .. ")" or ""
		table.insert(tempItems, k .. nickname .. "\000")
	end
	_ENV, itemsStr = table.concat(tempItems), table.concat(tempItems)
	table.concat(tempItems).itemKeys = itemKeys
	table.concat(tempItems).itemsStr = itemsStr
	table.concat(tempItems).v2kMap = v2kMap
	local table.concat(tempItems).indexMap, pack = indexMap, table.concat(tempItems)
	return pack
end
function imgui.h_comboEnum(enumTable, enumName, widgetID, v)
	local comboPack = ComboBoxPackMap[enumName]
	if not comboPack then
		ComboBoxPackMap[enumName] = imgui.h_buildEnumItemPack(enumTable, enumName)
		comboPack = ComboBoxPackMap[enumName]
	end
	local ret = false
	local idx = 0
	if v then
		local k = comboPack.v2kMap[v]
		idx = comboPack.indexMap[k]
		local t_ret, t_idx = imgui.combo(widgetID, idx - 1, comboPack.itemsStr)
		if t_ret then
			ret = true
			idx = t_idx + 1
			v = enumTable[comboPack.itemKeys[idx]]
		end
	end
	return ret, v
end
function imgui.c4fFromHex(hex)
	hex = hex:gsub("#", "")
	local r = tonumber("0x" .. hex:sub(1, 2)) / 255
	local g = tonumber("0x" .. hex:sub(3, 4)) / 255
	local b = tonumber("0x" .. hex:sub(5, 6)) / 255
	local a = (tonumber("0x" .. hex:sub(7, 8)) or 255) / 255
	return cc.c4f(r, g, b, a)
end
function imgui.c4bFromHex(hex)
	hex = hex:gsub("#", "")
	local r = tonumber("0x" .. hex:sub(1, 2))
	local g = tonumber("0x" .. hex:sub(3, 4))
	local b = tonumber("0x" .. hex:sub(5, 6))
	local a = tonumber("0x" .. hex:sub(7, 8)) or 255
	return cc.c4f(r, g, b, a)
end
function imgui.toogleMainWindow()
	local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
	local timeHandle
	timeHandle = schedulerTime.scheduleUpdateGlobal(function(dt)
		schedulerTime.unscheduleGlobal(timeHandle)
		imgui.toggleKeepOnTop()
	end)
end
function imgui.colorButton(name, color, colorH, colorA)
	local color = color or cc.c4f(0.26, 0.59, 0.98, 1)
	imgui.PushStyleColor(imgui.ImGuiCol_Button, color)
	imgui.PushStyleColor(imgui.ImGuiCol_ButtonHovered, colorH or color)
	imgui.PushStyleColor(imgui.ImGuiCol_ButtonActive, colorA or color)
	local ret = imgui.button(name)
	imgui.PopStyleColor(3)
	return ret
end
function imgui.xpcallShowWindow(title, flags, func, opended)
