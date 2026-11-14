local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local heroMailItem = class("heroMailItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroMailItem")
	end
	return target
end)
function heroMailItem:ctor()
	self.LoadingBar_exp = SoraDGetChildByName(self, "LoadingBar_exp")
	self.Sprite_headBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.Sprite_head = SoraDGetChildByName(self, "Sprite_head")
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
	self.Text_addExp = SoraDGetChildByName(self, "Text_addExp")
	self.icon_arrowUp = SoraDGetChildByName(self, "icon_arrowUp")
	if self.icon_arrowUp then
		self.icon_arrowUp:setVisible(false)
	end
end
function heroMailItem:initData(data)
	local exp = data.exp
	local heroID = data.heroID
	local level = data.level
	local quality = data.quality
	local addExp = data.addExp
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	local isAwake = heroInfo.isAwake
	local maxExp = heroltCtrl:getHeroLevelInfo(heroID, level).exp
	self.LoadingBar_exp:setPercent(heroInfo.level_exp / maxExp * 100)
	self.Text_lv:setString(level)
	if not (not (level >= gHeroMaxLevel) or isAwake) or level >= gHeroAwakeMaxLevel or level < gHeroMaxLevel and level >= 3 * SoraDGetLordLv() then
		self.Text_addExp:setString("+0")
	elseif addExp and 0 < addExp then
		heroCtrl = nil
		;(nil).value = string.formatnumberthousands(addExp)
		self.Text_addExp:setString(i18n("common_text_1952", nil))
	end
	self.Sprite_headBg:setSpriteFrame(heroltCtrl.getCubeBg(quality))
	self.Sprite_head:setSpriteFrame(heroltCtrl.getHeroInfo(heroID).herIcon)
	self:setUpVisible(activityShowCtrl:getEpicCommandMultiple() > 1)
end
function heroMailItem:setUpVisible(ret)
	if self.icon_arrowUp then
		self.icon_arrowUp:setVisible(ret)
	end
end
function heroMailItem:getContentSize()
	return cc.size(100, 115)
end
return heroMailItem
