local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local changeAllianceRankTitleSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeAllianceRankTitleSingle", changeAllianceRankTitleSingle)
function changeAllianceRankTitleSingle:onInit()
	self.fields.TextField_new:setMaxLength(ALLIANCE_CHANGE_RANK_MAX)
	self.fields.TextField_new:addEventListener(fgui.UIEventType.Submit, handler(self, self.OnInputName))
	self.fields.TextField_new:setAlign(SoraDFLabelR())
	self:fixChildrenPos()
end
function changeAllianceRankTitleSingle:onShow()
end
function changeAllianceRankTitleSingle:initData(rank, handle)
	self.rankID = rank
	self.handle = handle
	if self.rankID == gAllianceRank.OFFICIAL then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Image_lv:setSpriteFrame(allianceDesRead.getIcon(self.rankID))
	end
	self:updateOldTitle()
	self.fields.TextField_new:setText("")
	self.fields.TextField_new:setPrompt(fguiHelper.getColorString("#746e65", i18n("common_text_4122")))
	self.fields.Sprite_err:setVisible(false)
end
function changeAllianceRankTitleSingle:updateOldTitle()
	local oldTitle = ""
	local rankKey = "r" .. self.rankID .. "Name"
	if self.rankID == gAllianceRank.OFFICIAL then
		oldTitle = allianceMgr:getAllianceProperty(rankKey) or i18n("alliance_office_title_02")
	else
		oldTitle = allianceMgr:getAllianceProperty(rankKey)
	end
	if string.utf8len(oldTitle) == 0 then
		_ENV = rankKey
		rankKey.rank = self.rankID
		oldTitle = i18n("common_text_205", rankKey)
	end
	self.fields.Text_old:setString(oldTitle)
end
function changeAllianceRankTitleSingle:getRankTitle()
	return self.nowTitle
end
function changeAllianceRankTitleSingle:updateChangeBtnTouchEnable(isCanTouch)
	if self.handle then
		self.handle(self.rankID, isCanTouch)
	end
	self.fields.Sprite_err:setVisible(true)
	if isCanTouch then
		self.nowTitle = self.fields.TextField_new:getText()
		self.fields.Sprite_err:setSpriteFrame("bg_main_task05.png")
	else
		self.nowTitle = nil
		self.fields.Sprite_err:setSpriteFrame("bg_main_task06.png")
	end
end
function changeAllianceRankTitleSingle:OnInputName()
	local str = self.fields.TextField_new:getText()
	local input = string.utf8len(str)
	local regx = "^[؀-ؿa-zـ-ٿA-Zڀ-ڿ0-9ۀ-ۿ ]+$"
	local ret = string.match(str, regx)
	if ret ~= nil and gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(str) then
		ret = nil
	end
	self:updateChangeBtnTouchEnable(input <= ALLIANCE_CHANGE_RANK_MAX and input >= ALLIANCE_CHANGE_RANK_MIN and ret ~= nil)
end
return changeAllianceRankTitleSingle
