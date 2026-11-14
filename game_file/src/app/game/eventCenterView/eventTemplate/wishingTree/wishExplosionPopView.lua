local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local wishingTreeRead = include("wishingTreeRead")
local wishExplosionPopView = class("wishExplosionPopView", function(target)
	if target then
		return target
	end
	return SoraDCreateTouchPanel("wishExplosionPopView")
end)
function wishExplosionPopView:ctor()
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.WISH_TREE_ACTIVITY).classtype or 1
	SoraDGetChildByName(self, "Text_name"):setString(i18n("wish_text_04"))
	self.textInfoTitle = SoraDGetChildByName(self, "Text_TitleInfo")
	self.textInfoTitle:setString(i18n("wish_text_09"))
	self.imageFont = SoraDGetChildByName(self, "image_WishExplosion")
	self.textLvNow = SoraDGetChildByName(self, "Text_LvNow")
	self.texNow = SoraDGetChildByName(self, "Text_Gold_Now")
	self.texNow = SoraDChangeTextToHtml(self.texNow)
	self.texNext = SoraDGetChildByName(self, "Text_Gold_Next")
	self.texNext = SoraDChangeTextToHtml(self.texNext)
	self.textNeed = SoraDGetChildByName(self, "Text_Gold_Need")
	self.textNeed = SoraDChangeTextToHtml(self.textNeed)
	local lang = SoraDGetDefaultLanguage()
	if lang ~= "ar" and lang ~= "en" and lang ~= "ko" then
		lang = "en"
	end
	self.imageFont:setSpriteFrame("fong_wishing_wishbroke_" .. lang .. ".png")
end
function wishExplosionPopView:initData(data)
	self.stage = data.stage
	self.isPrivilege = data.isPrivilege
	self.consumeGold = data.consumeGold
	_ENV = nil
	;(nil).num = self.stage
	self.textLvNow:setString(i18n("wish_text_10", nil))
	_ENV = i18n("wish_text_10", nil)
	i18n("wish_text_10", nil).title = i18n("wish_text_11")
	_ENV, _ENV, i18n("wish_text_10", nil).value = wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).title, wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege).color = wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)
	local strNow = i18n_html("common_text_3904", i18n("wish_text_10", nil))
	_ENV = string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege))
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).param = "#icon_main_gold.png"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).name = "image_Gold"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).width = 40
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).height = 32
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).custom = "Sprite"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege)).offsety = 5
	strNow = strNow .. SoraDWrapReplaceTag((string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage, self.isPrivilege))))
	self.texNow:setString(strNow)
	SoraDGetAutoHeightLabel(self.texNow, 540)
	_ENV = 540
	;(540).title = i18n("wish_text_12")
	_ENV, _ENV, (540).value = wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).title, wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege).color = wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)
	local strNex = i18n_html("common_text_3904", 540, (string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege))))
	_ENV = string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege))
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).param = "#icon_main_gold.png"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).name = "image_Gold"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).width = 40
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).height = 32
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).custom = "Sprite"
	string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege)).offsety = 5
	strNex = strNex .. SoraDWrapReplaceTag((string.formatnumberthousands(wishingTreeRead.getStageCoin(self.group, self.stage + 1, self.isPrivilege))))
	self.texNext:setString(strNex)
	SoraDGetAutoHeightLabel(self.texNext, 540)
	_ENV = 540
	_ENV, _ENV, (540).num = wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold, string.formatnumberthousands(wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold), string.formatnumberthousands(wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold)
	_ENV, string.formatnumberthousands(wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold).num, (wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold).color = wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold, wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold, "#ffffff"
	string.formatnumberthousands(wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold).__default, (wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold).color = wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold, "#f2d8a0"
	local strNeed = i18n_html("wish_text_13", 540, (string.formatnumberthousands(wishingTreeRead.getStageTargetNum(self.group, self.stage + 1) - self.consumeGold)))
	self.textNeed:setString(strNeed)
	self.texNext:setVisible(self.stage ~= 7 and data.sessionType == 0)
	self.textNeed:setVisible(self.stage ~= 7 and data.sessionType == 0)
end
return wishExplosionPopView
