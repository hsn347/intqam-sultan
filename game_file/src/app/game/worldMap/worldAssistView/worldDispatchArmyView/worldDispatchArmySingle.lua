local WorldDispatchArmySingle = class("worldDispatchArmySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldDispatchArmySingle")
	end
	return target
end)
function WorldDispatchArmySingle:ctor()
	self.sliderChangeBack = nil
	self.singleIsMoved = false
	self.armyPressHandle = nil
	self.tableSoldier, _ENV, self.scroll = nil, nil, nil
	self.imgArmyIcon = SoraDGetChildByName(self, "Image_icon")
	self.btnArmyIocn = SoraDGetChildByName(self, "Button_icon")
	self.btnArmyIocn:setSwallowTouches(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.spriteLv = SoraDGetChildByName(self, "Sprite_lv")
	self.spriteWarLv = SoraDGetChildByName(self, "Sprite_warLv")
	self.labelWarLv = SoraDGetChildByName(self, "Text_warLv")
	self.labelTotalCount = SoraDGetChildByName(self, "Text_totalCount")
	self.slider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_army")
	self.slider:setSliderCallBack(handler(self, self.sliderChange))
	SoraDGetChildByName(self, "Image_1"):setFillType(1)
	self.btnArmyIocn:addTouchEventListener(handler(self, self.OnBtnItemClick))
	self.panelLock = SoraDGetChildByName(self, "Panel_lock")
end
function WorldDispatchArmySingle:initData(itemData)
	local armyDes = include("armyDesRead")
	self.tableSoldier = itemData
	self.labelName:setString(armyDes.getName(self.tableSoldier.armyid))
	self.imgArmyIcon:loadTexture(armyDes.getIcon(self.tableSoldier.armyid), ccui.TextureResType.plistType)
	self.spriteLv:setSpriteFrame(armyDes.getLvImg(self.tableSoldier.armyid))
	self.spriteWarLv:setVisible(armyDes.getWarLv(self.tableSoldier.armyid) > 0)
	self.labelWarLv:setVisible(armyDes.getWarLv(self.tableSoldier.armyid) > 0)
	self.labelWarLv:setString(armyDes.getWarLv(self.tableSoldier.armyid))
	_ENV = armyDes.getWarLv(self.tableSoldier.armyid)
	armyDes.getWarLv(self.tableSoldier.armyid).maxValue = self.tableSoldier.armycount
	armyDes.getWarLv(self.tableSoldier.armyid).minValue = 0
	armyDes.getWarLv(self.tableSoldier.armyid).curValue = self.tableSoldier.curCount
	self.slider:initData(armyDes.getWarLv(self.tableSoldier.armyid))
	self.labelTotalCount:setString("/" .. tostring(self.tableSoldier.armycount))
	local sliderEditBox = self.slider:getEditBox()
	if sliderEditBox then
		sliderEditBox:setFontColor(cc.c3b(200, 200, 200))
	end
	self:setLock(itemData.isForbid, itemData.forbidType)
end
function WorldDispatchArmySingle:setLock(lock, lockType)
	if self.panelLock then
		self.panelLock:setVisible(lock)
		self.panelLock:setSwallowTouches(not lock)
		if lock then
			local lockStr
			if lockType == 1 then
				lockStr = i18n("atlantiswar_text_0299")
			else
				lockStr = i18n("common_text_4526")
			end
			SoraDGetChildByName(self, "Text_lock"):setString(lockStr)
		end
	end
end
function WorldDispatchArmySingle:OnBtnItemClick(button, type)
	if type == ccui.TouchEventType.ended then
		self:stopAllActions()
		_ENV = self
		self.msg = "MESSAGE_WORLD_MAP_ARMY_INFO_CLOSE"
		SoraDSendMessage(self)
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		_ENV = nil
		;(nil).armyID = self.tableSoldier.armyid
		uiManager:show("soldiersInfoTipView", nil)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self:stopAllActions()
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		_ENV = button:getTouchMovePosition()
		button:getTouchMovePosition().msg = "MESSAGE_WORLD_MAP_ARMY_INFO_CLOSE"
		SoraDSendMessage((button:getTouchMovePosition()))
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll, type) then
			print("node is not on view")
			return
		end
		_UPVALUE1_ = type
		type[1] = cca.delay(0.2)
		type[2] = cca.callFunc(function(...)
			_ENV = nil
			;(nil).armyID = self.tableSoldier.armyid
			uiManager:show("soldiersInfoTipView", nil)
			self.singleIsMoved = true
		end)
		type[3] = cca.callFunc(function(...)
			_ENV = nil
			;(nil).armyID = self.tableSoldier.armyid
			uiManager:show("soldiersInfoTipView", nil)
			self.singleIsMoved = true
		end)
		self:runAction(cca.seq(type))
	end
end
function WorldDispatchArmySingle:getMaxNum()
	return self.tableSoldier.armycount
end
function WorldDispatchArmySingle:getCurNum(...)
	return self.tableSoldier.curCount
end
function WorldDispatchArmySingle:setScroll(scroll)
	self.scroll = scroll
	self.slider:setScroll(scroll)
end
function WorldDispatchArmySingle:setSliderChangeBack(handl)
	self.sliderChangeBack = handl
end
function WorldDispatchArmySingle:sliderChange(num)
	if self.sliderChangeBack then
		_UPVALUE0_ = nil
		;(nil).armyid = self.tableSoldier.armyid
		;(nil).armycount = num
		self.sliderChangeBack(self, nil)
	end
end
function WorldDispatchArmySingle:updateView()
	_UPVALUE0_ = nil
	;(nil).notBack = true
	self.slider:updateSlier(self.tableSoldier.curCount, nil)
end
function WorldDispatchArmySingle:setCurVal(num)
	print("welkrjwkel222", num)
	self.slider:updateSlier(num)
end
return WorldDispatchArmySingle
