local armyDesRead = include("armyDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorRebornBlessPanel = class("NebulaEmperorRebornBlessPanel", baseFguiPanel)
function NebulaEmperorRebornBlessPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorRebornBlessPanel:ctor", self.viewName)
end
function NebulaEmperorRebornBlessPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "StarEnergyCube"
	end
	return self._packageList
end
function NebulaEmperorRebornBlessPanel:onInit()
	print("=======NebulaEmperorRebornBlessPanel:onInit")
	if not SoraDFIsRA() then
		self.fields.Sprite_title_t:setURL("frame_xydw_zhufu_en.png")
	end
	self.fields.Text_tips_t:setString(i18n("heroicSouls_text_9"))
	self.fields.Text_tips_b:setString(i18n("heroicSouls_text_3"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
end
function NebulaEmperorRebornBlessPanel:onShow()
	print("=======NebulaEmperorRebornBlessPanel:onShow")
	local activityID = self.param.activityID
	self:initData(activityID)
end
function NebulaEmperorRebornBlessPanel:initData(activityID)
	self.activityID = activityID
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		self.cureArmyList = nebulaEmperorCtrl:getCureArmyList()
		self.blessArmyList = nebulaEmperorCtrl:getBlessArmyList()
		self.fields.Text_tips_t:setString(i18n("nebulaemperor_text_126"))
		self.fields.Text_tips_b:setString(i18n("nebulaemperor_text_130"))
	else
		self.cureArmyList = landOfSoulCtrl:getCureArmyList()
		self.blessArmyList = landOfSoulCtrl:getBlessArmyList()
	end
	self:initScroll()
end
function NebulaEmperorRebornBlessPanel:initScroll(...)
	local _ENV, ret
	_ENV = nil
	;(nil).itemType = 1
	;(nil).subType = 1
	;(nil).title = i18n("nebulaemperor_text_128")
	table.insert(ret, nil)
	for k, v in pairs(self.blessArmyList) do
		_ENV = nil
		;(nil).itemType = 2
		_ENV, (nil).subType = nil, 1
		;(nil).id = k
		;(nil).army, (nil).num = nil, v
		table.insert(ret, nil)
	end
	_ENV = pairs(self.blessArmyList)
	pairs(self.blessArmyList).itemType = 1
	pairs(self.blessArmyList).subType = 2
	pairs(self.blessArmyList).title = i18n("nebulaemperor_text_129")
	table.insert(ret, pairs(self.blessArmyList))
	for k, v in pairs(self.cureArmyList) do
		_ENV = nil
		;(nil).itemType = 2
		_ENV, (nil).subType = nil, 2
		;(nil).id = k
		;(nil).army, (nil).num = nil, v
		table.insert(ret, nil)
	end
	self.listData = ret
	self.fields.List:setNumItems(#self.listData)
end
function NebulaEmperorRebornBlessPanel:onItemRederer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local data = self.listData[index + 1]
	local subType = data.subType
	obj:getController("c1"):setSelectedIndex(subType - 1)
	if data.itemType == 1 then
		obj:setString(data.title)
	else
		local armyData = data.army
		_fields.Text_armyName:setString(armyDesRead.getName(armyData.id))
		_fields.Text_armyCount:setString(string.formatnumberthousands(armyData.num))
		_fields.Com_army:initData(armyData.id)
	end
end
function NebulaEmperorRebornBlessPanel:onItemProvider(index)
	local data = self.listData[index + 1]
	if data.itemType == 1 then
		return "ui://NebulaEmperorOfficer/RebornBless_title"
	else
		return "ui://NebulaEmperorOfficer/RebornBless_item"
	end
end
return NebulaEmperorRebornBlessPanel
