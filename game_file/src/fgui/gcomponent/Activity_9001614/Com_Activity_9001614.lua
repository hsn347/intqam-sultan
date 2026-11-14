local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001614_Ctrl = SoraDGetCtrl("activity_9001614_Ctrl")
local activity_9001614_Read = include("activity_9001614_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001614 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001614/Com_Activity_9001614", Com_Activity_9001614)
function Com_Activity_9001614:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_RECHARGE_REBATE
	self.targetList, _ENV, self.tag = gActivityTimeActivityID.HONOR_BACK_RECHARGE_REBATE, gActivityTimeActivityID.HONOR_BACK_RECHARGE_REBATE, 1
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Text_none:setString(i18n("recharge_return_text_05"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_help:fixPos()
end
function Com_Activity_9001614:onTargetRenderer(index, obj)
	obj:initData(self.targetList[index + 1], index + 1)
end
function Com_Activity_9001614:onShow()
	self.fields.timer:initCommonActivityTime(self.activityID)
	self.tabsetArray, activity_9001614_Read, self.typeCfg = activity_9001614_Read.getRechargeTypeCfg(), activity_9001614_Read.getRechargeTypeCfg(), activity_9001614_Read.getRechargeTypeCfg()
	for k, v in ipairs(self.typeCfg) do
		activity_9001614_Read = nil
		;(nil).title = i18n(v.labelName)
		;(nil).tag = v.rechargeType
		table.insert(self.tabsetArray, nil)
	end
	self.stageList, activity_9001614_Read, self.targetList = activity_9001614_Read.getRewardCfg(), activity_9001614_Read.getRewardCfg(), activity_9001614_Read.getRewardCfg()
	for k, v in ipairs(self.targetList) do
		table.insert(self.stageList, v.rechargeAmount)
	end
	self:initData()
end
function Com_Activity_9001614:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001614_UPDATE", handler(self, self.initData))
end
function Com_Activity_9001614:initData()
	local price = activity_9001614_Ctrl:getPrice()
	activity_9001614_Ctrl = nil
	;(nil).price = fguiHelper.getColorString("#FFDF2D", price)
	self.fields.Text_cumu:setString(i18n("recharge_return_text_02", nil))
	self.fields.Com_stage:initData(self.targetList, self.stageList)
	self.fields.Com_stage:setBarValue(price)
	activity_9001614_Ctrl = price
	price.defaultClick = self.tag
	price.tabsetArray = self.tabsetArray
	price.callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(price)
end
function Com_Activity_9001614:onTabClick(tag)
	self.giftList, activity_9001614_Read, self.tag = nil, nil, tag
	local giftList = activity_9001614_Read.getRechargeListCfg(self.tag)
	for k, v in ipairs(giftList) do
		if not activity_9001614_Ctrl:hasBoughtGift(v.rechargeid) then
			table.insert(self.giftList, v)
		end
	end
	self.fields.Text_none:setVisible(#self.giftList == 0)
	self.fields.page:setVisible(#self.giftList > 0)
	if #self.giftList > 0 then
		self.fields.page:initData(self.giftList, true)
	end
end
function Com_Activity_9001614:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("recharge_return_text_01")
	uiManager:show("RuleView", nil)
end
return Com_Activity_9001614
