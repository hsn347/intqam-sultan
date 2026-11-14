fguiHelper, _ENV = nil, nil
function fguiHelper.SoraDGetExtendChildFromCCSByName(parent, name, nodeFitOffset)
	local obj = SoraDGetChildByName(parent, name)
	if obj and obj.getCustomData and obj:getCustomData() == "[Project]" then
		return obj:getChild("___proj")
	end
	return obj
end
function fguiHelper.SoraDCreateBasePanel(gcomp, item_name)
	local basePanel = include("basePanel")
	_ENV = nil
	;(nil).futureName = item_name
	return basePanel.new(nil, nil, gcomp)
end
function fguiHelper.SoraDCreatePanel(luaFileName, ...)
	local module_path = "fgui.ui.fgui_" .. luaFileName
	local uiPanel = require(module_path)
	if not uiPanel then
		print("lua 文件不存在:" .. luaFileName)
		return
	end
	local panel = uiPanel.new()
	return panel
end
function fguiHelper:SoraDSetComFields()
	for __, obj in ipairs(self.view and self.view:getChildren() or self:getChildren()) do
		if string.sub(obj:getName(), 1, 4) == "Mod_" then
			for __, child in ipairs(obj:getChildren()) do
				assert(self.fields[child:getName()] == nil, "组件对象名字" .. child:getName() .. "有重名！！！")
				self.fields[child:getName()] = child
			end
		end
	end
end
function fguiHelper.SoraDActJumpToTop(scroll)
	scroll:jumpToTop()
end
function fguiHelper.SoraDChangeTextToHtml(text)
	text:setUBBEnabled(true)
	return text
end
function fguiHelper.SoraDAutoSizeButtonText(btn, size)
end
function fguiHelper.get_fields(parent)
	return fguiHelper.lazy_get_fields(parent, parent.getChild)
end
function fguiHelper.get_controllers(parent)
	return fguiHelper.lazy_get_fields(parent, parent.getController)
end
function fguiHelper.get_transitions(parent)
	return fguiHelper.lazy_get_fields(parent, parent.getTransition)
end
function fguiHelper.lazy_get_fields(parent, getFiledFunc)
	assert(type(getFiledFunc) == "function", "getFiledFunc except 'funciton', got: " .. type(getFiledFunc))
	local _ENV, fields = assert, assert
	local _ENV, loaded = type(getFiledFunc) == "function", type(getFiledFunc) == "function"
	_ENV = getFiledFunc
	function getFiledFunc.__index(t, k)
		local v = rawget(t, k)
		if not v and not loaded[k] then
			assert(type(k) == "string", "fields key must be string")
			v = getFiledFunc(parent, k)
			t[k] = v
			loaded[k] = true
		end
		return v
	end
	setmetatable(fields, getFiledFunc)
	return fields
end
function fguiHelper.getColorString(strColor, str)
	return string.format("[color=%s]%s[/color]", strColor, tostring(str))
end
function fguiHelper.showRewardMap(rewards, ownerKey, title)
	if not rewards then
		print("rewards nil")
		return
	end
	local _ENV, t = print, print
	for k, v in pairs(rewards) do
		_ENV = nil
		;(nil).id = k
		;(nil).count = v
		table.insert(t, nil)
	end
	fguiHelper.showRewardList(t, ownerKey, title)
end
function fguiHelper.showRewardList(rewards, ownerKey, title)
	if not rewards then
		print("rewards nil")
		return
	end
	if #rewards == 0 then
		return
	end
	_ENV = nil
	;(nil).rewards = rewards
	;(nil).title = title or i18n("Martial_arts_text_09")
	uiManager:show("RewardView", nil):setOwnerKey(ownerKey)
end
function fguiHelper.debugClearLua()
	if device.platform == "mac" then
		for k, v in pairs(package.loaded) do
			if string.find(k, "^fgui%.gcomponent%.") or string.find(k, "^fgui%.views%.") then
				package.loaded[k] = nil
			end
		end
		package.loaded["fgui.base.panelConfig"] = nil
		require("fgui.base.panelConfig")
	end
