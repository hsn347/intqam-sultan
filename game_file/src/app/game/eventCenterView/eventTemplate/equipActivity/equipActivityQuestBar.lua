local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityQuestBar = class("equipActivityQuestBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityQuestBar")
	end
	return target
end)
function equipActivityQuestBar:ctor()
	SoraDCreatAnimation("equipActivityQuestBar", self)
	self.percent = 100
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setSwallowTouches(false)
	self.Panel_cut:setContentSize(cc.size(280, 25))
	self.LoadingBar_bar = SoraDGetChildByName(self, "LoadingBar_bar")
	self.Sprite_bar = SoraDGetChildByName(self, "Sprite_bar")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
end
function equipActivityQuestBar:setPercent(percent, cur, total)
	self.percent = percent
	self.Panel_cut:setContentSize(cc.size(280 * percent / 100, 25))
	self.LoadingBar_bar:setPercent(percent)
	self.Sprite_bar:setPositionX(SoraDFPosX(140 - 280 * percent / 100, 0))
	_ENV = SoraDFPosX(140 - 280 * percent / 100, 0)
	SoraDFPosX(140 - 280 * percent / 100, 0).member = cur
	SoraDFPosX(140 - 280 * percent / 100, 0).total = total
	self.Text_percent:setString(i18n("common_text_155", SoraDFPosX(140 - 280 * percent / 100, 0)))
end
function equipActivityQuestBar:getPercent()
	return self.percent
end
return equipActivityQuestBar
