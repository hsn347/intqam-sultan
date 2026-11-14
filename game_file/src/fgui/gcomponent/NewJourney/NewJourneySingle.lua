local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local NewJourneySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewJourney/NewJourneySingle", NewJourneySingle)
function NewJourneySingle:onInit()
	local offsetX = self.fields.Usm_1:getX() - self.fields.Button_go:getX()
	self:fixChildrenPos()
	self.fields.Icon_banner:fix()
	self.fields.Image_completeBg:fix()
	self.fields.Usm_1:setX(self.fields.Button_go:getX() + offsetX)
	self.fields.Text_complete:setString(i18n("common_text_2601"))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function NewJourneySingle:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	obj:initData(item.id, item.count)
end
function NewJourneySingle:onShow()
end
function NewJourneySingle:initData(cfg)
	self.data = cfg
	self.fields.Text_name:setString(i18n(cfg.name))
	self.fields.Text_content:setString(i18n(cfg.viceText))
	self.fields.Icon_banner:setURL(cfg.banner)
	princeGiftNewCtrl = cfg.banner
	cfg.banner[1] = "id"
	cfg.banner[2] = "count"
	self.itemList = serviceFunctions.tableFormat(cfg.itemIcon, cfg.banner)
	self.fields.List_award:setNumItems(#self.itemList)
	local status = false
	if self.data.activityId == 1 then
		local crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
		local curCrazyIndex = table.nums(crazyTrioData.receive) + 1
		status = curCrazyIndex > cfg.identical
	elseif self.data.activityId == 2 then
		status = princeGiftNewCtrl:getIsBuy()
	elseif self.data.activityId == 3 then
		status = castleRewardCtrl:getIsBuy()
	elseif self.data.activityId == 4 then
		local buffMonthData = rechargeActivityCtrl:getMonthActivityList()
		if next(buffMonthData) then
			for k, v in pairs(buffMonthData) do
				if v.isbuy and v.totalday and v.totalday >= 30 then
					status = true
					break
				end
			end
		end
	end
	self.controllers.Ctrl_status:setSelectedIndex(status and 1 or 0)
end
function NewJourneySingle:onClickGo()
	print("跳转=========")
	if self.data.activityId == 1 then
		if activityShowCtrl:isActivityOpen(gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY) then
			SoraDCreatePanel("eventCrazyTrioSevenNew"):show()
			_ENV = gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY
			userSDKManager.logEvent(self.data.type == 1 and gSDKDef.TDonEvent.newJourney_click_activity1 or gSDKDef.TDonEvent.newJourney_click_activity5, gActivityCenterUIEnum.NEW_CRAZY_SEPTET_ACTIVITY)
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif self.data.activityId == 2 then
		local newPrinceGiftData = princeGiftNewCtrl:getNewPrinceData()
		if newPrinceGiftData then
			activityShowCtrl = princeGiftNewCtrl
			local princeGiftNewCtrl[1], giftArray = 14308, princeGiftNewCtrl
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").rechargeIDList = giftArray
				uiManager:show("rechargeView", i18n("common_text_2486"))
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNodeByList(24, giftArray)
				panel:show()
			end
			_ENV = panel
			userSDKManager.logEvent(gSDKDef.TDonEvent.newJourney_click_activity2, panel)
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	elseif self.data.activityId == 3 then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY, true) then
			SoraDCreatePanel("castleRewardView"):show()
			_ENV = true
			userSDKManager.logEvent(gSDKDef.TDonEvent.newJourney_click_activity3, true)
		end
	elseif self.data.activityId == 4 then
		if not rechargeActivityCtrl:getMonthActivityList() then
			local _ENV, monthData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
		end
		if next(monthData) then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = i18n("common_text_2486")
				i18n("common_text_2486").toCategory = gRechargeCenterCategory.MONTH
				i18n("common_text_2486").toNodeTag = 1
				uiManager:show("rechargeView", i18n("common_text_2486"))
			else
				local rechargeView = SoraDCreatePanel("rechargeView")
				rechargeView:jumpToWeeklyTab()
				rechargeView:show()
			end
			_ENV = rechargeView
			userSDKManager.logEvent(gSDKDef.TDonEvent.newJourney_click_activity4, rechargeView)
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	end
	SoraDPlaySound()
end
return NewJourneySingle
