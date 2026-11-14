local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local itemDesRead = include("itemDesRead")
local allianceltCtrl = include("allianceltCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local AllianceShopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceShopView/AllianceShopSingle", AllianceShopSingle)
function AllianceShopSingle:onInit()
	self:fixChildrenPos()
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_return:addClickListener(handler(self, self.btnReturnGoodsClick))
	self.fields.Com_Item:setClickCallback(handler(self, self.btnNoticeClick))
end
function AllianceShopSingle:onShow()
end
function AllianceShopSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.updatePoint))
end
function AllianceShopSingle:initData(curType, data)
	self.curType = curType
	dump(data, "AllianceShopSingle")
	self:setItemData(data)
	self:updatePoint()
end
function AllianceShopSingle:setItemData(data)
	self.data = data
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	self.fields.Button_return:setVisible(ownRank >= gAllianceRank.R4 and self.curType == gIDDef.ALLIANCE_HONOR)
	self.fields.Image_Shalou:setVisible(false)
	if data.endtime then
		self.fields.Com_Item:setTouchable(true)
		self.fields.Image_Shalou:setVisible(true)
	else
		self.fields.Com_Item:setTouchable(false)
	end
	self.pay = allianceltCtrl.getPrice(data.itemID, self.curType)
	local count = tolua.type(data.itemCount) == "number" and data.itemCount
	self.fields.Com_Item:initData(data.itemID, count)
	self.fields.Text_name:setString(publicRead.getName(data.itemID))
	local str
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.fields.Button_buy:setIcon("icon_alliance_honor.png")
		str = i18n("common_text_1889")
	else
		self.fields.Button_buy:setIcon("icon_alliance_point.png")
		str = i18n("common_text_4290")
	end
	self.fields.Button_buy:setString(string.formatnumberthousands(self.pay) .. "\n" .. str)
end
function AllianceShopSingle:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.totalPoint = memberMgr:getOwnMember():getProperty("playerHonor")
	else
		self.totalPoint = allianceMgr:getAllianceProperty("bonus")
	end
end
function AllianceShopSingle:onClickBuy()
	SoraDPlaySound()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		local itemID = self.data.itemID
		local personalLimit = allianceltCtrl:getMaxBuyCount(itemID)
		local cMember = memberMgr:getOwnMember()
		local aStoreBuyInfo = cMember:getProperty("aStoreBuyInfo")
		local buyCount = aStoreBuyInfo[tostring(itemID)] and aStoreBuyInfo[tostring(itemID)].count or 0
		local lastBuyTime = aStoreBuyInfo[tostring(itemID)] and aStoreBuyInfo[tostring(itemID)].time or 0
		if personalLimit and serviceFunctions.isSameDay(lastBuyTime) and personalLimit - buyCount <= 0 then
			SoraDShowMsgTip(i18n("opt_package_text_11"))
			return
		end
		if self.totalPoint >= self.pay then
			self:showBuyView()
		else
			SoraDShowMsgBox(i18n("notice_0085"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					if GLOBAL_GAME_ALLIANCE_MODE then
						uiManager:show("AllianceScience")
					else
						SoraDCreatePanel("allianceScienceView"):show()
					end
				end
			end)
		end
	elseif memberMgr:getOwnMember():getProperty("rank") < gAllianceRank.R4 then
		SoraDShowMsgTip(i18n("common_text_661"), "#icon_alliance_point.png")
	elseif self.totalPoint >= self.pay then
		self:showBuyView()
	else
		SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("AllianceScience")
				else
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end
		end)
	end
end
function AllianceShopSingle:showBuyView()
	local _ENV, data
	local count = tolua.type(self.data.itemCount) == "number" and self.data.itemCount
	if self.curType == gIDDef.ALLIANCE_HONOR then
		_ENV = self.curType
		self.curType.itemID = self.data.itemID
		self.curType.itemCount = count
		self.curType.price = self.pay
		self.curType.totalPoint = self.totalPoint
		data, self.curType.endtime = self.curType, self.data.endtime
	else
		_ENV = self.curType
		self.curType.itemID = self.data.itemID
		self.curType.price = self.pay
		self.curType.totalPoint = self.totalPoint
		data, self.curType.endtime = self.curType, self.data.endtime
	end
	_ENV = nil
	;(nil).itemData = data
	;(nil).curType = self.curType
	uiManager:show("AllianceShopSingleBuy", nil)
end
function AllianceShopSingle:btnReturnGoodsClick()
	SoraDPlaySound()
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank < gAllianceRank.R4 then
		SoraDShowMsgTip(i18n("alliance_store_returns_description_5"))
		return
	end
	local cdValue = constantRead.getConstValue("ALLIANCE_RETURN_CD")
	local lastTime = ownmember:getProperty("lastReturnGoodsTime") or 0
	if lastTime + cdValue > serviceFunctions.systemTime() then
		_ENV = i18n("alliance_store_returns_description_5")
		i18n("alliance_store_returns_description_5").var = math.ceil((lastTime + cdValue - serviceFunctions.systemTime()) / 60)
		SoraDShowMsgTip(i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_5")))
	else
		print("显示退货框")
		_ENV = i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_5"))
		i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_5")).itemData = self.data
		uiManager:show("AllianceShopSingleBuy", i18n("alliance_store_returns_description_6", i18n("alliance_store_returns_description_5")))
	end
end
function AllianceShopSingle:btnNoticeClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).endTime = self.data.endtime
	uiManager:show("AllianceShopLimited", nil)
end
return AllianceShopSingle
