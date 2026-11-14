local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local ramadanWorldExplorerCtrl = SoraDGetCtrl("ramadanWorldExplorerCtrl")
local baseComponent = require("fgui.base.baseComponent")
local P_Reward_Box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanWorldExplorer/P_Reward_Box", P_Reward_Box)
function P_Reward_Box:onInit()
	self.fields.btn_box:addClickListener(handler(self, self.onClickButton))
end
_UPVALUE3_, P_Reward_Box.onShow = function(self)
end, function(self)
end
;(function(self)
end)[1] = 1
;(function(self)
end)[2] = 2
local (function(self)
end)[3], index2PngIndex = 4, function(self)
end
function P_Reward_Box:initData(index)
	self.index = index
	self.statue = gBtnTargetStatusDef.GO
	local info = ramadanWorldExplorerRead.getProgressInfoByIndex(index)
	index2PngIndex = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(info.reward, nil)
	self.fields.box_txt:setString(string.formatnumberthousands(info.plan))
	self.fields.Icon:setURL(string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index]))
	local isGot = ramadanWorldExplorerCtrl:isBoxRewardGot(index)
	self.fields.sp_r:setVisible(isGot)
	if ramadanWorldExplorerCtrl:getFinishTaskNum() >= info.plan then
		self.statue = gBtnTargetStatusDef.GET
	end
	if isGot then
		self.statue = gBtnTargetStatusDef.GOT
	end
	self.fields.s_l:setVisible(self.statue == gBtnTargetStatusDef.GET)
	if self.fields.s_l:isVisible() then
		self.fields.s_l:stopAllActions()
		self.fields.s_l:setRotation(0)
		_ENV = string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index])
		string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index])[1] = ffa.rotateBy(2.25, 360)
		string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index])[2] = ffa.rotateBy(2.25, 360)
		string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index])[3] = ffa.rotateBy(2.25, 360)
		self.fields.s_l:runAction(ffa.repeatForever(ffa.seq(string.format("icon_KingGroupbuy_lv%d_small.png", index2PngIndex[index]))))
	end
end
function P_Reward_Box:onClickButton()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).rewards = self.rewards
	;(nil).statue = self.statue
	uiManager:show("RamadanWorldExplorerGetAward", nil)
end
return P_Reward_Box
