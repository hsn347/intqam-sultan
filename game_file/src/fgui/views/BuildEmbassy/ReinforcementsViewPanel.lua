local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ReinforcementsViewPanel = class("ReinforcementsViewPanel", baseFguiPanel)
function ReinforcementsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ReinforcementsViewPanel:ctor", self.viewName)
	self.tablePartyList, _ENV, self.isHideCurrentSceneView = print, print, true
	self.totalArmyCount = 0
	self.totalContentArmyCount = 0
end
function ReinforcementsViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function ReinforcementsViewPanel:onInit()
	print("=======ReinforcementsViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_010"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_noParty:setString(i18n("common_text_553"))
end
function ReinforcementsViewPanel:onShow()
	print("=======ReinforcementsViewPanel:onShow")
	self.totalContentArmyCount = buildLogic.getEmbassyReinforcements().total
	self:updateTextArmyCount()
	kingdomMapCtrl:reqArmyHelpList()
end
function ReinforcementsViewPanel:bindData(target, redata)
	self.totalContentArmyCount = buildLogic.getEmbassyReinforcements().total
	local buildLogic, armypartylist = buildLogic.getEmbassyReinforcements().total, buildLogic.getEmbassyReinforcements().total
	for i, v in ipairs(redata.data) do
		local insertAble = true
		for _, val in pairs(self.tablePartyList) do
			if v.data.id == val.qid then
				insertAble = false
				break
			end
		end
		if insertAble then
			local armyL = v.data.from.army[1].armyList and v.data.from.army[1].armyList or v.data.from.army
			buildLogic = nil
			;(nil).qid = v.data.id
			;(nil).headIcon = v.data.from.headid
			;(nil).avatar = v.data.from.avatar
			;(nil).totalPower = v.data.from.totalFc
			;(nil).name = v.data.from.name
			;(nil).armylist = armyL
			;(nil).heroList = v.data.from.heroInfo
			;(nil).armsList = v.data.from.armsInfo
			buildLogic, (nil).divineBeastList = v.data.from.divineBeastInfo, v.data.from.divineBeastInfo
			v.data.from.divineBeastInfo.x = v.data.from.x
			;(nil).pos, v.data.from.divineBeastInfo.y = v.data.from.divineBeastInfo, v.data.from.y
			table.insert(armypartylist, nil)
		end
	end
	if next(armypartylist) then
		self:initData(armypartylist)
	end
end
function ReinforcementsViewPanel:initData(armypartylist)
	if armypartylist then
		for _, v in ipairs(armypartylist) do
			table.insert(self.tablePartyList, v)
		end
		for _, v in ipairs(self.tablePartyList) do
			v.isFold = true
		end
	end
	if not next(self.tablePartyList) then
		self.totalArmyCount = 0
		self:updateTextArmyCount()
		self.fields.Text_noParty:setVisible(true)
		return
	else
		self.fields.Text_noParty:setVisible(false)
	end
	self:initView()
end
function ReinforcementsViewPanel:initView()
	self.fields.List:setNumItems(#self.tablePartyList)
	self.totalArmyCount = 0
	for __, data in ipairs(self.tablePartyList) do
		self.totalArmyCount = self.totalArmyCount + self:getTotalArmyCount(data.armylist)
	end
	self:updateTextArmyCount()
end
function ReinforcementsViewPanel:delTroop(target, redata)
	local uid = redata.data[1]
	self:localUpdate(uid)
end
function ReinforcementsViewPanel:localUpdate(uid)
	if not uid then
		return
	end
	for i, data in ipairs(self.tablePartyList) do
		if data.qid == uid then
			self.totalArmyCount = self.totalArmyCount - self:getTotalArmyCount(data.armylist)
			self:updateTextArmyCount()
			table.remove(self.tablePartyList, i)
			break
		end
	end
	self.fields.List:setNumItems(#self.tablePartyList)
	self.fields.Text_noParty:setVisible(not next(self.tablePartyList))
end
function ReinforcementsViewPanel:onItemRenderer(index, obj)
	local data = self.tablePartyList[index + 1]
	obj:initData(data, data.isFold)
end
function ReinforcementsViewPanel:getTotalArmyCount(armyList)
	local ret = 0
	for __, army in ipairs(armyList) do
		ret = ret + army.num
	end
	return ret
end
function ReinforcementsViewPanel:updateTextArmyCount(...)
	self.fields.Text_armyCount:setString(string.formatnumberthousands(self.totalArmyCount) .. "/" .. string.formatnumberthousands(self.totalContentArmyCount))
end
return ReinforcementsViewPanel
