local nebulaAllStarUtil = include("nebulaAllStarUtil")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local nebulaAllStarUIBarrage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/nebulaAllStarUIBarrage", nebulaAllStarUIBarrage)
function nebulaAllStarUIBarrage:onInit()
	self.objList, _ENV, self.recycle, _ENV = nil, nil, nil, nil
	self.sortingOrder = 0
	self.isOpen = true
	self.speed_base = 80
	self.text_speed = self.speed_base
	local totalH = self:getHeight()
	local ratio = 0.18
	self.type1H = math.ceil(ratio * totalH)
	self.type2H = totalH - self.type1H
	self.fadeTime = 0.5
	self:updateSetting()
end
function nebulaAllStarUIBarrage:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_SHOW_BARRAGE", handler(self, self.onMsgShowBarrage))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_BARRAGE_SETTING", handler(self, self.onMsgUpdateSetting))
end
function nebulaAllStarUIBarrage:onShow()
end
function nebulaAllStarUIBarrage:onMsgUpdateSetting(...)
	self:updateSetting()
	if not self.isOpen then
		if not self.objList[2] then
			_ENV = self.objList[2]
		end
		for __, obj in ipairs(self.objList[2]) do
			if obj:isVisible() then
				self:recycleBarrage(obj)
			end
		end
	end
end
function nebulaAllStarUIBarrage:updateSetting(...)
	self.curSetting = nebulaAllStarUtil.getBarrageSetting()
	local value = self.curSetting[1]
	_UPVALUE4_ = nil
	;(nil)[1] = 0.25
	;(nil)[2] = 0.5
	;(nil)[3] = 0.75
	local (nil)[4], config = 1, nil
	local area_scale = config[value] or 1
	local totalH = self:getHeight()
	self.type2H = (totalH - self.type1H) * area_scale
	local value = self.curSetting[2]
	_UPVALUE3_ = 1
	;(1)[1] = 0.5
	;(1)[2] = 1
	local (1)[3], config = 1.5, 1
	local speed_scale = config[value] or 1
	self.text_speed = self.speed_base * speed_scale
	local value = self.curSetting[3]
	self.isOpen = value
end
function nebulaAllStarUIBarrage:onMsgShowBarrage(target, event)
	self:showBarrage(event.data)
