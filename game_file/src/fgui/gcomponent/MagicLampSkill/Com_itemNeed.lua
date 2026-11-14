local publicRead = include("publicRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemNeed = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_itemNeed", Com_itemNeed)
function Com_itemNeed:onInit()
	self.fields.Button_add:addClickListener(handler(self, self.onClickBtnAdd))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_itemNeed:onShow()
end
function Com_itemNeed:initNeedData(needItem, itemType)
	self.itemType = itemType
	if needItem then
		self:setVisible(true)
		self.needItem = needItem
		local itemID = self.needItem.id
		local itemCount = magicLampSkillCtrl:getItemCount(itemID)
		magicLampSkillCtrl = magicLampSkillCtrl
		magicLampSkillCtrl.member = string.formatnumberthousands(itemCount)
		local magicLampSkillCtrl.total, _data = string.formatnumberthousands(self.needItem.count), magicLampSkillCtrl
		local countStr = i18n("common_text_155", _data)
		if itemCount < self.needItem.count then
			magicLampSkillCtrl, magicLampSkillCtrl = nil, nil
			;(nil).member, (nil).color = nil, "#FF0000"
			countStr = i18n_html("common_text_155", _data, nil)
		end
		self:setString(countStr)
		self:setIcon(publicRead.getIcon(itemID))
	else
		self:setVisible(false)
	end
end
function Com_itemNeed:onClickBtnAdd(...)
	SoraDPlaySound()
	if not self.needItem then
		return
	end
	_ENV = nil
	;(nil).itemID = self.needItem.id
	uiManager:show("CommonSourceGuide", nil)
end
return Com_itemNeed
