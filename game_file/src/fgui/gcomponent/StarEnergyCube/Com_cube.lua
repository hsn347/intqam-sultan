local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local constantRead = include("constantRead")
local starEnergyCubeRead = include("starEnergyCubeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_cube = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_cube", Com_cube)
function Com_cube:onInit()
	self.boxOpenLimitTimes = constantRead.getConstValue("STAR_CUBE_BOX_LIMIT")
	self.fields.Text_tip:setString(i18n("star_cube_08"))
	self:addClickListener(handler(self, self.onClickCube))
end
function Com_cube:initData(index, backFunc)
	self.index = index
	self.fields.icon:setURL(starEnergyCubeRead:getTreasureChestInfo(index).button)
	self.callFunc = backFunc
	local state = 0
	self.config = starEnergyCubeRead:getTreasureChestInfo(self.index)
	local one = backpackCtrl:getItemCount(self.config.core1)
	if 1 <= one then
		state = 2
	end
	self.controllers.c1:setSelectedIndex(state)
	self:setReddot(state, one)
end
function Com_cube:setReddot(state, a)
	if state == 0 or state == 1 then
		self.fields.Label_reddot:setVisible(false)
		return
	end
	local remainOpenTimes = self.boxOpenLimitTimes - starCubeCtrl:getOpenBoxTimes(self.index)
	local num = math.min(a, remainOpenTimes)
	self.fields.Label_reddot:initData(0 < num, num)
end
function Com_cube:onClickCube()
	self.callFunc(self.index)
end
function Com_cube:onShow()
end
return Com_cube
