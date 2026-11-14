local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonItemShowBoxPanel = class("CommonItemShowBoxPanel", baseFguiPanel)
function CommonItemShowBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommonItemShowBoxPanel:ctor", self.viewName)
end
local convertLvInfo = function(judgeLv)
	local des = ""
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(judgeLv)
	if 0 < warLv then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = warLv
			;(nil).title = i18n("common_text_4267", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = warLv
			des = i18n("common_text_4267", nil)
		end
	elseif judgeLv >= CASTLE_MAXLV_NOWAR then
		if 0 < judgeLv % 10 then
			_ENV = nil
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			;(nil).title = i18n("common_text_3452", nil)
			_ENV = nil
			;(nil).num = judgeLv % 10 * 10
			;(nil).char = "%"
			;(nil).des = i18n("common_text_1470", nil)
			des = i18n("common_text_2482", nil)
		else
			_ENV = nil
			;(nil).lv = CASTLE_MAXLV_NOWAR
			des = i18n("common_text_3452", nil)
		end
	else
		_ENV = nil
		;(nil).lv = judgeLv
		des = i18n("common_text_3452", nil)
	end
	return des
end
function CommonItemShowBoxPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function CommonItemShowBoxPanel:onInit()
	print("=======CommonItemShowBoxPanel:onInit")
	self.itemList, _ENV, self.itemID = self.proxy.param.itemID, self.proxy.param.itemID, self.proxy.param.itemID
	self.fields.Panel_bg:setString(publicRead.getName(self.itemID))
	self.fields.Text_headItemDes:setString(publicRead.getDes(self.itemID))
	self.fields.Com_Item:initData(self.itemID, 0)
	local cond = publicRead.checkLevelCondition(self.itemID)
	if cond and cond.needCastleLevel then
		local des = convertLvInfo(cond.needCastleLevel)
		self.fields.Text_limitTip:setString(des)
	end
	self.fields.Com_Award:initData(self.itemID)
	self.fields.Text_headItemDes:fixPos()
	self.fields.Com_Item:fixPos()
end
function CommonItemShowBoxPanel:onShow()
	print("=======CommonItemShowBoxPanel:onShow")
end
return CommonItemShowBoxPanel
