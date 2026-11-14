local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local buffDesRead = include("buffDesRead")
local epicBattleArmyInfoView = class("epicBattleArmyInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleArmyInfoView")
	end
	return target
end)
function epicBattleArmyInfoView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_019"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self:initData()
end
function epicBattleArmyInfoView:initData()
	self.buffList = epicWarCtrl:getBuffInfo()
	self.curArmyList = epicWarCtrl:getCurArmyInfo()
	self.armyList, epicWarCtrl, self.oriArmyList = epicWarCtrl:getOriArmyInfo(), epicWarCtrl:getOriArmyInfo(), epicWarCtrl:getOriArmyInfo()
	local index = 1
	for k, v in pairs(self.oriArmyList) do
		epicWarCtrl = nil
		;(nil).id = tonumber(k)
		;(nil).snum = self.curArmyList[k] or 0
		self.armyList[index], (nil).num = nil, v
		index = index + 1
	end
	table.sort(self.armyList, function(a, b)
		return a.snum > b.snum
	end)
	self:initView()
end
function epicBattleArmyInfoView:initView()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #self.armyList * 100)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	for k, v in ipairs(self.armyList) do
		local single = include("commonArmySingle").new()
		single:setPosition(sSize.width / 2, sH - k * 100)
		single:initData(v)
		single:addTo(self.scroll)
	end
end
return epicBattleArmyInfoView
