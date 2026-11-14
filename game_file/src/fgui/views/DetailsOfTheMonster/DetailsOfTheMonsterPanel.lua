local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DetailsOfTheMonsterPanel = class("DetailsOfTheMonsterPanel", baseFguiPanel)
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
function DetailsOfTheMonsterPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DetailsOfTheMonsterPanel:ctor", self.viewName)
end
function DetailsOfTheMonsterPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DetailsOfTheMonsterPanel:onInit()
	self.fields.Panel_bg:setTitle(i18n("common_text_059"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	print("=======DetailsOfTheMonsterPanel:onInit")
end
function DetailsOfTheMonsterPanel:onShow()
	print("=======DetailsOfTheMonsterPanel:onShow")
	_UPVALUE3_, self.monsterDetail = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)
	self.titles, allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)[1] = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), i18n("alliance_stronghold_text_049")
	self.titles, allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)[2] = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), i18n("devilvalley_btn_06")
	self.titles, allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)[3] = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), i18n("alliance_stronghold_text_052")
	self.titles, allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)[4] = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), i18n("devilvalley_btn_04")
	self.titles, allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id)[5] = allianceStrongholdMineRead.getHoldMonsterDetails(self.proxy.param.id), i18n("devilvalley_btn_04")
	self.fields.scroll:setNumItems(#self.monsterDetail)
end
function DetailsOfTheMonsterPanel:onHide()
	print("=======DetailsOfTheMonsterPanel:onHide")
end
function DetailsOfTheMonsterPanel:onDispose()
	print("=======DetailsOfTheMonsterPanel:onDispose")
end
function DetailsOfTheMonsterPanel:onItemRenderer(index, obj)
	local curIndex = #self.monsterDetail - index
	local monsterCfgs = self.monsterDetail[curIndex]
	local title = self.titles[index + 1]
	obj:initData(monsterCfgs, title)
end
return DetailsOfTheMonsterPanel
