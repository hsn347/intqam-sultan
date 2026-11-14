local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local epicBattleMailAward = class("epicBattleMailAward", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMailAward")
	end
	return target
end)
function epicBattleMailAward:ctor()
	self.awardArray, _ENV, self.size = cc.size(640, 462), cc.size(640, 462), cc.size(640, 462)
	self.imgbg = SoraDGetChildByName(self, "imgbg")
	self.border = SoraDGetChildByName(self, "border")
	self.Node_hero = SoraDGetChildByName(self, "Node_hero")
	self.Image_line = SoraDGetChildByName(self, "Image_line")
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Text_title = SoraDGetChildByName(self.Image_title, "Text_title")
	self.Text_title:setString(i18n("common_text_094"))
	self.nodeL = SoraDGetChildByName(self, "Node_L")
	SoraDGetChildByName(self.nodeL, "Text_Title"):setString(i18n("lieutenant_text_01"))
	self.nodeL:setVisible(false)
end
function epicBattleMailAward:initData(award, heroInfo)
