local baseComponent = require("fgui.base.baseComponent")
local CaveExploreRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CaveExploreActivity/CaveExploreRewardSingle", CaveExploreRewardSingle)
function CaveExploreRewardSingle:onInit()
	self.fields.show:setAllFrameName("YDTS_glowkuang_%02d.png", 1)
	self.fields.show:setBlendFunc(gl.ONE, gl.ONE)
end
function CaveExploreRewardSingle:onShow()
end
function CaveExploreRewardSingle:initData(reward, index)
	self:setVisible(false)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.2 + index * 0.1)
	;(nil)[2] = ffa.callFunc(function()
		self:setVisible(true)
		SoraDPlaySound("sixYear", "ui_award_icon")
		self.fields.show:setPlaySettings(0, -1, 1)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:setVisible(true)
		SoraDPlaySound("sixYear", "ui_award_icon")
		self.fields.show:setPlaySettings(0, -1, 1)
	end)
	self:runAction(ffa.seq(nil))
	self.fields.txt_title:setString(reward.round)
	self.fields.item:initData(reward.id, reward.count)
end
return CaveExploreRewardSingle
