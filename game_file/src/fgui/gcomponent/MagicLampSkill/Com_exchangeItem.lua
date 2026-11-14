local baseComponent = require("fgui.base.baseComponent")
local Com_exchangeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_exchangeItem", Com_exchangeItem)
function Com_exchangeItem:onInit()
	self.fields.btn_reduce:addClickEventListener(handler(self, self.onClickReduce))
	self.fields.btn_add:addClickEventListener(handler(self, self.onClickItem))
end
function Com_exchangeItem:onShow()
end
function Com_exchangeItem:initData(skillId, quality, index, exData)
	if skillId == nil then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_skill:initDataById(skillId)
		self.fields.btn_reduce:setVisible(true)
	end
	self.skill = skillId
	self.quality = quality
	self.index = index
	self.exData = exData
end
function Com_exchangeItem:initBySkillData(skillData)
	self.fields.Com_skill:initData(skillData)
	self.controllers.c1:setSelectedIndex(1)
	self:setTouchEnabled(false)
	self.fields.btn_reduce:setVisible(false)
end
function Com_exchangeItem:setChangeCallback(callback)
	self.changeCallback = callback
end
function Com_exchangeItem:onClickReduce()
	SoraDPlaySound()
	self.skill = nil
	self.controllers.c1:setSelectedIndex(0)
	if self.changeCallback then
		self.changeCallback(self.index, self.skill)
	end
end
function Com_exchangeItem:onClickItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).quality = self.quality
	;(nil).exData = self.exData
	;(nil).callback = handler(self, self.onChangeCallback)
	uiManager:show("MagicLampSkillExchangeChoose", nil)
end
function Com_exchangeItem:onChangeCallback(skillId)
	self.skill = skillId
	self.fields.Com_skill:initDataById(skillId)
	self.controllers.c1:setSelectedIndex(1)
	if self.changeCallback then
		self.changeCallback(self.index, self.skill)
	end
end
return Com_exchangeItem
