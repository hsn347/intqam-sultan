local gametop = gModuleMgr.getObject("gametop")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local talentSkillCtrl = SoraDGetCtrl("talentSkillCtrl", gametop)
local worldMapComPyramid = class("worldMapComPyramid", include("worldMapCom"))
function worldMapComPyramid:ctor()
	worldMapComPyramid.super.ctor(self, "worldMapComPyramid")
end
function worldMapComPyramid:init()
	self.Node_war = SoraDGetChildByName(self.target_, "Node_war")
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	local pyramidScore = include("worldMapPyramidScore").new()
	pyramidScore:setPosition(cc.p(display.cx, height - 115))
	pyramidScore:addTo(self.target_, Z_ORDER.topTipView)
	self.btnFieldIntegral = SoraDGetChildByName(self.target_, "Button_FieldIntegral")
	self.btnFieldIntegral:setPositionY(160 + display.iPhoneXBottom)
	self.btnFieldIntegral:addTouchEventListener(handler(self, self.btnFieldIntegralCall))
	self.btnTalentSkill = SoraDGetChildByName(self.target_, "Button_talentSkill")
	self.btnTalentSkill:setPositionY(self.btnFieldIntegral:getPositionY() + 80)
	self.btnTalentSkill:addTouchEventListener(handler(self, self.btnTelentSkillCall))
	self.skill_red = SoraDGetChildByName(self.btnTalentSkill, "Sprite_red")
	self.skill_num = SoraDGetChildByName(self.btnTalentSkill, "Text_num")
	self.skill_red:setVisible(false)
	self.btnTransfer = self.btnFieldIntegral:clone()
	self.btnTransfer:setName("Button_Transfer")
	self.btnTransfer:getChildByName("icon_fight_block"):setSpriteFrame("icon_map_operate_05.png")
	self.btnTransfer:addTo(self.btnFieldIntegral:getParent())
	self.btnTransfer:setPosition(SoraDFPosX(585), self.btnFieldIntegral:getPositionY() + 120)
	self.btnTransfer:addTouchEventListener(handler(self, self.btnTransferCall))
	self.nodeCdTime = display.newNode()
	self.nodeCdTime:addTo(self.btnTransfer, 1)
	self.nodeCdTime:setPosition(49, 0)
	local timebg = display.newSprite("#frame_sheer_black_01.png")
	timebg:setPosition(0, 0)
	timebg:setScaleX(0.45)
	timebg:addTo(self.nodeCdTime, 1)
	local cdTime = ccui.Text:create("", "", 22)
	self.cdTime = SoraDCreateTimerLabel(self.target_, cdTime)
	self.cdTime:setTextColor(cc.c4b(255, 245, 230, 255))
	self.cdTime:setPosition(0, 0)
	self.cdTime:addTo(self.nodeCdTime, 2)
	self.cdTime:setTimeEndListener(function()
		self.nodeCdTime:setVisible(false)
	end)
	self.nodeCdTime:setVisible(false)
end
function worldMapComPyramid:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.kingdomStatusChange))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TALENTSKILL_REFRESH", handler(self, self.refreshRedPoint))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TRANSFER_CD_REFRESH", handler(self, self.updateTransfer))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.updateTransfer))
	self:refreshRedPoint()
end
function worldMapComPyramid:kingdomStatusChange(target, data)
	local kingdomID = worldMapDefine.currentMapKindomID
	if not worldMapDefine.isInPyramid() then
		local warData = allianceWarCtrl:getWarData(kingdomID)
		local warStatus = warData.warStatus
		if warStatus and warStatus == gKingdomWarStatusType.rule then
			local warStartTime = warData.warStartTime
			if not warStartTime or warStartTime < serviceFunctions.systemTime() then
				SoraDShowMsgTip(i18n("common_text_4309"))
				_ENV = i18n("common_text_4309")
				i18n("common_text_4309").msg = "MESSAGE_MAINSCEN_ONSHOW"
				i18n("common_text_4309").viewType = VIEW_TYPE_CITY
				SoraDSendMessage(i18n("common_text_4309"))
			end
		end
	end
end
function worldMapComPyramid:onEnter()
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	if worldMapDefine.isInPyramid() then
		talentSkillCtrl:reqInitSkill()
		self:updateTransfer()
	end
	self:reqSyncRW()
end
function worldMapComPyramid:onExit()
	worldMapComPyramid.super.onExit(self)
	if not worldMapDefine.isInPyramid() then
		local kingdomID = self.target_.currentInMapViewCell.kingdomID
		if worldMapDefine.isPyramidKingdomID(kingdomID) then
			allianceWarCtrl:reqStopSyncAW(kingdomID)
		end
	end
end
function worldMapComPyramid:updateTransfer()
	local nextTransferTime = allianceWarCtrl:getRemainFreeMoveTimesByTransPoints()
	print("nextTransferTime====", nextTransferTime)
	local leftTime = 0
	if nextTransferTime and 0 < nextTransferTime then
		leftTime = nextTransferTime - serviceFunctions.systemTime()
	end
	self.nodeCdTime:setVisible(0 < leftTime)
	if 0 < leftTime then
		self.cdTime:beginTime(leftTime)
	end
end
function worldMapComPyramid:getNodeWar()
	return self.Node_war
end
function worldMapComPyramid:reqSyncRW()
	if not worldMapDefine.isInPyramid() then
		allianceWarCtrl:reqSyncAW(worldMapDefine.currentMapKindomID)
	end
end
function worldMapComPyramid:doReqestData()
	self:reqSyncRW()
	talentSkillCtrl:reqInitSkill()
end
function worldMapComPyramid:btnFieldIntegralCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(nil)
		SoraDCreatePanel("pyramidBattleFieldIntegral"):show()
	end
end
function worldMapComPyramid:btnTelentSkillCall(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDCreatePanel("worldMapBattleSkill"):show()
end
function worldMapComPyramid:refreshRedPoint(...)
	local skillData = talentSkillCtrl:getSkillData()
	local activeNum = #skillData
	local skillLeft = 2 - activeNum
	if 0 < skillLeft then
		self.skill_red:setVisible(true)
		self.skill_num:setString(skillLeft)
	else
		self.skill_red:setVisible(false)
	end
end
function worldMapComPyramid:btnTransferCall(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.nodeCdTime:isVisible() then
			SoraDShowMsgTip(i18n("arossDesc_text_008"))
			return
		end
		local curPos = self.target_:getCovertCenterTilePoint()
		_ENV = i18n("arossDesc_text_008")
		i18n("arossDesc_text_008").msg = "MESSAGE_WORLD_MAP_TIPBUTTON_TOUCHCALL"
		i18n("arossDesc_text_008").tipButtonType = worldMapDefine.worldMapTipButtonType_qianCheng
		i18n("arossDesc_text_008").kingdomID = gametop.playertop_:getMapID()
		i18n("arossDesc_text_008").tipButtonExtra, _ENV, i18n("arossDesc_text_008").tipButtonData, _ENV, i18n("arossDesc_text_008").targetPoint = gametop.playertop_:getMapID(), gametop.playertop_:getMapID(), gametop.playertop_:getMapID(), gametop.playertop_:getMapID(), curPos
		i18n("arossDesc_text_008").ignoreInstance = true
		SoraDSendMessage(i18n("arossDesc_text_008"))
	end
end
return worldMapComPyramid
