local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalCardFlash = class("petCarnivalCardFlash", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalCardFlash")
	end
	return target
end)
function petCarnivalCardFlash:ctor()
	self.Node_two_once = SoraDGetChildByName(self, "Node_two_once")
	self.Node_three_once = SoraDGetChildByName(self, "Node_three_once")
	SoraDCreatAnimationEx(self.__cname, self, false)
	self.Node_two_once:setVisible(false)
	self.Node_three_once:setVisible(false)
end
function petCarnivalCardFlash:showFlash(type)
	self.Node_two_once:setVisible(type == 2)
	self.Node_three_once:setVisible(type == 3)
end
function petCarnivalCardFlash:stopAnimal()
	self.Node_two_once:setVisible(false)
	self.Node_three_once:setVisible(false)
end
return petCarnivalCardFlash
