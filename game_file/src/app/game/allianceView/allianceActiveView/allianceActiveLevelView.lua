local gametop = gModuleMgr.getObject("gametop")
local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
local allianceActiveLevelView = class("allianceActiveLevelView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceActiveLevelView")
	end
	return target
end)
function allianceActiveLevelView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_text_23"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("alliance_text_24"))
	self.Font_level = SoraDGetChildByName(self, "Font_level")
	self.LoadingBar_bar = SoraDGetChildByName(self, "LoadingBar_bar")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.scroll = SoraDGetChildByName(self, "ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceActiveLevelSingle")
	self:initData()
end
function allianceActiveLevelView:initData()
	local curLv = allianceActiveCtrl:getActiveLevel()
	local curPoint = allianceActiveCtrl:getActivePoint()
	local nextPoint = allianceActiveltCtrl.getActiveLvPoint(curLv + 1)
	self.Font_level:setString(curLv)
	allianceActiveCtrl = nil
	;(nil).member = string.formatnumberthousands(curPoint)
	;(nil).total = string.formatnumberthousands(nextPoint)
	self.Text_percent:setString(i18n("common_text_155", nil))
	self.LoadingBar_bar:setPercent(math.min(100, math.floor(curPoint * 100 / nextPoint)))
	local dataList = allianceActiveltCtrl.getActiveLvInfo()
	allianceActiveCtrl = math.min(100, math.floor(curPoint * 100 / nextPoint))
	math.min(100, math.floor(curPoint * 100 / nextPoint)).scroll = self.scroll
	math.min(100, math.floor(curPoint * 100 / nextPoint)).view = self
	self.scroll:updateScrollView(cc.size(520, 120), dataList, 1, math.min(100, math.floor(curPoint * 100 / nextPoint)))
end
return allianceActiveLevelView
