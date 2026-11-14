local publicRead = include("publicRead")
local HeroRansomBoard = class("heroRansomBoard", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroRansomBoard")
	end
	return target
end)
function HeroRansomBoard:ctor()
	self.nodeRes = SoraDGetChildByName(self, "Node_res")
	SoraDGetChildByName(self, "Text_ransomTip"):setString(i18n("prison_text_10"))
end
function HeroRansomBoard:initData(resTbl)
	self.resTbl = resTbl
	self:initView()
end
function HeroRansomBoard:initView(...)
	if self.resTbl and next(self.resTbl) then
		self:setVisible(true)
		self.nodeRes:getChildByName("Sprite_res"):setSpriteFrame(publicRead.getSmallIcon(self.resTbl.id))
		self.nodeRes:getChildByName("Text_resNum"):setString(string.formatnumberthousands(self.resTbl.num))
	else
		self:setVisible(false)
	end
end
return HeroRansomBoard