end
function fguiHelper.blendMode2blendFunc(blendMode)
	local _ENV, config
	if G_IS_UNITY then
		_ENV = G_IS_UNITY
		_UPVALUE2_ = nil
		G_IS_UNITY[fgui.BlendMode.Normal], (nil)[1] = nil, gl.SRC_ALPHA
		G_IS_UNITY[fgui.BlendMode.Normal], (nil)[2] = nil, gl.ONE_MINUS_SRC_ALPHA
		_UPVALUE2_ = nil
		G_IS_UNITY[fgui.BlendMode.None], (nil)[1] = nil, gl.ONE
		G_IS_UNITY[fgui.BlendMode.None], (nil)[2] = nil, gl.ONE
		_UPVALUE2_ = nil
		G_IS_UNITY[fgui.BlendMode.Add], (nil)[1] = nil, gl.SRC_ALPHA
		G_IS_UNITY[fgui.BlendMode.Add], (nil)[2] = nil, gl.ONE
		_UPVALUE2_ = nil
		config, G_IS_UNITY[fgui.BlendMode.Multiply], (nil)[1] = G_IS_UNITY, nil, gl.ONE
		config, G_IS_UNITY[fgui.BlendMode.Multiply], (nil)[2] = G_IS_UNITY, nil, gl.ONE_MINUS_SRC_ALPHA
	else
		_UPVALUE2_, _ENV = fgui.BlendMode.Multiply, G_IS_UNITY
		_UPVALUE2_, G_IS_UNITY[0], fgui.BlendMode.Multiply[1] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.SRC_ALPHA
		_UPVALUE2_, G_IS_UNITY[0], fgui.BlendMode.Multiply[2] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.ONE_MINUS_SRC_ALPHA
		_UPVALUE2_, G_IS_UNITY[1], fgui.BlendMode.Multiply[1] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.ONE
		_UPVALUE2_, G_IS_UNITY[1], fgui.BlendMode.Multiply[2] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.ONE
		_UPVALUE2_, G_IS_UNITY[2], fgui.BlendMode.Multiply[1] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.SRC_ALPHA
		_UPVALUE2_, G_IS_UNITY[2], fgui.BlendMode.Multiply[2] = fgui.BlendMode.Multiply, fgui.BlendMode.Multiply, gl.ONE
		config, G_IS_UNITY[3], fgui.BlendMode.Multiply[1] = G_IS_UNITY, fgui.BlendMode.Multiply, gl.ONE
		config, G_IS_UNITY[3], fgui.BlendMode.Multiply[2] = G_IS_UNITY, fgui.BlendMode.Multiply, gl.ONE_MINUS_SRC_ALPHA
	end
	return config[blendMode]
end
function fguiHelper.setTextWidthHeight(txt, _size)
	local maxWidth = _size.width
	local textWidth = txt:getContentSize().width
	if maxWidth < textWidth then
		txt:setAutoSize(fgui.AutoSizeType.SHRINK)
		txt:setSize(_size)
		textWidth = maxWidth
	end
	return textWidth
end
function fguiHelper.setTextWidthHeight2(text, _size)
	local maxWidth = _size.width
	local textWidth = fguiHelper.setTextWidthHeight(text, _size)
	if maxWidth > textWidth then
		text:setAutoSize(fgui.AutoSizeType.Both)
	end
	return textWidth
end
function fguiHelper.setTextHeight(text, maxH)
	if maxH < text:getHeight() then
		text:setAutoSize(fgui.AutoSizeType.SHRINK)
		text:setSize(cc.size(text:getWidth(), maxH))
	end
end
function fguiHelper.addPackage(panel, pkgName)
	if panel and panel._addPackage then
		panel:_addPackage(pkgName)
	end
	local packageManager = include_fgui("packageManager")
	packageManager:addPackage(pkgName)
	local pkgPath = string.format("fgui/gcomponent/%s/components.lua", pkgName)
	if CS.LuaManager.isLuaExist(pkgPath) then
		local luaPath = string.format("fgui.gcomponent.%s.components", pkgName)
		require(luaPath)
	end
end
function fguiHelper.createObject(pkgName, resName)
	fguiHelper.addPackage(nil, pkgName)
	local obj = fgui.UIPackage:createObject(pkgName, resName)
	obj:setOnRemoveDicPackages(function()
		local packageManager = include_fgui("packageManager")
		packageManager:removePackage(pkgName)
	end)
	return obj
end
function fguiHelper.registMouseEvent(viewScrollView)
	local scrollPane = viewScrollView:getScrollPane()
	scrollPane:setMouseWheelEnabled(false)
	viewScrollView:addEventListener(fgui.UIEventType.MouseWheel, function(event)
		local cur = viewScrollView:getZoomScale()
		local scale = cur + event.inputEvent.mouseWheelDelta * cur / 100
		viewScrollView:setZoomScale(scale)
	end)
end
