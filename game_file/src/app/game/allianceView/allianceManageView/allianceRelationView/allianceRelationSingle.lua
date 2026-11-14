local gametop = gModuleMgr.getObject("gametop")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local AllianceRelationSingle = class("allianceRelationSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceRelationSingle")
	end
	return target
end)
function AllianceRelationSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.timer = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.curType = gAllianceRelationType.ALLY
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelLeader = SoraDGetChildByName(self, "Text_leader")
	self.labelMember = SoraDGetChildByName(self, "Text_member")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelLanguage = SoraDGetChildByName(self, "Text_language")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelApply = SoraDGetChildByName(self, "Text_apply")
	self.labelApply:setString(i18n("common_text_1051"))
	self.btnOK = SoraDGetChildByName(self, "Button_ok")
	SoraDAutoSizeButtonText(self.btnOK, cc.size(140, 50))
	self.btnOK:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.layerTouch:addTouchEventListener(handler(self, self.btnInfoClickCallBack))
end
function AllianceRelationSingle:initData(data)
	self.tableSingleData = data
	self.curType = self.tableSingleData.type
	self:hiddleAll()
	self:showPublic()
	self:updateBtn()
end
function AllianceRelationSingle:updateBtn()
	local btnStr = i18n("common_text_3081")
	local btnImg1 = "btn_red_small_01.png"
	local btnImg2 = ""
	local btnImg3 = ""
	local isRank = allianceDesRead.checkRank(gAllianceRank.R4)
	if self.curType == 4 then
		if self.tableSingleData.inviteType == "send" then
			btnStr = i18n("common_text_184")
			btnImg1 = "btn_yellow_small_01.png"
			btnImg2 = ""
			self.labelApply:setVisible(true)
		elseif self.tableSingleData.inviteType == "recv" then
			btnStr = i18n("common_text_140")
			btnImg1 = "btn_green_small_01.png"
			btnImg2 = ""
		end
	end
	self.btnOK:setTouchEnabled(isRank)
	self.btnOK:setBright(isRank)
	self.btnOK:setTitleText(btnStr)
	self.btnOK:loadTextures(btnImg1, btnImg2, btnImg3, ccui.TextureResType.plistType)
	if worldMapDefine.isInWarForbid(true) then
		self.btnOK:setBright(false)
	end
end
function AllianceRelationSingle:showPublic()
	_ENV = nil
	;(nil).abbr = self.tableSingleData.aInfo.abbr
	;(nil).name = self.tableSingleData.aInfo.name
	self.labelName:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).name = self.tableSingleData.aInfo.leaderName
	self.labelLeader:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	self.labelMember:setString(self.tableSingleData.aInfo.memberCount .. "/" .. self.tableSingleData.aInfo.limitCount)
	self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.aInfo.totalPower))
	self.labelLanguage:setString(allianceDesRead.getLanguageName(self.tableSingleData.aInfo.language))
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(self.tableSingleData.aInfo.flag, self.nodeFlag)
end
function AllianceRelationSingle:hiddleAll()
	self.labelApply:setVisible(false)
end
function AllianceRelationSingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceRelationSingle:btnInfoClickCallBack(button, type)
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
		SoraDShowLoading(SoraDCurrentTopPanelFromManager())
		_ENV = SoraDCurrentTopPanelFromManager()
		_ENV, SoraDCurrentTopPanelFromManager().aid = self.tableSingleData.aInfo.aid, self.tableSingleData.aInfo.aid
		self.tableSingleData.aInfo.aid.from = "allianceRelationView"
		allianceQuery:reqAllianceByID(SoraDCurrentTopPanelFromManager())
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
function AllianceRelationSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		if allianceDesRead.checkRank(gAllianceRank.R4, true) then
			local aid = self.tableSingleData.aInfo.aid
			if self.curType == gAllianceRelationType.ALLY then
				allianceRelationCtrl:reqDelRelation(aid)
			elseif self.curType == gAllianceRelationType.FRIENDLY then
				allianceRelationCtrl:reqDelRelation(aid)
			elseif self.curType == gAllianceRelationType.ENEMY then
				allianceRelationCtrl:reqDelRelation(aid)
			elseif self.curType == 4 then
				if self.tableSingleData.inviteType == "send" then
					allianceRelationCtrl:reqCancelInviteAllyAlliance(aid)
				elseif self.tableSingleData.inviteType == "recv" then
					allianceRelationCtrl:reqAcceptAllyAllianceInvite(aid)
				end
			end
		end
	end
end
return AllianceRelationSingle
