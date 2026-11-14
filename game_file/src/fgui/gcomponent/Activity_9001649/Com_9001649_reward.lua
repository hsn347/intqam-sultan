local baseComponent = require("fgui.base.baseComponent")
local Com_9001649_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001649/Com_9001649_reward", Com_9001649_reward)
function Com_9001649_reward:onInit()
end
function Com_9001649_reward:onShow()
end
function Com_9001649_reward:initData(data, index)
	local selectedIndex = data.mineType == 1 and 0 or 2
	selectedIndex = data.itemorder == 1 and 1 or selectedIndex
	self.controllers.c1:setSelectedIndex(selectedIndex)
	self.fields.item:initData(data.id, data.count)
	_ENV = nil
	;(nil).num = index
	self.fields.txt_title:setString(i18n("petra_text_07", nil))
	self.fields.n1:setAlpha(0)
	self.fields.txt_title:setAlpha(0)
	self.fields.item:setAlpha(0)
	self.fields.n1:runAction(ffa.seq(ffa.delay(index * 0.2 + 0.1), ffa.fadeIn(0.2)))
	self.fields.txt_title:runAction(ffa.seq(ffa.delay(index * 0.2 + 0.1), ffa.callFunc(function()
		self.fields.txt_title:setVisible(true)
	end), ffa.fadeIn(0.2)))
	self.fields.item:runAction(ffa.seq(ffa.delay(index * 0.2 + 0.1), ffa.callFunc(function()
		self.fields.item:setVisible(true)
	end), ffa.fadeIn(0.2)))
	self.fields.ani:runAction(ffa.seq(ffa.delay(index * 0.2), ffa.callFunc(function()
		self.fields.ani:setAllFrameNameOnce("G_dh_9001649_03_%02d.png", 1, false)
	end)))
end
return Com_9001649_reward
