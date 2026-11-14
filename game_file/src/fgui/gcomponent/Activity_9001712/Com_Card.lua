local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Card = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001712/Com_Card", Com_Card)
function Com_Card:onInit()
end
function Com_Card:onShow()
end
function Com_Card:initData(index, title)
	self.index = index
	self.controllers.ctrlType:setSelectedIndex(index - 1)
	self.controllers.ctrlOpen:setSelectedIndex(0)
	self.fields.title:setString(title)
	self.fields.effect1:setAllFrameName("dh_Xingyunqyxz_%02d.png", 1)
	self.fields.effect2:setAllFrameName("G_ygg_daji2_%02d.png", 1)
	if not IsArClient then
		self.fields.icon:setURL(string.format("frame_9001712_rosjj%d.png", index))
	end
end
function Com_Card:PlayScratchAni(itemId, callback)
	print("Com_Card:PlayScratchAni 播刮奖放动效")
	self.fields.itemLoader:setURL(publicRead.getIcon(itemId))
	self.controllers.ctrlOpen:setSelectedIndex(1)
end
function Com_Card:getIndex()
	return self.index
end
function Com_Card:setSelected(isSelected)
	self.fields._tempSelectEffect:setVisible(isSelected)
	self.fields.effect1:setVisible(isSelected)
	self.fields.effect2:setVisible(isSelected)
end
return Com_Card
