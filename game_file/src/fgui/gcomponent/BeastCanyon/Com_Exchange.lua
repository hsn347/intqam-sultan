local publicRead = include("publicRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local divineBeastRead = include("divineBeastRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Exchange = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BeastCanyon/Com_Exchange", Com_Exchange)
function Com_Exchange:onInit()
	self:fixChildrenPos()
	self.fields.Button_buy:addClickListener(handler(self, self.onClickExchange))
	self.fields.Button_buy:fixChildrenPos()
end
function Com_Exchange:onShow()
end
function Com_Exchange:initData(data)
	self.cfg = data
	self.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(data.activityID, data.shopItemID)
	self.leftCount = math.max(0, data.limitnum - self.curExchangeNum)
	self.ownNum = backpackCtrl:getItemCount(data.exchangeitem)
	self.fields.com_item:initData(data.shopitem, data.shopitemnum)
	self.fields.Button_buy:setString(string.formatnumberthousands(data.exchangenum))
	self.fields.Button_buy:setIcon(publicRead.getIcon(data.exchangeitem))
	self.fields.Text_name:setString(publicRead.getName(data.shopitem))
	local limitLock = true
	self.limitTip = nil
	self.fields.Text_NeedRank:setString("")
	if (data.exLimit[1] == 3 or data.exLimit[1] == 4) and data.exLimit[2] ~= 0 then
		activityExchangeMallCtrl = data.exLimit[2]
		data.exLimit[2][3] = gBestID.ONE
		local data.exLimit[2][4], limitMap = gBestID.TWO, data.exLimit[2]
		limitLock = divineBeastCtrl:getIsUnlock(limitMap[data.exLimit[1]]) and divineBeastCtrl:getStepLv(limitMap[data.exLimit[1]]) >= data.exLimit[2]
		if not limitLock then
			activityExchangeMallCtrl = limitMap[data.exLimit[1]]
			limitMap[data.exLimit[1]].name = divineBeastRead.getName(limitMap[data.exLimit[1]])
			limitMap[data.exLimit[1]].lv = data.exLimit[2]
			self.limitTip = i18n("Divinebeastcanyon_text_26", limitMap[data.exLimit[1]])
		end
		activityExchangeMallCtrl = limitMap[data.exLimit[1]]
		limitMap[data.exLimit[1]].name = divineBeastRead.getName(limitMap[data.exLimit[1]])
		activityExchangeMallCtrl, activityExchangeMallCtrl, limitMap[data.exLimit[1]].lv = limitMap[data.exLimit[1]], data.exLimit[2], data.exLimit[2]
		data.exLimit[2].lv, limitMap[data.exLimit[1]].color = limitMap[data.exLimit[1]], limitLock and "#B4AA87" or "#FF0000"
		self.fields.Text_NeedRank:setString(i18n_html("Divinebeastcanyon_text_26", limitMap[data.exLimit[1]], data.exLimit[2]))
	end
	self.fields.Button_buy:setEnabled(true)
	self.fields.Button_buy:getChild("title"):setColor(self.ownNum < self.cfg.exchangenum and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	if not limitLock or self.leftCount <= 0 then
		self.fields.Button_buy:getChild("title"):setColor(cc.c3b(155, 155, 155))
		self.fields.Button_buy:setEnabled(false)
	end
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	if activityExchangeMallRead.checkIsSpecial(data.shopItemID) then
		self.fields.Image_bg:setURL("frame_common_brightcolor.png")
	else
		self.fields.Image_bg:setURL("frame_common_listbton.png")
	end
end
function Com_Exchange:setLeftCount(limitType, limitnum, curExchangeNum)
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
			self.fields.Text_Limit:setString(i18n_html("Hero_reshape_26", i18n_html("Divinebeastcanyon_text_27", i18n_html("common_text_4600", i18n_html("Icefestival2024_text26", i18n_html("common_text_4599", nil, style))))))
		else
			self.fields.Text_Limit:setString("")
		end
	end
end
function Com_Exchange:onClickExchange()
	SoraDPlaySound()
	local curNum = math.min(math.floor(self.ownNum / self.cfg.exchangenum), self.leftCount)
	if curNum <= 0 then
		_ENV = nil
		;(nil).item = publicRead.getName(self.cfg.exchangeitem)
		SoraDShowMsgTip(i18n("Glory_text_19", nil))
		return
	end
	if self.limitTip then
		SoraDShowMsgTip(self.limitTip)
		return
	end
	_ENV, _ENV, _ENV = i18n("Glory_text_19", nil)
	i18n("Glory_text_19", nil).targetID = self.cfg.shopitem
	i18n("Glory_text_19", nil).exchangeID = self.cfg.exchangeitem
	i18n("Glory_text_19", nil).singCount = self.cfg.exchangenum
	i18n("Glory_text_19", nil).curNum = curNum
	i18n("Glory_text_19", nil).exchangeData, i18n("Glory_text_19", nil).singleGet = i18n("Glory_text_19", nil)
	i18n("Glory_text_19", nil).exchangeCfg, i18n("Glory_text_19", nil).exchangeHandler = i18n("Glory_text_19", nil)
	uiManager:show("newShopSingleBuy", i18n("Glory_text_19", nil))
end
return Com_Exchange
