local gametop = gModuleMgr.getObject("gametop")
local heroFestivalCtrl = gametop.playertop_:getModule("heroFestivalCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local heroFestivalCtrl = gametop.playertop_:getModule("heroFestivalCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local heroFestivalRead = include("heroFestivalRead")
local publicRead = include("publicRead")
local heroFestivalPopRewardView = class("heroFestivalPopRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroFestivalPopRewardView")
	end
	return target
end)
function heroFestivalPopRewardView:ctor()
	self:initControls()
end
function heroFestivalPopRewardView:initControls()
	self.nodeCenter = SoraDGetChildByName(self, "node_center")
	self.txtTitle = SoraDGetChildByName(self, "Text_score_title")
	self.txtTenGold = SoraDGetChildByName(self, "text_tenGold")
	self.txtTenIns = SoraDGetChildByName(self, "text_tenIns")
	self.imgBg = SoraDGetChildByName(self, "Top_Image_contentBg")
	self.btnBuy = SoraDGetChildByName(self, "btn_ten")
	self.imgGold = SoraDGetChildByName(self, "Image_gold_0")
	self.nodeCenter:setPositionY(display.height / 2)
	self.imgGold:loadTexture("8203.png", ccui.TextureResType.plistType)
	self.oneGold = heroFestivalRead:getSingleCost()
	self.tenGold = heroFestivalRead:getTenCost()
	self.txtTenGold:setString(self.tenGold)
	self.txtTitle:setString(i18n("common_text_4382"))
	_ENV = i18n("common_text_4382")
	i18n("common_text_4382").num = 10
	self.txtTenIns:setString(i18n("hero_ceremony_text_06", i18n("common_text_4382")))
	if SoraDGetDefaultLanguage() == "ru" then
		self.txtTenIns:setFontSize(18)
	end
	self.btnBuy:addTouchEventListener(handler(self, self.buttonBuyCallBack))
	self.activityID = gActivityTimeActivityID.HERO_FESTIVAL
end
function heroFestivalPopRewardView:initData(rewardList, node)
	if not rewardList then
		return
	end
	SoraDPlaySound("normalcontrol", 4)
	self.rewardList = rewardList
	self.node = node
	for i, v in ipairs(rewardList) do
		local cell = include("commonItemAward").new()
		cell:setOwnView(self)
		cell:initData(v.id, v.count)
		cell:setScale(0.9)
		if i <= 5 then
			cell:setPosition(cc.p(110 * (i - 1) + 55, 260))
		else
			cell:setPosition(cc.p(110 * (i - 6) + 55, 160))
		end
		cell:addTo(self.imgBg, 10)
	end
	local ticketCount = backpackCtrl:getItemCount(HERO_FESTIVAL_TICKET)
	self.txtTenGold:setColor(ticketCount < self.tenGold and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 0))
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
end
function heroFestivalPopRewardView:isTasksAllFinished()
	local isFinished = true
	for i, v in ipairs(self.taskList) do
		if v.taskStatus == gBtnTargetStatusDef.GO then
			isFinished = false
			break
		end
	end
	return isFinished
end
function heroFestivalPopRewardView:buttonBuyCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local ticketCount = backpackCtrl:getItemCount(HERO_FESTIVAL_TICKET)
		if ticketCount >= self.tenGold then
			heroFestivalCtrl:sendReqturnTableDrawTimesMsg(10)
			SoraDPlaySound("heroFestival", "FeastofHeroes_duoci")
		elseif ticketCount >= self.oneGold then
			local multiTimes = math.floor(ticketCount / self.oneGold)
			_ENV = nil
			;(nil).num1 = ticketCount
			;(nil).num2 = multiTimes
			SoraDShowMsgBox(i18n("hero_ceremony_text_04", nil), i18n("common_text_204"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					heroFestivalCtrl:sendReqturnTableDrawTimesMsg(multiTimes)
					SoraDPlaySound("heroFestival", "FeastofHeroes_duoci")
					if not tolua.isnull(self) then
						self:removeFromParent()
					end
				end
			end)
		elseif self:isTasksAllFinished() then
			SoraDShowMsgTip(i18n("hero_ceremony_text_02"))
		else
			SoraDShowMsgBox(i18n("hero_ceremony_text_03"), i18n("common_text_477"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES and not tolua.isnull(self.node) then
					self.node.ccs_tab:switchTab(2)
					self.node:switchButton(false)
					self:removeFromParent()
				end
			end)
		end
	end
end
function heroFestivalPopRewardView:showRewardList()
	if self.rewardList then
		SoraDMailGainItems(self.rewardList, true)
	end
end
function heroFestivalPopRewardView:onExitPanel()
	self:showRewardList()
end
return heroFestivalPopRewardView
