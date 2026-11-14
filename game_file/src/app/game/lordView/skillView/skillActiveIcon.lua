local gametop = gModuleMgr.getObject("gametop")
local lordSkillDesRead = include("lordSkillDesRead")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local SkillActiveIcon = class("skillActiveIcon", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("skillActiveIcon")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "skillActiveIcon")
	else
		return target
	end
end)
function SkillActiveIcon:ctor()
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
function SkillActiveIcon:initData(skillSingleData)
	self.tableSkillIcon.data = skillSingleData
	self.tableSkillIcon.iconType = lordSkillModuleAPI:getSkillType(self.tableSkillIcon.data.skillID)
	self:showByIconType()
	print("wlekjrwkelrjlwer", lordSkillDesRead.getIcon(self.tableSkillIcon.data.skillID))
	self.imgSkill:loadTexture(lordSkillDesRead.getIcon(self.tableSkillIcon.data.skillID), ccui.TextureResType.plistType)
	self.imgSkill:ignoreContentAdaptWithSize(true)
	self.imgSkill:setScale(0.7)
	self.txtName:setString(lordSkillDesRead.getName(self.tableSkillIcon.data.skillID))
	self:changeState(self.tableSkillIcon.data.isOpened and self.tableSkillIcon.data.currentLevel >= 1)
	self:showQueue()
end
function SkillActiveIcon:initOcxs(...)
	self.imgSelected:setVisible(false)
	self.nodeCdTip:setVisible(false)
	self.nodeCd:setVisible(false)
end
function SkillActiveIcon:setSelect(bool)
	self.imgSelected:setVisible(bool)
	self:runSelectAction(bool)
end
function SkillActiveIcon:getSkillID(...)
	return self.tableSkillIcon.data.skillID
end
function SkillActiveIcon:runSelectAction(bool)
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
function SkillActiveIcon:showByIconType()
	local bgImgName = "frame_round_01.png"
	if self.tableSkillIcon.iconType == gLordSkillType.AUXILIARY then
		bgImgName = "frame_round_lordskill_01.png"
	elseif self.tableSkillIcon.iconType == gLordSkillType.DEVELOP then
		bgImgName = "frame_round_lordskill_02.png"
	elseif self.tableSkillIcon.iconType == gLordSkillType.BATTLE then
		bgImgName = "frame_round_lordskill_03.png"
	end
	self.imgIconBg:loadTexture(bgImgName, ccui.TextureResType.plistType)
end
function SkillActiveIcon:showQueue()
	self:endOpenTime()
	self:endCDTime()
	self:initOcxs()
	if self.tableSkillIcon.data.isOpened and self.tableSkillIcon.data.currentLevel >= 1 then
		local buffid = lordSkillDesRead.getBuffID(self.tableSkillIcon.data.skillID)
		local isOpen, buff = buffCtrl:isBuffOpen(buffid)
		local bufRemainTime = buffCtrl:getRemainTimeByBuffID(buffid)
		self.buffQueue = buff
		local isInCD, cdTime = lordSkillModuleAPI:skillInCD(self.tableSkillIcon.data.skillID)
		print("skillID = ", self.tableSkillIcon.data.skillID, "isInCD = ", isInCD, " cdTime = ", cdTime)
		if isOpen then
			self.nodeCd:setVisible(true)
			if bufRemainTime and 0 < bufRemainTime then
				self:beginOpenTime()
			end
		elseif isInCD then
			self:removeActiveEffect()
			self.nodeCd:setVisible(true)
			self.nodeCdTip:setVisible(true)
			self:beginCDTime()
		else
			self:removeActiveEffect()
		end
	end
end
function SkillActiveIcon:beginOpenTime()
	self:endOpenTime()
	self.timerOpen = SoradCreateTimer(self, handler(self, self.updateOpenTime))
	self:updateOpenTime()
	self:skillActiveEffect()
end
function SkillActiveIcon:updateOpenTime()
	self.txtCd:setString(SoraDConvertSecondToString(self.buffQueue:getRemainTime()))
	if self.buffQueue:getRemainTime() == 0 then
		self:endOpenTime()
		self:initOcxs()
		self:removeActiveEffect()
	end
end
function SkillActiveIcon:endOpenTime()
	if self.timerOpen then
		SoraDManagerRemoveTimer(self, self.timerOpen)
		self.timerOpen = nil
	end
	self:removeActiveEffect()
end
function SkillActiveIcon:beginCDTime()
	self:endCDTime()
	self.timerCD = SoradCreateTimer(self, handler(self, self.updateCDTime))
	self:updateCDTime()
end
function SkillActiveIcon:updateCDTime()
	if tolua.isnull(self) then
		SoraDManagerRemoveTimerByTarget(self)
		return
	end
	local isInCD, cdTime = lordSkillModuleAPI:skillInCD(self.tableSkillIcon.data.skillID)
	if isInCD then
		self.txtCd:setString(SoraDConvertSecondToString(cdTime))
		self.nodeCd:setVisible(true)
		self.nodeCdTip:setVisible(true)
	elseif isInCD == false or cdTime == 0 or cdTime == nil then
		self:endCDTime()
		self:initOcxs()
		self:removeActiveEffect()
		_ENV = true
		;(true).sid = self.tableSkillIcon.data.skillID
		;(true).isOpened = self.tableSkillIcon.data.isOpened and self.tableSkillIcon.data.currentLevel >= 1
		;(true).skillNode = self
		self.handle("judgeIsCDBack", true)
	end
end
function SkillActiveIcon:endCDTime()
	if self.timerCD then
		SoraDManagerRemoveTimer(self, self.timerCD)
		self.timerCD = nil
	end
end
function SkillActiveIcon:changeState(isOpened)
	local state = 1
	if isOpened then
		state = 0
	end
	self.imgIconBg:getVirtualRenderer():setState(state)
	self.imgSkill:getVirtualRenderer():setState(state)
	self.imgFrm:getVirtualRenderer():setState(state)
	self.spLock:setVisible(not isOpened)
	self.txtName:setColor(isOpened and cc.c3b(220, 180, 90) or cc.c3b(165, 165, 165))
end
function SkillActiveIcon:btnIconClick(button, eventType)
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
function SkillActiveIcon:call4Fun(...)
	if self.handle then
		_UPVALUE0_ = nil
		;(nil).sid = self.tableSkillIcon.data.skillID
		;(nil).isOpened = self.tableSkillIcon.data.isOpened and self.tableSkillIcon.data.currentLevel >= 1
		;(nil).skillNode = self
		self.handle("skillClick", nil)
	end
end
function SkillActiveIcon:skillActiveEffect()
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
function SkillActiveIcon:removeActiveEffect()
	if self.btnIcon:getChildByName("par_shenxiao_node") then
		self.btnIcon:removeChildByName("par_shenxiao_node", true)
	end
end
function SkillActiveIcon:setHandle(handle)
	self.handle = handle
end
function SkillActiveIcon:setScroll(scroll)
	self.scroll = scroll
end
return SkillActiveIcon
