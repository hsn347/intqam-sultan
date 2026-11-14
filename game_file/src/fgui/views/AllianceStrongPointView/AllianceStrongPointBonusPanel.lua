local gametop = gModuleMgr.getObject("gametop")
local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceStrongPointBonusPanel = class("AllianceStrongPointBonusPanel", baseFguiPanel)
function AllianceStrongPointBonusPanel:ctor(...)
	AllianceStrongPointBonusPanel.super.ctor(self, ...)
	print("AllianceStrongPointBonusPanel:ctor", self.viewName)
end
function AllianceStrongPointBonusPanel:onInit()
	print("=======AllianceStrongPointBonusPanel:onInit")
	self.fields.Panel_bg:setString(i18n("alliance_stronghold_text_031"))
	self.Text_none = self.fields.Text_none
	self.Text_none:setString(i18n("alliance_stronghold_text_103"))
	self.Text_tip = self.fields.Node_tip:getChild("title")
	self.Text_tip:setString(i18n("alliance_stronghold_text_104"))
	fguiHelper.setTextWidthHeight(self.Text_tip, cc.size(540, 36))
	self.scroll = self.fields.List
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function AllianceStrongPointBonusPanel:onShow()
	print("=======AllianceStrongPointBonusPanel:onShow")
end
function AllianceStrongPointBonusPanel:initData()
	local bonusData = allianceStrontholdCtrl:getStrongholdBuff()
	local allianceStrontholdCtrl, showData = allianceStrontholdCtrl, allianceStrontholdCtrl
	for k, v in pairs(bonusData) do
		allianceStrontholdCtrl = nil
		;(nil).buff = k
		;(nil).val = v
		table.insert(showData, nil)
	end
	table.sort(showData, function(a, b)
		return a.buff < b.buff
	end)
	self.showData = showData
	if next(showData) then
		self.Text_none:setVisible(false)
		self.scroll:setVisible(true)
		self.scroll:setNumItems(#self.showData)
	else
		self.Text_none:setVisible(true)
		self.scroll:setVisible(false)
	end
end
function AllianceStrongPointBonusPanel:onItemRenderer(index, obj)
	local v = self.showData[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local Text_des = _fields.Text_des
	local Text_val = _fields.Text_val
	Text_des:setString(buffDesRead.getTitleBase(v.buff))
	local val = buffDesRead.getTitleValueWithValue(v.buff, v.val)
	if v.buff == gBuffEffect.INSTANT_BUILD_SPEED_BOOST then
		val = val .. "s"
	end
	Text_val:setString(val)
	if not SoraDFIsRA() then
		Text_des:fixPos()
		Text_val:fixPos()
	end
end
return AllianceStrongPointBonusPanel