end
function nebulaAllStarUIBarrage:showBarrage(data)
	local barrageType = data.barrageType
	if barrageType ~= 1 and not self.isOpen then
		return
	end
	local obj = self:getBarrageSingle(barrageType)
	if not obj then
		return
	end
	self:updateBarrageSingle(obj, data)
	local totalW = obj:getWidth() + self:getWidth()
	local totalTime = totalW / self.text_speed
	local delayTime = math.max(0, totalTime - self.fadeTime * 2)
	_UPVALUE3_ = totalTime - self.fadeTime * 2
	;(totalTime - self.fadeTime * 2)[1] = ffa.callFunc(function()
		obj:setAlpha(0)
	end)
	;(totalTime - self.fadeTime * 2)[2] = ffa.fadeIn(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[3] = ffa.delay(delayTime)
	;(totalTime - self.fadeTime * 2)[4] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[5] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[6] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[7] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[8] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[9] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[10] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[11] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[12] = ffa.fadeOut(self.fadeTime)
	;(totalTime - self.fadeTime * 2)[13] = ffa.fadeOut(self.fadeTime)
	local actionFade = ffa.seq(totalTime - self.fadeTime * 2)
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
	SoraDFSign(totalW)[6] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[7] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[8] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[9] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[10] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	SoraDFSign(totalW)[11] = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	local actionRemove = ffa.seq((SoraDFSign(totalW)))
	_UPVALUE3_ = ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)
	ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)[1] = actionFade
	ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)[2] = actionMove
	ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)[3] = actionRemove
	obj:runAction(ffa.spawn(ffa.callFunc(function()
		self:recycleBarrage(obj)
	end)))
	if barrageType == 1 and 1 < data.itemCount then
		local Text_num = obj._fields.Text_num
		local moveW = obj:getWidth() - 66
		local delayTime = moveW / self.text_speed
		_UPVALUE2_ = ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))
		_UPVALUE1_ = ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[1] = ffa.scaleTo(0.11666666666666667, 1)
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[2] = ffa.fadeIn(0.2)
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[3] = ffa.fadeIn(0.2)
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[1] = ffa.delay(delayTime)
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[2] = ffa.callFunc(function()
			Text_num:setScale(1.8)
			Text_num:setAlpha(0)
		end)
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[3] = ffa.spawn(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[4] = ffa.spawn(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[5] = ffa.spawn(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[6] = ffa.spawn(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end))[7] = ffa.spawn(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		local actionNum = ffa.seq(ffa.spawn(ffa.callFunc(function()
			self:recycleBarrage(obj)
		end)))
		Text_num:runAction(actionNum)
	end
end
function nebulaAllStarUIBarrage:recycleBarrage(obj)
	obj:setVisible(false)
	local barrageType = obj.barrageType
	if not self.recycle[barrageType] then
		_ENV = self.recycle[barrageType]
	end
	self.recycle[barrageType] = self.recycle[barrageType]
	table.insert(self.recycle[barrageType], obj)
end
function nebulaAllStarUIBarrage:getBarrageSingle(barrageType)
	if not self.recycle[barrageType] then
		local _ENV, recycle = self.recycle[barrageType], self.recycle[barrageType]
	end
	local obj = table.remove(recycle)
	if obj then
		obj:setVisible(true)
		return obj
	end
	if self.objList[barrageType] and #self.objList[barrageType] >= 100 then
		return
	end
	local objName
	if barrageType == 1 then
		objName = "nebulaAllStarUIBarrage_type1"
	elseif barrageType == 2 then
		objName = "nebulaAllStarUIBarrage_type2"
	end
	if objName then
		local obj = fgui.UIPackage:createObject("MainUI", objName)
		obj:addTo(self)
		obj._fields = fguiHelper.get_fields(obj)
		if barrageType == 1 then
			obj._fields.mv:setAllFrameName("dh_qmxdm_%02d.png", 0)
		end
		if not self.objList[barrageType] then
			_ENV = self.objList[barrageType]
		end
		self.objList[barrageType] = self.objList[barrageType]
		table.insert(self.objList[barrageType], obj)
		return obj
	end
end
function nebulaAllStarUIBarrage:updateBarrageSingle(obj, data)
	local barrageType = data.barrageType
	obj.barrageType = barrageType
	if barrageType == 1 then
		self:updateBarrageType1(obj, data)
	elseif barrageType == 2 then
		self:updateBarrageType2(obj, data)
	end
	local posy = self:getBarragePosY(barrageType, obj:getHeight())
	local posx = self:getWidth()
	if SoraDFIsRA() then
		posx = -obj:getWidth()
	end
	obj:setPosition(cc.p(posx, posy))
	self.sortingOrder = self.sortingOrder + 1
	obj:setSortingOrder(self.sortingOrder)
end
function nebulaAllStarUIBarrage:updateBarrageType1(obj, data)
	local _fields = obj._fields
	_fields.title:setString(data.content)
	local itemCount = data.itemCount or 1
	if 1 < itemCount then
		_fields.Text_num:setVisible(true)
		_fields.Text_num:setString("X" .. itemCount)
	else
		_fields.Text_num:setVisible(false)
	end
	itemDesRead = _fields.Text_num.setVisible
	_fields.Text_num.setVisible[865401] = "icon_qmxdm_8654.png"
	local _fields.Text_num.setVisible[865501], config = "icon_qmxdm_8655.png", _fields.Text_num.setVisible
	local itemIcon = config[data.itemID] or itemDesRead.getIcon(data.itemID)
	for i = 1, 5 do
		local item = _fields["item" .. i]
		if item then
			item:setVisible(i <= itemCount)
		end
		local icon = _fields["icon" .. i]
		if icon and i <= itemCount then
			icon:setURL(itemIcon)
		end
	end
end
function nebulaAllStarUIBarrage:updateBarrageType2(obj, data)
	obj:setString(data.content)
end
function nebulaAllStarUIBarrage:getBarragePosY(barrageType, itemH)
	local posy = 0
	if barrageType == 1 then
		posy = math.random(0, self.type1H - itemH)
	elseif barrageType == 2 then
		posy = self.type1H + math.random(0, self.type2H - itemH)
	end
	return posy
end
return nebulaAllStarUIBarrage
