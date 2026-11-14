local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_detailTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/Com_detailTop", Com_detailTop)
function Com_detailTop:onInit()
	self:fixChildrenPos()
end
function Com_detailTop:onShow()
end
function Com_detailTop:initData(techID, techType, tableSingleData, tableSingleDetails)
	collegeDesRead = nil
	;(nil).technologyID = techID
	self.fields.Com_Single:initData(nil, nil, true)
	local isToMax = tableSingleData.currentLevel >= tableSingleData.maxLevel
	local addFighting = collegeDesRead.getFight(techID, tableSingleData.currentLevel + 1) - collegeDesRead.getFight(techID, tableSingleData.currentLevel)
	if addFighting ~= 0 and not isToMax then
		collegeDesRead = nil
		;(nil).power = string.format("+%s", addFighting)
		self.fields.Text_addPower:setString(i18n("common_text_128", nil))
	else
		self.fields.Text_addPower:setString("")
	end
	self.fields.Text_name:setString(collegeDesRead.getDes(techID))
	local isSpecial = collegeDesRead.isSpecialShow(techID)
	if isSpecial then
		local showLv = math.min(tableSingleData.currentLevel + 1, tableSingleData.maxLevel)
		local spCfg = collegeDesRead.getSpecialDes(techID, showLv)
		if isToMax then
			self.fields.Text_curLv:setString(string.format("%s%s", i18n("common_text_279"), i18n(spCfg.next)))
			self.fields.Text_nextLv:setString("")
		else
			self.fields.Text_curLv:setString(string.format("%s%s", i18n("common_text_279"), i18n(spCfg.current)))
			self.fields.Text_nextLv:setString(string.format("%s%s", i18n("common_text_280"), i18n(spCfg.next)))
		end
	else
		self.fields.Text_curLv:setString(string.format("%s%s", i18n("common_text_279"), tableSingleDetails.currentLevelEffect))
		if isToMax then
			self.fields.Text_nextLv:setString("")
		else
			self.fields.Text_nextLv:setString(string.format("%s%s", i18n("common_text_280"), tableSingleDetails.nextLevelEffect))
		end
	end
end
return Com_detailTop
