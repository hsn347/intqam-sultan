local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001612_Ctrl = SoraDGetCtrl("activity_9001612_Ctrl")
local activity_9001612_Read = include("activity_9001612_Read")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001612 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001612/Com_Activity_9001612", Com_Activity_9001612)
function Com_Activity_9001612:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_STORE
	self.coinID = constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM")
	self.shopList, _ENV, self.tag = constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM"), constantRead.getConstValue("PLAYER_GLORY_RETURN_STORE_ITEM"), 1
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Btn_help:fixPos()
	self.fields.Lab_gold:fixPos()
end
function Com_Activity_9001612:onListRenderer(index, obj)
	obj:initData(self.shopList[index + 1])
end
function Com_Activity_9001612:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001612_UPDATE", handler(self, self.initData))
end
function Com_Activity_9001612:onShow()
	self.fields.timer:initCommonActivityTime(self.activityID)
	self.backStarLv = lordInfoCtrl:getBackStarLv()
	lordInfoCtrl = self.activityID
	lordInfoCtrl, lordInfoCtrl, self.activityID.defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("war_report_text_0001")
	lordInfoCtrl, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_2975")
	lordInfoCtrl, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("Ramadan_2024_text53")
	lordInfoCtrl, self.tag[3], (nil).tag = nil, nil, 3
	;(nil).title = i18n("atlantiswar_text_0321")
	self.activityID.tabsetArray, self.tag[4], (nil).tag = self.tag, nil, 4
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(self.activityID)
end
function Com_Activity_9001612:onTabClick(tag)
	self.tag = tag
	local shopCfg = activity_9001612_Read.getShopList(self.tag, self.backStarLv)
	self.shopList, activity_9001612_Read = self.tag, self.tag
	for i = 1, #shopCfg, 2 do
		activity_9001612_Read = nil
		;(nil).left = shopCfg[i]
		;(nil).right = shopCfg[i + 1]
		table.insert(self.shopList, nil)
	end
	self:initData()
end
function Com_Activity_9001612:initData()
	self.fields.Lab_gold:initData()
	self.fields.List:setNumItems(#self.shopList)
	for i = 1, 4 do
		local retNum = 0
		local cfgList = activity_9001612_Read.getShopList(i, self.backStarLv)
		for k, v in ipairs(cfgList) do
			local exchangeTimes = activity_9001612_Ctrl:getExchangeTimes(v.shopItemID)
			if exchangeTimes < v.limitnum and backpackCtrl:getItemCount(self.coinID) >= v.exchangeitem then
				retNum = retNum + 1
			end
		end
		self.fields.com_Tab:setBtnRedDot(i, 0 < retNum, retNum)
	end
end
function Com_Activity_9001612:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Player_Return_test03")
	uiManager:show("RuleView", nil)
end
return Com_Activity_9001612
