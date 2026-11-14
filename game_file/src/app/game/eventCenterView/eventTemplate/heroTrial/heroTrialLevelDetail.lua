local armyDesRead = include("armyDesRead")
local heroTrialLevelDetail = class("heroTrialLevelDetail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("heroTrialLevelDetail")
	end
	return target
end)
function heroTrialLevelDetail:ctor()
	self.scroll = SoraDGetChildByName(self, "scrollView")
	self.lab_armyinfo = SoraDGetChildByName(self, "Text_armyInfo")
	self.lab_armyinfo:setString(i18n("common_text_019"))
	self.lab_guards = SoraDGetChildByName(self, "Text_guards")
	self.lab_guards:setString(i18n("common_text_1864"))
	self.lab_guardsNum = SoraDGetChildByName(self, "Text_guards_num")
	self.itemPanel = SoraDGetChildByName(self, "Panel_single")
end
function heroTrialLevelDetail:initData(enemyData)
	self.armyList = enemyData
	self.total = 0
	local scrollHeight = math.max(self.scroll:getContentSize().height, table.nums(self.armyList) * 100)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollHeight))
	for i, v in ipairs(self.armyList) do
		self.total = self.total + v.num
		local single = self:getSingle()
		single.setInfo(v)
		single:setPosition(cc.p(10, scrollHeight - 100 * i))
		single:addTo(self.scroll)
	end
	self.lab_guardsNum:setString(self.total)
end
function heroTrialLevelDetail:getSingle()
	local single = self.itemPanel:clone()
	function single.setInfo(data)
		local armyIcon = single:getChildByName("soldierIcon")
		local armyLvIcon = single:getChildByName("soldierLevelIcon")
		local armyNum = single:getChildByName("soldierNum")
		armyNum:setString(data.num)
		armyIcon:loadTexture(armyDesRead.getIcon(data.id), ccui.TextureResType.plistType)
		armyLvIcon:loadTexture(armyDesRead.getLvImg(data.id), ccui.TextureResType.plistType)
	end
	return single
end
return heroTrialLevelDetail
