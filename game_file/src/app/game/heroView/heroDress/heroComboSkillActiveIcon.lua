local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local heroComboSkillCtrl = SoraDGetCtrl("heroComboSkillCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroComboSkillActiveIcon = class("heroComboSkillActiveIcon", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("skillActiveIcon")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "skillActiveIcon")
	else
		return target
	end
end)
function heroComboSkillActiveIcon:ctor()
	self.tableSkillIcon, (nil).data, _ENV, _ENV = nil, nil, nil, nil
	self.btnIcon = SoraDGetChildByName(self, "Button_bg")
	self.nodeCdTip = SoraDGetChildByName(self, "Node_cdTip")
	self.nodeCd = SoraDGetChildByName(self, "Node_cd")
	self.txtCdTip = SoraDGetChildByName(self, "Text_cdTip")
	self.txtCd = SoraDGetChildByName(self, "Text_cd")
	self.spLock = SoraDGetChildByName(self, "Sprite_lock")
	self.imgIconBg = SoraDGetChildByName(self, "Image_iconBg")
	self.imgSkill = SoraDGetChildByName(self, "Image_icon")
	self.imgFrm = SoraDGetChildByName(self, "Image_iconFrm")
	self.nodeName = SoraDGetChildByName(self, "Node_name")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.imgSelected = SoraDGetChildByName(self, "Image_selected")
	self.txtCdTip:setString(i18n("common_text_046"))
	self.btnIcon:addTouchEventListener(handler(self, self.btnIconClick))
	self.btnIcon:setSwallowTouches(false)
end
function heroComboSkillActiveIcon:initData(skillSingleData)
	dump(skillSingleData, "skillSingleData", 10)
	self.tableSkillIcon = skillSingleData
	self:showByIconType()
	self.skillInfo = heroltCtrl:getCombosSkillInfo(self.tableSkillIcon.skillID)
	if not self.skillInfo then
		return
	end
	dump(self.skillInfo, "self.skillInfo")
	self.imgSkill:loadTexture(self.skillInfo.skillIcon, ccui.TextureResType.plistType)
	self.imgSkill:ignoreContentAdaptWithSize(true)
	self.txtName:setString(i18n(self.skillInfo.skillName))
	self:changeState(self.tableSkillIcon.isActive)
	self:showQueue()
end
function heroComboSkillActiveIcon:initOcxs(...)
	self.imgSelected:setVisible(false)
	self.nodeCdTip:setVisible(false)
	self.nodeCd:setVisible(false)
end
function heroComboSkillActiveIcon:setSelect(bool)
	self.imgSelected:setVisible(bool)
	self:runSelectAction(bool)
end
function heroComboSkillActiveIcon:getSkillID(...)
	return self.tableSkillIcon.skillID
end
function heroComboSkillActiveIcon:runSelectAction(bool)
	if bool then
		self.imgSelected:setScale(1.2)
		_ENV = nil
		;(nil)[1] = cca.scaleTo(0.5, 1.05)
		;(nil)[2] = cca.scaleTo(0.5, 1.05)
		;(nil)[3] = cca.scaleTo(0.5, 1.05)
		self.imgSelected:runAction(cca.seq(nil))
	else
		self.imgSelected:stopAllActions()
	end
end
function heroComboSkillActiveIcon:showByIconType()
	self.imgIconBg:loadTexture("frame_shengqi_di.png", ccui.TextureResType.plistType)
end
function heroComboSkillActiveIcon:showQueue()
	self:endOpenTime()
	self:endCDTime()
	self:initOcxs()
	if self.tableSkillIcon.isActive then
		self:removeActiveEffect()
	end
end
function heroComboSkillActiveIcon:beginOpenTime()
	self:endOpenTime()
	self.timerOpen = SoradCreateTimer(self, handler(self, self.updateOpenTime))
	self:updateOpenTime()
	self:skillActiveEffect()
end
function heroComboSkillActiveIcon:updateOpenTime()
	self.txtCd:setString(SoraDConvertSecondToString(self.buffQueue:getRemainTime()))
	if self.buffQueue:getRemainTime() == 0 then
		self:endOpenTime()
		self:initOcxs()
		self:removeActiveEffect()
	end
