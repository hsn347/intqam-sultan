local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local PopupWindowPanel = class("PopupWindowPanel", baseFguiPanel)
function PopupWindowPanel:ctor(...)
	self.super.ctor(self, ...)
	print("PopupWindowPanel:ctor", self.viewName)
	self.activityID = self.proxy.param.activityID
end
function PopupWindowPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function PopupWindowPanel:onInit()
	print("=======PopupWindowPanel:onInit")
	local activityname = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Com_title:initData(i18n(activityname), handler(self, self.onClickClose))
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		_ENV = "common_text_2669"
		;("common_text_2669").color = "#FFC864"
		local timePrefix = SoraDWrapHtmlTagByStyle(i18n("common_text_2669"), "common_text_2669")
		self.fields.Label_time:setTimeLast(function(time)
			return timePrefix .. time
		end)
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Label_time:beginTime(leftTime)
	end
	local proxy = uiManager:getOrCreateProxy("HomePopup")
	local classtype = activityShowCtrl:getParamClassType(self.activityID)
	local data = proxy:getConfigData(self.activityID, classtype)
	self.fields.Load_bg:setURL(data.background)
	if data.usm and data.usm ~= "" then
		self.fields.Usm_bg:setEffectPath(data.usm, true)
	end
	local artWord = SoraDFIsRA() and data.artWord_ar or data.artWord_en
	self.fields.Load_title:setURL(artWord)
	if data.sortDes and data.sortDes ~= "" then
		self.fields.Text_des:setString(i18n(data.sortDes))
	end
	_ENV = self.fields.Text_des.setString
	self.fields.Text_des.setString[gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY] = "Com_btnGoRecharge"
	local self.fields.Text_des.setString[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT], config = "Com_btnGo9001316", self.fields.Text_des.setString
	local comName = config[self.activityID] or "Com_btnGoNormal"
	self.fields.Com_buttonGo:setURL("ui://HomePopup/" .. comName)
	local Com_buttonGo = self.fields.Com_buttonGo:getComponent()
	local Button = Com_buttonGo:getChild("Button")
	if self.activityID == gActivityTimeActivityID.NEBULA_PREPARE_FOR_WAR_ACTIVITY then
		Button:setString(i18n("common_btn_01"))
	else
		Button:setString(i18n("common_text_477"))
	end
	Button:addClickListener(handler(self, self.onClickGo))
	if self.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
		local com_lab = Com_buttonGo:getChild("com_lab")
		com_lab:fixChildrenPos()
		com_lab:setString(i18n("sheepFeed_text_10"))
		com_lab:setIcon("1619.png")
		local presentGold = rechargePresentCtrl:getRechargePresentGold(self.activityID)
		com_lab:getChild("value"):setString(string.formatnumberthousands(presentGold))
	end
	_ENV = com_lab
	local Com_buttonGo:getChild("com_lab")[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT], needHelpBtnList = true, Com_buttonGo:getChild("com_lab")
	if not IsArClient then
		needHelpBtnList[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT] = nil
	end
	if needHelpBtnList[self.activityID] then
		self.fields.Com_title:setHelpCallBack(handler(self, self.onClickHelp))
	end
end
function PopupWindowPanel:onShow()
	print("=======PopupWindowPanel:onShow")
end
function PopupWindowPanel:refreshPresentGold()
	if self.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
		local Com_buttonGo = self.fields.Com_buttonGo:getComponent()
		local com_lab = Com_buttonGo:getChild("com_lab")
		local presentGold = rechargePresentCtrl:getRechargePresentGold(self.activityID)
		com_lab:getChild("value"):setString(string.formatnumberthousands(presentGold))
	end
end
function PopupWindowPanel:onClickGo(EventContext)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY or self.activityID == gActivityTimeActivityID.HERO_AWAKE_ACTIVTY or self.activityID == gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY then
		SoraDRemoveAllPanelFromManager()
		uiManager:show("newHeroListView")
	elseif self.activityID == gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY or self.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	elseif self.activityID == gActivityTimeActivityID.NEBULA_PREPARE_FOR_WAR_ACTIVITY then
		if IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA_PREPARE_ROS)
		end
	end
end
function PopupWindowPanel:onClickHelp(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT then
		userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.RECHARGE_PRESENT)
	end
end
return PopupWindowPanel
