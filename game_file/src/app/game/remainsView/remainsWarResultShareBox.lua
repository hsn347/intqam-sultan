local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local remainsWarResultShareBox = class("remainsWarResultShareBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarResultShareBox")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
_ENV = "remainsWarResultShareBox"
;("remainsWarResultShareBox").result = 1
;("remainsWarResultShareBox").team = 2
local ("remainsWarResultShareBox").history, SHARETYPE = 3, "remainsWarResultShareBox"
function remainsWarResultShareBox:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_533"))
	self.labelCD = SoraDGetChildByName(self, "Text_cd")
	self.labelCD:setVisible(false)
	self.bgCD = SoraDGetChildByName(self, "bg_cd")
	self.bgCD:setVisible(false)
	self.labelWorld = SoraDGetChildByName(self, "Text_world")
	self.checkBoxWorld = SoraDGetChildByName(self, "CheckBox_world")
	self.checkBoxAlliance = SoraDGetChildByName(self, "CheckBox_alliance")
	self.labelAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.btnShare = SoraDGetChildByName(self, "Button_share")
	self.checkBoxWorld:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.checkBoxAlliance:addEventListener(handler(self, self.btnCheckClickCallBack))
	self.btnShare:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnShare:setTitleText(i18n("common_text_533"))
	self.labelWorld:setString(i18n("common_text_1486"))
	self.labelAlliance:setString(i18n("common_text_1487"))
	self.shareType = SHARETYPE.result
end
function remainsWarResultShareBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local needClose = true
		if self.shareType == SHARETYPE.result then
			self:shareResult()
		elseif self.shareType == SHARETYPE.team then
			self:shareTeam()
		elseif self.shareType == SHARETYPE.history then
			needClose = self:shareHistory()
		end
		if needClose then
			self:removeFromParent()
		end
	end
end
function remainsWarResultShareBox:shareResult()
	local remainsWarUtil = include("remainsWarUtil")
	local err = remainsWarUtil.checkResultShare()
	if gErrDef.Err_None == err then
		local isShareWorld = self.checkBoxWorld:isSelected()
		local isShareAlliance = self.checkBoxAlliance:isSelected()
		remainsTeamCtrl:reqShareSettleInfo(isShareWorld, isShareAlliance)
	else
		remainsWarUtil.errShowTips(err)
	end
end
function remainsWarResultShareBox:initShareTeam()
	self.shareType = SHARETYPE.team
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamInfo))
	self.timer = SoradCreateTimer(self, handler(self, self.updateShareStatus))
	self:updateShareStatus()
	if allianceMgr:hasJoinAlliance() then
		self.checkBoxAlliance:setSelected(true)
		self.checkBoxWorld:setSelected(false)
	else
		self.checkBoxAlliance:setSelected(false)
		self.checkBoxWorld:setSelected(true)
	end
	self.ccs_bg:setTitleName(i18n("remains_text_306"))
	self.btnShare:setTitleText(i18n("common_text_073"))
end
function remainsWarResultShareBox:shareTeam()
	if remainsTeamCtrl:isCanSendShare() then
		local isShareWorld = self.checkBoxWorld:isSelected()
		local isShareAlliance = self.checkBoxAlliance:isSelected() and allianceMgr:hasJoinAlliance()
		remainsTeamCtrl:reqSendAllianceInvite(isShareWorld, isShareAlliance)
	else
		SoraDShowMsgTip(i18n("remains_text_149"))
	end
end
function remainsWarResultShareBox:btnCheckClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected or type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		if button == self.checkBoxAlliance and not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("common_text_583"))
			self.checkBoxAlliance:setSelected(false)
		else
			self:updateShareStatus()
		end
	end
end
function remainsWarResultShareBox:updateShareStatus()
	local enable = false
	if self.checkBoxWorld:isSelected() or self.checkBoxAlliance:isSelected() then
		enable = true
	end
	local leftTime
	if self.shareType == SHARETYPE.team then
		leftTime = remainsTeamCtrl:getTeamShareLeftCDTime()
	elseif self.shareType == SHARETYPE.history then
		local sysTime = serviceFunctions.systemTime()
		local endTime = self.lastShareTime + _G.REMAIS_WAR_HISTORY_SHARE_CDTIME
		leftTime = endTime - sysTime
	end
	if leftTime then
		enable = enable and leftTime <= 0
		self.labelCD:setVisible(0 < leftTime)
		self.bgCD:setVisible(0 < leftTime)
		SHARETYPE = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		self.labelCD:setString(i18n("common_text_2944", nil))
	end
	self.btnShare:setTouchEnabled(enable)
	self.btnShare:setBright(enable)
end
function remainsWarResultShareBox:updateTeamInfo(target, data)
	if not remainsTeamCtrl:isHasTeam(true) then
		self:removeFromParent()
	elseif not remainsTeamCtrl:isWarMatchBegin() then
		self:removeFromParent()
	end
end
function remainsWarResultShareBox:initShareHistory(idx, lastShareTime)
	self.shareType = SHARETYPE.history
	self.shareIdx = idx
	self.lastShareTime = lastShareTime
	self.btnShare:setVisible(false)
	local goldBtn = SoraDCreatePanel("commonGoldNormalBtn")
	goldBtn:addTo(self.btnShare:getParent())
	local x, y = self.btnShare:getPosition()
	goldBtn:setPosition(x, y)
	goldBtn:addTouchEventListener(handler(self, self.btnClickCallBack))
	SHARETYPE = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).title = i18n("common_text_533")
	handler(self, self.btnClickCallBack).gold = HERO_SHARE_GOLD
	goldBtn:initData(handler(self, self.btnClickCallBack))
	goldBtn:checkEnoughGold(HERO_SHARE_GOLD)
	self.btnShare = goldBtn
	self.timer = SoradCreateTimer(self, handler(self, self.updateShareStatus))
	self:updateShareStatus()
end
function remainsWarResultShareBox:shareHistory(...)
	if SoraDEnoughGold(HERO_SHARE_GOLD) then
		local isShareWorld = self.checkBoxWorld:isSelected()
		local isShareAlliance = self.checkBoxAlliance:isSelected() and allianceMgr:hasJoinAlliance()
		remainsTeamCtrl:reqShareHistoryRecord(self.shareIdx, isShareWorld, isShareAlliance)
		return true
	end
end
return remainsWarResultShareBox
