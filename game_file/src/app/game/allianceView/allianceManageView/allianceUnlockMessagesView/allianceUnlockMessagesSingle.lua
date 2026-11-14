local AllianceUnlockMessagesSingle = class("allianceUnlockMessagesSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceUnlockMessagesSingle")
	end
	return target
end)
function AllianceUnlockMessagesSingle:ctor()
	self.scroll = nil
	self.singleIsMoved = false
	self.singleData, _ENV, self.isLord = nil, nil, true
	self.layerSingle = SoraDGetChildByName(self, "Panel_single")
	self.layerSingle:setSwallowTouches(false)
	self.imgBg2 = SoraDGetChildByName(self, "Image_bg2")
	self.imgHeadBg = SoraDGetChildByName(self, "Image_headBg")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.nodeFlag:setVisible(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnUnlock = SoraDGetChildByName(self, "Button_unlock")
	self.btnUnlock:setTitleText(i18n("common_text_077"))
	self.btnUnlock:setSwallowTouches(false)
	if self.btnUnlock then
		self.btnUnlock:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceUnlockMessagesSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceUnlockMessagesSingle:initData(data, isLord)
	self.isLord = isLord
	self.singleData = data
	if self.isLord then
		local lordLocalData = include("lordLocalData")
		self.imgHeadBg:setVisible(true)
		self.spriteIcon:setVisible(true)
		self.nodeFlag:setVisible(false)
		SoraDGetHeadFromManager(self.spriteIcon, self.singleData.iconID, self.singleData.avatar)
		self.spriteIcon:setScale(0.8)
		if self.singleData.abbr then
			_ENV = nil
			;(nil).abbr = self.singleData.abbr
			;(nil).name = self.singleData.nickName
			self.labelName:setString(i18n("common_text_186", nil))
		else
			self.labelName:setString(self.singleData.nickName)
		end
	else
		local allianceDesRead = include("allianceDesRead")
		self.imgHeadBg:setVisible(false)
		self.spriteIcon:setVisible(false)
		self.nodeFlag:setVisible(true)
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.singleData.flag, self.nodeFlag)
		self.labelName:setString(self.singleData.aname)
	end
end
function AllianceUnlockMessagesSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMsg = gametop.playertop_:getModule("allianceMsg")
		if self.isLord then
			_ENV = nil
			;(nil).uid = self.singleData.uid
			allianceMsg:reqOperateShieldList(gAShieldListOperate.del, nil)
		else
			_ENV = nil
			;(nil).aid = self.singleData.aid
			allianceMsg:reqOperateShieldList(gAShieldListOperate.del, nil)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return AllianceUnlockMessagesSingle
