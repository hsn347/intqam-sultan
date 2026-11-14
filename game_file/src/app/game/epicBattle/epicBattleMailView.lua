local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleMailView = class("epicBattleMailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMailView")
	end
	return target
end)
function epicBattleMailView:ctor()
	self.mailData, _ENV = nil, nil
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.Image_chapter = SoraDGetChildByName(self, "Image_chapter")
	self.Text_chapter = SoraDGetChildByName(self, "Text_chapter")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_chapter")
end
function epicBattleMailView:initData(data)
	self.mailData = data
	self.windowTitle:setTitle(self.mailData.win and i18n("common_text_152") or i18n("common_text_153"))
	local chapterID = epicWarCtrl:getCurChapter()
	local stageID = epicWarCtrl:getCurGateID()
	self.Image_chapter:loadTexture(epicWarltCtrl.getChapterBg(chapterID), ccui.TextureResType.plistType)
	_ENV = nil
	;(nil).firstnum = chapterID
	;(nil).nextnum = epicWarltCtrl.getStageIndex(stageID)
	self.Text_chapter:setString(i18n("epicbattle_text_05", nil) .. "  " .. epicWarltCtrl.getStageName(stageID))
	local panelDetail = SoraDCreatePanel("epicBattleMailDetail")
	panelDetail:initData(self.mailData.battleReport, self.mailData.bossID, self.mailData.heroInfo)
	local dHeight = panelDetail:getContentSize().height
	local aHeight = 0
	local panelAward
	if self.mailData.win then
		panelAward = SoraDCreatePanel("epicBattleMailAward")
		panelAward:initData(self.mailData.reward, self.mailData.heroInfo)
		aHeight = panelAward:getContentSize().height
	end
	local scrollInnerNewH = math.max(aHeight + dHeight, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollInnerNewH))
	if panelAward then
		panelAward:setPosition(0, scrollInnerNewH - aHeight)
		panelAward:addTo(self.scroll)
	end
	panelDetail:setPosition(0, scrollInnerNewH - aHeight - dHeight)
	panelDetail:addTo(self.scroll)
end
return epicBattleMailView
