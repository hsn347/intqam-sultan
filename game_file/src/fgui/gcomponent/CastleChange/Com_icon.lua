local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_icon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CastleChange/Com_icon", Com_icon)
function Com_icon:onInit()
	self.fields.mv_select:setAllFrameName("dh_cbcnzb_xz_%.2d.png", 1)
	self:addClickListener(handler(self, self.btnClick))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
end
function Com_icon:onShow()
end
function Com_icon:isSameDressID(dressID)
	if self.data.ownData then
		for k, v in ipairs(self.data.ownData) do
			if v.dressID == dressID then
				return true
			end
		end
	end
	if self.data.shopData then
		for k, v in ipairs(self.data.shopData) do
			if v.dressID == dressID then
				return true
			end
		end
	end
	return false
end
function Com_icon:initData(data, selectData)
	self.data = data
	self.fields.icon_item:setSpriteFrame(castleSkinRead.getIconBySubType(self.data.subType))
	local skinQuality = castleSkinRead.getSkinQualityBySubType(self.data.subType)
	local skinQualityCfg = castleSkinRead.getSkinQualityCfg(skinQuality)
	if skinQualityCfg then
		self.fields.icon_tag:setSpriteFrame(SoraDFIsRA() and skinQualityCfg.ar or skinQualityCfg.en)
		self.fields.icon_tag:setVisible(true)
	else
		self.fields.icon_tag:setVisible(false)
	end
	self.isSame = self:isSameDressID(selectData.dressID)
	self.fields.select:setVisible(self.isSame)
	self.fields.mv_select:setVisible(self.isSame)
	if castleSkinRead.getDressTypeBySubType(self.data.subType) == tonumber(gDressType.CASTLE_NAMEPLATE) then
		self.fields.icon_item:setScale(0.7)
	else
		self.fields.icon_item:setScale(0.8)
	end
	if castleSkinRead.getDressTypeBySubType(self.data.subType) == tonumber(gDressType.CHAT_AVATAR_FRAME) then
		self.fields.icon_item:setPositionY(50)
	else
		self.fields.icon_item:setPositionY(64)
	end
	self.fields.lock:stopAllActions()
	self.fields.lock:setRotation(0)
	self.Text_time:endTime()
	local ret, dressData = self:isActive()
	if ret then
		if dressData.isClassic then
			self.controllers.c1:setSelectedIndex(6)
			self.fields.n31:setVisible(true)
		else
			self.controllers.c1:setSelectedIndex(5)
			local lifeType = dressltCtrl.getDressLifeType(dressData.dressID)
			if lifeType == gDressLifeType.FOREVER then
				self.Text_time:setString(i18n("common_text_1995"))
				self.fields.n32:setVisible(false)
			elseif dressData.remainTime then
				self.Text_time:beginTime(dressData.remainTime)
				self.fields.n32:setVisible(true)
			else
				self.Text_time:setString("")
				self.fields.n32:setVisible(false)
			end
		end
	else
		local isOwn, ownData = self:isOwnDress()
		if not isOwn then
			if not self.data.ownData then
				self.controllers.c1:setSelectedIndex(0)
			else
				local isHaveLongLive = false
				for k, v in ipairs(self.data.ownData) do
					local lifeType = dressltCtrl.getDressLifeType(v.dressID)
					if lifeType == gDressLifeType.FOREVER then
						isHaveLongLive = true
						break
					end
				end
				self.controllers.c1:setSelectedIndex(isHaveLongLive and 1 or 2)
				_UPVALUE6_ = i18n("common_text_1995")
				i18n("common_text_1995")[1] = ffa.rotateTo(0.25, 10)
				i18n("common_text_1995")[2] = ffa.rotateTo(0.21666666666666667, -10)
				i18n("common_text_1995")[3] = ffa.rotateTo(0.2, 8)
				i18n("common_text_1995")[4] = ffa.rotateTo(0.16666666666666666, -5)
				i18n("common_text_1995")[5] = ffa.rotateTo(0.15, 2)
				i18n("common_text_1995")[6] = ffa.rotateTo(0.15, 0)
				i18n("common_text_1995")[7] = ffa.delay(0.21666666666666667)
				i18n("common_text_1995")[8] = ffa.delay(0.21666666666666667)
				self.fields.lock:runAction(ffa.repeatForever(ffa.seq(i18n("common_text_1995"))))
			end
		elseif ownData.isClassic then
			self.controllers.c1:setSelectedIndex(6)
			self.fields.n31:setVisible(false)
		else
			local lifeType = dressltCtrl.getDressLifeType(ownData.dressID)
			if lifeType == gDressLifeType.FOREVER then
				self.controllers.c1:setSelectedIndex(3)
				self.Text_time:setString(i18n("common_text_1995"))
			else
				self.controllers.c1:setSelectedIndex(4)
				if ownData.remainTime then
					self.Text_time:beginTime(ownData.remainTime)
				else
					self.Text_time:setString("")
				end
			end
		end
	end
end
function Com_icon:isOwnDress()
	local isOwn = false
	local ret
	if not self.data.ownData then
		_ENV = self.data.ownData
	end
	for k, v in ipairs(self.data.ownData) do
		if v.isOwn then
			isOwn = true
			ret = v
			break
		end
	end
	return isOwn, ret
end
function Com_icon:isActive()
	local ret = false
	local ownData
	if not self.data.ownData then
		_ENV = self.data.ownData
	end
	for k, v in ipairs(self.data.ownData) do
		if v.isOwn and v.active then
			ret = true
			ownData = v
			break
		end
	end
	return ret, ownData
end
function Com_icon:isOwnForeverDress()
	local isHaveLongLive = false
	if not self.data.ownData then
		_ENV = self.data.ownData
	end
	for k, v in ipairs(self.data.ownData) do
		local lifeType = dressltCtrl.getDressLifeType(v.dressID)
		if lifeType == gDressLifeType.FOREVER then
			isHaveLongLive = true
			break
		end
	end
	return isHaveLongLive
end
function Com_icon:getForeverOwnData()
	if not self.data.ownData then
		_ENV = self.data.ownData
	end
	for k, v in ipairs(self.data.ownData) do
		if v.isOwn and v.forever then
			return v
		end
	end
	if self.data.ownData then
		local isUsed = false
		for k, v in ipairs(self.data.ownData) do
			if v.forever then
				isUsed = true
				return v
			end
			if v.isOwn and v.remainTime then
				isUsed = true
				return v
			end
		end
		if not isUsed then
			for k, v in ipairs(self.data.ownData) do
				if v.itemNum and v.itemNum > 0 then
					return v
				end
			end
		end
	end
	return self.data.shopData[1]
end
function Com_icon:btnClick()
	if not self.isSame then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_DRESS_SELECT"
		;(nil).data = self:getForeverOwnData()
		SoraDSendMessage(nil)
	end
end
return Com_icon
