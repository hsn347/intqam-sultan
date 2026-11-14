local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildUnlockedSingleInfoPanel = class("BuildUnlockedSingleInfoPanel", baseFguiPanel)
function BuildUnlockedSingleInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuildUnlockedSingleInfoPanel:ctor", self.viewName)
end
function BuildUnlockedSingleInfoPanel:onInit()
	print("=======BuildUnlockedSingleInfoPanel:onInit")
	self.tableData, _ENV = print, print
	self.spriteIcon = self.fields.Com_army:getChild("Sprite_icon")
	self.spriteWarLv = self.fields.Com_army:getChild("Sprite_warLv")
	self.labelWarLv = self.fields.Com_army:getChild("Text_warLv")
	self.spriteWarLv:setVisible(false)
	self.labelWarLv:setVisible(false)
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function BuildUnlockedSingleInfoPanel:onShow()
	print("=======BuildUnlockedSingleInfoPanel:onShow")
	self:initData(self.param.bid, self.param.unlockedID)
end
function BuildUnlockedSingleInfoPanel:initData(bid, unlockedID)
	self.tableData.bid = tonumber(bid)
	self.tableData.id = unlockedID
	local pointDesRead, spriteName
	local des = ""
	local name = ""
	if self.tableData.bid == BUILDID.CASTLE then
		pointDesRead = include("buildDescribeRead")
	elseif self.tableData.bid == BUILDID.COLLEGE then
		pointDesRead = include("collegeDesRead")
	elseif self.tableData.bid == BUILDID.ELITE_PALACE or self.tableData.bid == BUILDID.STABLES or self.tableData.bid == BUILDID.RANGE or self.tableData.bid == BUILDID.CHARIOT_PLANT or self.tableData.bid == BUILDID.BARRACKS or self.tableData.bid == BUILDID.FORTRESS then
		pointDesRead = include("armyDesRead")
		local warLv = pointDesRead.getWarLv(self.tableData.id)
		self.spriteWarLv:setVisible(0 < warLv)
		self.labelWarLv:setVisible(0 < warLv)
		self.labelWarLv:setString(warLv)
	end
	if pointDesRead then
		spriteName = pointDesRead.getIcon(self.tableData.id)
		des = pointDesRead.getDes(self.tableData.id)
		name = pointDesRead.getName(self.tableData.id)
		if spriteName then
			self.spriteIcon:setURL(spriteName)
			self.fields.Text_name:setString(name)
			self.fields.Text_des:setString(des)
		end
	end
end
return BuildUnlockedSingleInfoPanel