end
function heroComboSkillActiveIcon:endOpenTime()
	if self.timerOpen then
		SoraDManagerRemoveTimer(self, self.timerOpen)
		self.timerOpen = nil
	end
	self:removeActiveEffect()
end
function heroComboSkillActiveIcon:beginCDTime()
	self:endCDTime()
	self.timerCD = SoradCreateTimer(self, handler(self, self.updateCDTime))
	self:updateCDTime()
end
function heroComboSkillActiveIcon:updateCDTime()
	local isInCD, cdTime = heroComboSkillCtrl:isInCD(self.tableSkillIcon.skillID)
	if isInCD then
		self.txtCd:setString(SoraDConvertSecondToString(cdTime))
		self.nodeCd:setVisible(true)
		self.nodeCdTip:setVisible(true)
	elseif isInCD == false or cdTime == 0 or cdTime == nil then
		self:endCDTime()
		self:initOcxs()
		self:removeActiveEffect()
		heroComboSkillCtrl = true
		;(true).sid = self.tableSkillIcon.skillID
		;(true).isOpened = self.tableSkillIcon.isActive
		;(true).skillNode = self
		;(true).data = self.tableSkillIcon
		self.handle("judgeIsCDBack", true)
	end
end
function heroComboSkillActiveIcon:endCDTime()
	if self.timerCD then
		SoraDManagerRemoveTimer(self, self.timerCD)
		self.timerCD = nil
	end
end
function heroComboSkillActiveIcon:changeState(isOpened)
	local state = 1
	if isOpened then
		state = 0
	end
	self.imgIconBg:getVirtualRenderer():setState(state)
	self.imgSkill:getVirtualRenderer():setState(state)
	self.imgFrm:getVirtualRenderer():setState(state)
	self.spLock:setVisible(not heroCtrl:isOwnDressID(self.tableSkillIcon.heroID, self.tableSkillIcon.dressID))
	self.txtName:setColor(isOpened and cc.c3b(220, 180, 90) or cc.c3b(165, 165, 165))
end
function heroComboSkillActiveIcon:btnIconClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.scroll and self.isMoved then
			self.isMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		self:call4Fun()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.isMoved = false
	end
end
function heroComboSkillActiveIcon:call4Fun(...)
	if self.handle then
		_UPVALUE0_ = nil
		;(nil).sid = self.tableSkillIcon.skillID
		;(nil).isOpened = self.tableSkillIcon.isActive
		;(nil).skillNode = self
		;(nil).data = self.tableSkillIcon
		self.handle("skillClick", nil)
	end
end
function heroComboSkillActiveIcon:skillActiveEffect()
	if not self.btnIcon:getChildByName("par_shenxiao_node") then
		_ENV, _ENV = self.btnIcon, self.btnIcon:getChildByName("par_shenxiao_node")
		_ENV, self.btnIcon:getChildByName("par_shenxiao_node")[1], self.btnIcon.plist = self.btnIcon, self.btnIcon, "et_shengxiao_button_01.plist"
		_ENV, self.btnIcon:getChildByName("par_shenxiao_node")[2], self.btnIcon.plist = self.btnIcon, self.btnIcon, "et_shengxiao_button_02.plist"
		_ENV, self.btnIcon:getChildByName("par_shenxiao_node")[3], self.btnIcon.plist = self.btnIcon, self.btnIcon, "et_shengxiao_button_03.plist"
		self.btnIcon:getChildByName("par_shenxiao_node")[4], self.btnIcon.plist = self.btnIcon, "et_shengxiao_button_04.plist"
		local param = self.btnIcon:getChildByName("par_shenxiao_node")
		local parNode = SoraDCreateEffectNode(param)
		parNode:setName("par_shenxiao_node")
		local size = self.btnIcon:getContentSize()
		parNode:setPosition(cc.p(size.width / 2, size.height / 2))
		self.btnIcon:addChild(parNode, -1)
	end
end
function heroComboSkillActiveIcon:removeActiveEffect()
	if self.btnIcon:getChildByName("par_shenxiao_node") then
		self.btnIcon:removeChildByName("par_shenxiao_node", true)
	end
end
function heroComboSkillActiveIcon:setHandle(handle)
	self.handle = handle
end
function heroComboSkillActiveIcon:setScroll(scroll)
	self.scroll = scroll
end
return heroComboSkillActiveIcon
