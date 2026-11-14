local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityID = gActivityTimeActivityID.DAILY_SALUTE
local baseComponent = require("fgui.base.baseComponent")
local Com_signSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001688/Com_signSingle", Com_signSingle)
function Com_signSingle:onInit()
	self.fields.txt_got:setString(i18n("common_text_2874"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_signGold:setString(i18n("common_text_2875"))
	self.fields.Button_signGold:addClickListener(handler(self, self.btnSignGoldClick))
	self.fields.Button_sign:setString(i18n("common_text_2873"))
	self.fields.Button_sign:addClickListener(handler(self, self.btnSignClick))
	self:fixChildrenPos()
end
function Com_signSingle:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_signSingle:onShow()
end
function Com_signSingle:initData(cfg, day)
	self.day = day
	self.needGold = 0
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#E2AF27", day)
	self.fields.Task_Des:setString(i18n("daily_salute_text22", nil))
	activityID = i18n("daily_salute_text22", nil)
	i18n("daily_salute_text22", nil)[1] = "id"
	i18n("daily_salute_text22", nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(cfg.normalReward, i18n("daily_salute_text22", nil))
	self.fields.List_reward:setNumItems(#self.reward)
	local curDay = activityCommonSignCtrl:getCurDay(activityID)
	local signState = activityCommonSignCtrl:getSignInfoByDay(activityID, day)
	local status = 0
	if signState == gSignRewardType.NO_SIGN then
		status = day < curDay and 2 or 0
		if curDay == day then
			status = 1
			self.fields.Button_sign:setReddot(true)
		end
	else
		status = 3
	end
	if status == 2 then
		self.needGold = activityCommonSignCtrl:getCostGold(activityID)
		self.fields.Button_signGold:setCost(gIDDef.GOLD, self.needGold)
	end
	self.controllers.status:setSelectedIndex(status)
end
function Com_signSingle:btnSignClick()
	SoraDPlaySound()
	activityCommonSignCtrl:reqSign(activityID)
end
function Com_signSingle:btnSignGoldClick()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).NUM = self.needGold
	;(nil).content = i18n("Icefestival2024_text02", nil)
	;(nil).confirmFunc = function()
		SoraDPlaySound()
		if SoraDEnoughGold(self.needGold) then
			activityCommonSignCtrl:reqUseGoldSign(activityID, self.day)
		end
	end
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	uiManager:show("MessageBox", nil)
end
return Com_signSingle
