local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_menuList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/Com_menuList", Com_menuList)
function Com_menuList:onInit()
	self.giftList, _ENV = nil, nil
	self.index = 1
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.Button_all:setString(i18n("recharge_setting_text_04"))
	self.fields.Button_all:addClickListener(handler(self, self.onBtnAllClick))
	self.fields.Button_all:setVisible(false)
end
function Com_menuList:onItemRenderer(index, obj)
	local rechargeRead, info
	local giftData = self.giftList[index + 1]
	if giftData.group then
		info = rechargeRead.getPageViewData(giftData.data[1].data.ID or giftData.data[1].rid)
	elseif giftData.rType == gRechargeActiveModelType.CLIENTLADDER then
		info = rechargeRead.getPageViewData(giftData.ID)
	elseif giftData.rType == gRechargeActiveModelType.LUCKYGIFT then
		info = rechargeRead.getPageViewData(giftData.data.luckyGiftID)
	else
		info = rechargeRead.getPageViewData(giftData.data.ID or giftData.data.rechargeID)
	end
	local giftName = info and i18n(info.activeName) or ""
	obj:setTitle(giftName)
	obj:setSelected(index + 1 == self.index)
end
function Com_menuList:onChooseItem()
	local index = self.fields.List:getSelectedIndex()
	self.index = index + 1
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RECHARGECENTER_MENU_GIFT_INDEX"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
function Com_menuList:onShow()
end
function Com_menuList:initData(data, index, func, category)
	self.giftList = data
	self.index = index or 1
	self.oriList = func()
	self.category = category
	self.fields.List:setNumItems(#self.giftList)
	self:checkShowAll()
end
function Com_menuList:checkShowAll()
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:Recharge:hideGift~table", nil) then
		local _ENV, hideList = SoraDConfigGet("Game:Recharge:hideGift~table", nil), SoraDConfigGet("Game:Recharge:hideGift~table", nil)
	end
	local ret = false
	for _, v in ipairs(self.oriList) do
		if v.rType == gRechargeActiveModelType.CLIENTLADDER or v.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
			for _, n in ipairs(v.data) do
				local isInLadder = false
				for _, m in ipairs(n.nextLadderList) do
					if hideList[tostring(m.ID)] then
						isInLadder = true
					end
				end
				if hideList[tostring(n.ID)] or isInLadder then
					ret = true
				end
			end
		else
			local rid = v.data and (v.data.ID or v.data.rechargeID or v.data.luckyGiftID) or v.ID
			local category = v.data and v.data.category or v.category
			if category == self.category and hideList[tostring(rid)] then
				ret = true
				break
			end
		end
	end
	self.fields.Button_all:setVisible(ret)
	self.fields.List:setHeight(ret and 260 or 310)
end
function Com_menuList:onBtnAllClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("recharge_setting_text_05"))
	_ENV = i18n("recharge_setting_text_05")
	i18n("recharge_setting_text_05").byUID = true
	if not SoraDConfigGet("Game:Recharge:hideGift~table", i18n("recharge_setting_text_05")) then
		local _ENV, hideList = SoraDConfigGet("Game:Recharge:hideGift~table", i18n("recharge_setting_text_05")), SoraDConfigGet("Game:Recharge:hideGift~table", i18n("recharge_setting_text_05"))
	end
	for _, v in ipairs(self.oriList) do
		if v.rType == gRechargeActiveModelType.CLIENTLADDER or v.rType == gRechargeActiveModelType.BIRTHDAY_LADDER then
			for _, n in ipairs(v.data) do
				for _, m in ipairs(n.nextLadderList) do
					if hideList[tostring(m.ID)] then
						hideList[tostring(m.ID)] = nil
					end
				end
				if hideList[tostring(n.ID)] then
					hideList[tostring(n.ID)] = nil
				end
			end
		else
			local rid = v.data and (v.data.ID or v.data.rechargeID or v.data.luckyGiftID) or v.ID
			local category = v.data and v.data.category or v.category
			if category == self.category and hideList[tostring(rid)] then
				hideList[tostring(rid)] = nil
			end
		end
	end
	_ENV = i18n("recharge_setting_text_05")
	i18n("recharge_setting_text_05").byUID = true
	SoraDConfigSet("Game:Recharge:hideGift~table", hideList, i18n("recharge_setting_text_05"))
	_ENV = "Game:Recharge:hideGift~table"
	;("Game:Recharge:hideGift~table").msg = "MESSAGE_UI_RECHARGECENTER_HIDE_GIFT"
	SoraDSendMessage("Game:Recharge:hideGift~table")
end
return Com_menuList
