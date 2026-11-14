local baseComponent = require("fgui.base.baseComponent")
local magicLampSkillRead = include("magicLampSkillRead")
local Com_exchangeChoose = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_exchangeChoose", Com_exchangeChoose)
function Com_exchangeChoose:onInit()
	self:addClickEventListener(handler(self, self.onClickItem))
end
function Com_exchangeChoose:onShow()
end
function Com_exchangeChoose:initData(data, isSelected)
	self.data = data
	self.fields.Com_exchangeItem:initBySkillData(data)
	self.fields.Check_tick:setSelected(isSelected)
	self.fields.text_name:setString(magicLampSkillRead.getSkillName(data.skillType))
end
function Com_exchangeChoose:setClickEventCallback(callback)
	self.clickEventCallback = callback
end
function Com_exchangeChoose:onClickItem()
	if self.clickEventCallback and self.data then
		self.clickEventCallback(self.data.id)
	end
end
return Com_exchangeChoose
