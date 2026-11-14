local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local wargemResRead = include("wargemResRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local LONG_EVENT_TIME = 0.4
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_item = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_item", UI_Com_item)
function UI_Com_item:onInit()
	self.id = nil
	self.idTypeUI, _ENV, self.effect, _ENV, self.num = nil, nil, nil, nil, 0
	self.fields.Lab_num:setVisible(false)
	self.fields.shadow:setVisible(false)
	self:addLongPressListener(handler(self, self.onLongPress))
	self:addClickListener(handler(self, self.onClick))
	self.fields.num_bg:fix()
	self.fields.lv_bg:fix()
end
function UI_Com_item:onShow()
end
function UI_Com_item:onLongPress(button, startPos, endPos)
	if self.forbidLong or self.id == nil then
		return
	end
	self.isLong = true
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.id
	;(nil).num = self.num
	;(nil).pos = startPos
	;(nil).customName = self.customName
	;(nil).customTip = self.customTip
	SoraDSendMessage(nil)
end
function UI_Com_item:onClick()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.clickCallback then
		SoraDPlaySound()
		self.clickCallback(self)
	end
end
function UI_Com_item:forbidLongPress()
	self.forbidLong = true
end
function UI_Com_item:openLongPress()
	self.forbidLong = false
end
function UI_Com_item:initData(id, num, needNum)
	if id == nil or id == 0 then
		self.controllers.c1:setSelectedIndex(1)
		return
	end
	self.controllers.c1:setSelectedIndex(0)
	self.controllers.c2:setSelectedIndex(0)
	self.id = tonumber(id)
	self.num = tonumber(num) or 0
	self.idType = serviceFunctions.getIDType(self.id)
	self.itemType = backpackltCtrl:getItemType(self.id)
	self:setupItemUI()
	self:hideEffect()
	self.fields.Lab_num:setVisible(false)
	if self.idType == gIDType.WAR_STONE then
		self.controllers.c2:setSelectedIndex(1)
		_ENV = nil
		;(nil).lv = wargemResRead.getLevel(self.id)
		self.fields.Text_lv:setString(i18n("common_text_100", nil))
	elseif self.idType == gIDType.DIVINE_BEAST_MARK then
		if self.idTypeUI[self.idType] then
			self.idTypeUI[self.idType]:initData(self.id)
		end
	elseif self.idType == gIDType.GOD_ARMS_RUNE or self.itemType == gItemType.WAR_PARTERN_FRAGMENT then
		if self.idTypeUI[gIDType.GOD_ARMS_RUNE] then
			self.idTypeUI[gIDType.GOD_ARMS_RUNE]:initData(self.id)
		end
	else
		local specialNum = itemDesRead.getNumByID(self.id)
		self.fields.Lab_num:setVisible(specialNum ~= nil)
		self.fields.Lab_num:setString(specialNum or "")
	end
	if self.idType == gIDType.GOD_ARMS_RUNE then
		self.fields.bg:setSpriteFrame("frame_LegendaryKing_head_base.png")
	else
		self.fields.bg:setSpriteFrame(publicRead.getBg(self.id))
	end
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.id))
	self:setNum(self.num, needNum)
end
function UI_Com_item:setIcon(iconPng, num, isGray)
	if iconPng then
		self.fields.icon:setSpriteFrame(iconPng)
	end
	self.fields.shadow:setVisible(isGray or false)
	self.fields.num_bg:setVisible(num ~= nil and 0 < num)
	self.fields.Text_num:setString(num and 0 < num and string.formatnumberthousands(num) or "")
end
function UI_Com_item:setupItemUI()
	for k, v in pairs(self.idTypeUI) do
		if k ~= self.idType then
			v:removeFromParent()
			self.idTypeUI[k] = nil
		end
	end
	if self.idTypeUI[self.idType] then
		return
	end
	if self.idType == gIDType.DIVINE_BEAST_MARK then
		local obj = fgui.UIPackage:createObject("CommonUI", "Com_itemDiveneBeastMark")
		obj:setTouchEnabled(false)
		self.idTypeUI[self.idType] = obj
		obj:addTo(self)
	elseif self.idType == gIDType.GOD_ARMS_RUNE or self.itemType == gItemType.WAR_PARTERN_FRAGMENT then
		local obj = fgui.UIPackage:createObject("CommonUI", "Com_season")
		obj:setTouchEnabled(false)
		self.idTypeUI[gIDType.GOD_ARMS_RUNE] = obj
		obj:addTo(self)
	end
end
function UI_Com_item:getSetupItemUI()
	return self.idTypeUI[self.idType]
end
function UI_Com_item:setNum(num, needNum)
	if needNum then
		self.fields.num_bg:setVisible(true)
		local numColor = num < needNum and "#BE2828" or "#FFFFFF"
		local str = string.format("%s/%s", fguiHelper.getColorString(numColor, string.formatnumberthousands(num)), string.formatnumberthousands(needNum))
		self.fields.Text_num:setString(str)
	elseif num and 0 < num then
		self.fields.num_bg:setVisible(true)
		self.fields.Text_num:setString(string.formatnumberthousands(num))
	else
		self.fields.num_bg:setVisible(false)
		self.fields.Text_num:setString("")
	end
end
function UI_Com_item:setNumColor(color)
	if type(color) == "string" then
		color = SoraDHtmlColor2RGB(color)
	end
	self.fields.Text_num:setColor(color)
end
function UI_Com_item:setEffect(value)
	_UPVALUE3_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	if SoraDisInList(value, nil) then
		if not self.effect[value] then
			local effect = fgui.UIPackage:createObject("CommonUI", "effect_" .. value)
			self.effect[value] = effect
			effect:addTo(self, 99)
		end
		self.effect[value]:setVisible(true)
	end
end
function UI_Com_item:hideEffect()
	for k, v in pairs(self.effect) do
		v:removeFromParent()
		self.effect[k] = nil
	end
end
function UI_Com_item:setCustomName(name)
	self.customName = name
end
function UI_Com_item:setCustomTip(tip)
	self.customTip = tip
end
function UI_Com_item:setClickCallback(callback)
	self.clickCallback = callback
end
return UI_Com_item
