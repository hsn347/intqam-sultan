local nebulaExplorationCtrl = SoraDGetCtrl("nebulaExplorationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaTreasureA/Com_Box", Com_Box)
function Com_Box:onInit()
	self:addClickListener(handler(self, self.onClickBox))
end
function Com_Box:onShow()
end
function Com_Box:initData(data)
	self.level = data.level
	self.awardConfig = data.tierRewards
	self:setString(data.level)
	self.chooseIndex = nebulaExplorationCtrl:checkIsGotGift(self.level)
	print("self.chooseIndex")
	if self.chooseIndex then
		self.controllers.c1:setSelectedIndex(2)
	elseif nebulaExplorationCtrl:getCurLevel() >= self.level then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_Box:onClickBox()
	if self.awardConfig == nil then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).chooseIndex = self.chooseIndex
	;(nil).index = self.controllers.c1:getSelectedIndex()
	;(nil).level = self.level
	;(nil).awardConfig = self.awardConfig
	uiManager:show("NebulaTreasurePop", nil)
end
return Com_Box
