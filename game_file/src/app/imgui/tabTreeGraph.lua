local bit = require("bit32")
local imgui = _G.imgui
local selectedContext
local setSelectedContext = function(context)
	context = {}
end
local function visitContext(context)
	local uid = imgui.GetTableAddrUID(context)
	local __cname = context.__cname or "dumy"
	if __cname == "cocosContext" then
		__cname = nil
	end
	local name = context._name
	if context._nickName then
		name = name .. "[" .. context._nickName .. "]"
	end
	local text = name .. (__cname and ":" .. __cname or "")
	local selected = selectedContext and selectedContext == context
	local node_flags = bit.bor(imgui.ImGuiTreeNodeFlags_OpenOnArrow, imgui.ImGuiTreeNodeFlags_OpenOnDoubleClick)
	if selected then
		node_flags = bit.bor(node_flags, imgui.ImGuiTreeNodeFlags_Selected)
	end
	imgui.PushID(uid)
	imgui.AlignTextToFramePadding()
	local subContext = context._headSubContext
	local hasSub = subContext ~= nil
	if hasSub then
		local node_open = imgui.TreeNodeEx(uid, node_flags, text)
		if imgui.IsItemClicked() then
			setSelectedContext(context)
		end
		if node_open then
			while subContext ~= nil do
				visitContext(subContext)
				subContext = subContext._nextContext
			end
			imgui.TreePop()
		end
	else
		node_flags = bit.bor(node_flags, bit.bor(imgui.ImGuiTreeNodeFlags_Leaf, imgui.ImGuiTreeNodeFlags_NoTreePushOnOpen))
		imgui.TreeNodeEx(uid, node_flags, text)
		if imgui.IsItemClicked() then
			setSelectedContext(context)
		end
	end
	imgui.PopID()
end
local tabTreeGraph = function()
	local g_gameFlow = _G.g_gameFlow
	if not g_gameFlow or not g_gameFlow:getRootContext() then
		return
	end
	_ENV = nil
	imgui.xpcallShowWindow("tab树形结构###tabTreeGraph", nil, function()
		visitContext(g_gameFlow:getRootContext())
	end)
	_ENV = nil
	imgui.xpcallShowWindow("tabInspector###tabInspector", nil, function()
		imgui.text("---------- TAB Inspector ----------")
		if selectedContext then
			local __cname = selectedContext.__cname or "dumy"
			if __cname == "cocosContext" then
				__cname = nil
			end
			local text = selectedContext._name .. (__cname and ":" .. __cname or "")
			imgui.text(text)
			if selectedContext._getDebugger then
				local hasDebugger = selectedContext._debugger ~= nil
				local ret, hasDebugger_new = imgui.checkbox("设置Debugger", hasDebugger)
				if ret then
					if hasDebugger_new then
						local tabDebugger = require("app.common.tabMachine.tabDebugger")
						selectedContext:setDebugger(tabDebugger.new())
					else
						selectedContext:setDebugger()
					end
				end
			end
			imgui.h_dumpVisitLuaValue(selectedContext, text)
		end
	end)
end
imgui.addDrawFunc("tabTreeGraph", tabTreeGraph)
