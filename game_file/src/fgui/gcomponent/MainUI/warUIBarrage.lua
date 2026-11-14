local baseComponent = require("fgui.base.baseComponent")
local warUIBarrage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/warUIBarrage", warUIBarrage)
function warUIBarrage:onInit()
	self.objList, _UPVALUE0_, self.recycle, _UPVALUE0_ = nil, nil, nil, nil
	self.sortingOrder = 0
	self.maxBarrage = 100
	self.isOpen = true
	self.speed_base = 80
	self.text_speed = self.speed_base
	local totalH = self:getHeight()
	self.typeH = 570
	self.fadeTime = 0.5
end
function warUIBarrage:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_WAR_SHOW_BARRAGE", handler(self, self.onMsgShowBarrage))
	SoraDAddMessage(self, "MESSAGE_WAR_BARRAGE_SETTING", handler(self, self.onMsgUpdateSetting))
end
function warUIBarrage:onShow()
end
function warUIBarrage:init(mapClassType)
	self.mapClassType = mapClassType
	self:updateSetting()
end
function warUIBarrage:updateSetting()
	self.barrageCfg = worldMapDefine.getBarrageCfg(self.mapClassType)
	self.maxBarrage = self.barrageCfg.maxCount or 100
	if not SoraDConfigGet(self.barrageCfg.localSettingKey) then
		local _ENV, settingCfg = SoraDConfigGet(self.barrageCfg.localSettingKey), SoraDConfigGet(self.barrageCfg.localSettingKey)
	end
	self.curSetting = settingCfg
	if #settingCfg == 0 then
		self.curSetting = self.barrageCfg.defaultSetting
	end
	_UPVALUE4_ = self.barrageCfg.defaultSetting
	self.barrageCfg.defaultSetting[1] = 0.25
	self.barrageCfg.defaultSetting[2] = 0.5
	self.barrageCfg.defaultSetting[3] = 0.75
	local self.barrageCfg.defaultSetting[4], area_config = 1, self.barrageCfg.defaultSetting
	local area_scale = area_config[self.curSetting[1]] or 1
	_UPVALUE3_, self.typeH = self:getHeight() * area_scale, self:getHeight() * area_scale
	;(self:getHeight() * area_scale)[1] = 0.5
	;(self:getHeight() * area_scale)[2] = 1
	local (self:getHeight() * area_scale)[3], speed_config = 1.5, self:getHeight() * area_scale
	local speed_scale = speed_config[self.curSetting[2]] or 1
	self.text_speed = self.speed_base * speed_scale
	self.isOpen = self.curSetting[3]
end
function warUIBarrage:onMsgUpdateSetting(...)
	self:updateSetting()
	if not self.isOpen then
		for __, obj in ipairs(self.objList) do
			if obj:isVisible() then
				self:recycleBarrage(obj)
			end
		end
	end
end
function warUIBarrage:onMsgShowBarrage(target, event)
	self:showBarrage(event.text)
end
function warUIBarrage:showBarrage(text)
	if not self.isOpen then
		return
	end
	local obj = self:getBarrageSingle()
	if not obj then
		return
	end
	self:updateBarrageSingle(obj, text)
	local totalW = obj:getWidth() + self:getWidth()
	local totalTime = totalW / self.text_speed
	local delayTime = math.max(0, totalTime - self.fadeTime * 2)
	local actionMove = ffa.moveBy(totalTime, SoraDFSign(totalW), 0)
	_UPVALUE1_ = SoraDFSign(totalW)
	SoraDFSign(totalW)[1] = ffa.delay(totalTime)
	SoraDFSign(totalW)[2] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[3] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[4] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[5] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	local actionRemove = ffa.seq((SoraDFSign(totalW)))
	_UPVALUE2_ = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)[1] = actionMove
	ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)[2] = actionRemove
	obj:runAction(ffa.spawn(ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)))
end
function warUIBarrage:recycleBarrage(obj)
	obj:setVisible(false)
	table.insert(self.recycle, obj)
end
function warUIBarrage:getBarrageSingle()
	local obj = table.remove(self.recycle)
	if obj then
		obj:setVisible(true)
		return obj
	end
	if #self.objList >= self.maxBarrage then
		return
	end
	local obj = fgui.UIPackage:createObject("MainUI", "warUIBarrageText")
	obj:addTo(self)
	table.insert(self.objList, obj)
	return obj
end
function warUIBarrage:updateBarrageSingle(obj, text)
	self:updateBarrage(obj, text)
	local posy = self:getBarragePosY(obj:getHeight())
	local posx = self:getWidth()
	if SoraDFIsRA() then
		posx = -obj:getWidth()
	end
	obj:setPosition(cc.p(posx, posy))
	self.sortingOrder = self.sortingOrder + 1
	obj:setSortingOrder(self.sortingOrder)
end
function warUIBarrage:updateBarrage(obj, text)
	obj:setString(text)
end
function warUIBarrage:getBarragePosY(itemH)
	return math.random(0, self.typeH - itemH)
end
return warUIBarrage
