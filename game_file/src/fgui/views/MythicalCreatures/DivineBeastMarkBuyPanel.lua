local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkBuyPanel = class("DivineBeastMarkBuyPanel", baseFguiPanel)
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function DivineBeastMarkBuyPanel:ctor(...)
	self.isLRU = true
	DivineBeastMarkBuyPanel.super.ctor(self, ...)
	print("DivineBeastMarkBuyPanel:ctor", self.viewName)
end
function DivineBeastMarkBuyPanel:onInit()
	print("=======DivineBeastMarkBuyPanel:onInit")
	self.fields.Button_Buy:setTitle(i18n("common_text_282"))
	self.fields.Button_Buy:addClickListener(handler(self, self.onClickExchange))
	self.view:fixChildrenPos()
end
function DivineBeastMarkBuyPanel:endShow()
	print("=======DivineBeastMarkBuyPanel:endShow")
	self:updateView()
end
function DivineBeastMarkBuyPanel:updateView()
	SoraDCloseLoading(self)
	local data = self.param
	self.cfg = data
	dump(self.cfg, "self.cfg")
	self.fields.Panel_bg:setString(i18n("Divine_beast_mark_text_102"))
	self.exchangeItemID = data.exchangeitem
	self.ownNum = backpackCtrl:getItemCount(data.exchangeitem)
	self.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(data.activityID, data.shopItemID)
	self.fields.Button_Buy:setCost(data.exchangeitem, data.exchangenum, true)
	self.leftCount = math.max(0, data.limitnum - self.curExchangeNum)
	self.fields.com_item:initData(data.shopitem, data.shopitemnum ~= 1 and data.shopitemnum or nil)
	self.fields.Text_name:setString(publicRead.getName(data.shopitem))
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
end
function DivineBeastMarkBuyPanel:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.fields.Text_Limit:setString("")
	else
		_ENV, _ENV = self.fields.Text_Limit, self.fields.Text_Limit.setString
		self.fields.Text_Limit.setString.num, self.fields.Text_Limit.color = self.fields.Text_Limit, 0 < self.leftCount and "#B4AA87" or "#FF0000"
		local style = self.fields.Text_Limit.setString
		if limitType == 1 then
			_ENV = nil
			;(nil).num = self.leftCount
			self.fields.Text_Limit:setString(i18n_html("common_text_4599", nil, style))
		elseif limitType == 2 then
			_ENV = i18n_html("common_text_4599", nil, style)
			i18n_html("common_text_4599", nil, style).num = self.leftCount
			i18n_html("common_text_4599", nil, style).limitNum = limitnum
			self.fields.Text_Limit:setString(i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)))
		elseif limitType == 3 then
			_ENV = i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))
			i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)).num = self.leftCount
			self.fields.Text_Limit:setString(i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))))
		elseif limitType == 4 then
			_ENV = i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)))
			i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))).num = self.leftCount
			self.fields.Text_Limit:setString(i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)))))
		elseif limitType == 7 then
			_ENV = i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))))
			i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)))).num = self.leftCount
			i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style)))).num2 = limitnum
			self.fields.Text_Limit:setString(i18n_html("Divine_beast_mark_text_106") .. i18n_html("%{num}/%{num2}", i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))))))
		else
			self.fields.Text_Limit:setString("")
		end
	end
end
function DivineBeastMarkBuyPanel:onClickExchange()
	SoraDPlaySound()
	if self.leftCount <= 0 then
		SoraDShowMsgTip(i18n("Divine_beast_mark_text_107"))
		return
	end
	local curNum = math.min(math.floor(self.ownNum / self.cfg.exchangenum), self.leftCount)
	if curNum <= 0 then
		_ENV = i18n("Divine_beast_mark_text_107")
		i18n("Divine_beast_mark_text_107").itemID = self.exchangeItemID
		uiManager:show("CommonSourceGuide", i18n("Divine_beast_mark_text_107"))
		return
	end
	SoraDShowLoading(self, nil, nil, true)
	activityExchangeMallCtrl:reqActivityExchange(self.cfg.shopItemID, 1)
end
return DivineBeastMarkBuyPanel
