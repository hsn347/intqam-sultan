local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local militaryRankCtrl = SoraDGetCtrl("militaryRankCtrl")
local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local militaryRankRead = include("militaryRankRead")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_List2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_List2", Com_List2)
function Com_List2:onInit()
	self.fields.Button_buy:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_List2:onShow()
end
function Com_List2:initData(data)
	self.data = data
	self.fields.com_item:initData(self.data.id)
	if self.data.itemType == gRechargeVipDef.normalItem then
		self.fields.Text_name:setString(itemDesRead.getName(self.data.id))
	elseif self.data.itemType == gRechargeVipDef.equipment then
		self.fields.Text_name:setString(equipDesRead.getName(self.data.id))
		local wearLv = equipmentltCtrl.getEquipmentLv(self.data.id)
		_ENV = equipDesRead.getName(self.data.id)
		equipDesRead.getName(self.data.id).lv = wearLv
		self.fields.com_item:setNumText(i18n("common_text_100", equipDesRead.getName(self.data.id)))
		self.fields.com_item:setQualityIcon(equipDesRead.getBg(self.data.qlv))
	end
	self.curPoint = lordInfoCtrl:getLordInfo().militaryRankInfo.exploit
	local canBuyCount = self.data.leftCount or 1
	local enableBtn = self.curPoint >= self.data.needPoint and lordInfoCtrl:getLordInfo().militaryRankInfo.level >= self.data.needRank and 0 < canBuyCount
	local showLabel = lordInfoCtrl:getLordInfo().militaryRankInfo.level < self.data.needRank or canBuyCount <= 0
	_ENV = equipDesRead.getBg(self.data.qlv)
	equipDesRead.getBg(self.data.qlv).rank = militaryRankRead.getRankNameByLv(self.data.needRank)
	self.fields.Text_NeedRank:setString(i18n("common_text_2409", equipDesRead.getBg(self.data.qlv)))
	self.fields.Text_NeedRank:setColor(showLabel and cc.c3b(224, 43, 43) or cc.c3b(180, 170, 135))
	if canBuyCount <= 0 then
		self.fields.Text_Limit:setColor(cc.c3b(224, 43, 43))
		if self.data.exchange == 2 then
			self.fields.Text_Limit:setString(i18n("Military_text_04"))
		else
			self.fields.Text_Limit:setString(i18n("common_text_2481"))
		end
	else
		self.fields.Text_Limit:setColor(cc.c3b(180, 170, 135))
		if self.data.exchange == 2 then
			_ENV = cc.c3b(180, 170, 135)
			cc.c3b(180, 170, 135).num = canBuyCount
			self.fields.Text_Limit:setString(i18n("common_text_4600", cc.c3b(180, 170, 135)))
		else
			_ENV = i18n("common_text_4600", cc.c3b(180, 170, 135))
			i18n("common_text_4600", cc.c3b(180, 170, 135)).num = canBuyCount
			self.fields.Text_Limit:setString(i18n("common_text_4599", i18n("common_text_4600", cc.c3b(180, 170, 135))))
		end
	end
	self.fields.Button_buy:setIcon("icon_military_point.png")
	self.fields.Button_buy:setTitle(self.data.needPoint)
	self.fields.Button_buy:setEnabled(enableBtn)
end
function Com_List2:btnClick()
	SoraDPlaySound()
	if self.data.itemType == gRechargeVipDef.equipment then
		local equipLv = equipmentltCtrl.getEquipmentLv(self.data.id)
		if SoraDGetCastleLv() < CASTLE_LV10_LIMITED then
			_ENV = nil
			;(nil).lv = CASTLE_LV10_LIMITED
			SoraDShowMsgTip(i18n("common_text_1973", nil))
			return
		elseif equipLv > SoraDGetLordLv() then
			_ENV = i18n("common_text_1973", nil)
			i18n("common_text_1973", nil).lv = equipLv
			SoraDShowMsgTip(i18n("common_text_1974", i18n("common_text_1973", nil)))
			return
		end
	end
	_ENV, _ENV, _ENV = i18n("common_text_1974", i18n("common_text_1973", nil))
	i18n("common_text_1974", i18n("common_text_1973", nil)).targetID = self.data.id
	i18n("common_text_1974", i18n("common_text_1973", nil)).exchangeID = gIDDef.MILITARY_EXPLOIT
	i18n("common_text_1974", i18n("common_text_1973", nil)).singCount = self.data.needPoint
	i18n("common_text_1974", i18n("common_text_1973", nil)).curNum = math.min(self.data.leftCount, math.floor(self.curPoint / self.data.needPoint))
	i18n("common_text_1974", i18n("common_text_1973", nil)).exchangeData, i18n("common_text_1974", i18n("common_text_1973", nil)).singleGet = i18n("common_text_1974", i18n("common_text_1973", nil))
	i18n("common_text_1974", i18n("common_text_1973", nil)).exchangeCfg, i18n("common_text_1974", i18n("common_text_1973", nil)).exchangeHandler = i18n("common_text_1974", i18n("common_text_1973", nil))
	uiManager:show("newShopSingleBuy", i18n("common_text_1974", i18n("common_text_1973", nil)))
end
return Com_List2
