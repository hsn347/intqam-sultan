local magicLampSkillRead = include("magicLampSkillRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_MLSH_skill = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_MLSH_skill", Com_MLSH_skill)
function Com_MLSH_skill:onInit()
	if not SoraDFIsRA() then
		self.fields.Load_item:fixPos()
		self.fields.Bar_item:fixPos()
		self.fields.Bar_item:fixChildrenPos()
	end
end
function Com_MLSH_skill:onShow()
end
function Com_MLSH_skill:initData(data)
	if data.skillType then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_skill:initByType(data.skillType)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.title:setTitle(data.title)
		self.fields.title:setIcon(data.bg)
	end
end
function Com_MLSH_skill:initHandbookData(data)
	self:initData(data)
	if data.skillType then
		self.fields.Com_skill:setHandbookView()
		local needItems = magicLampSkillRead.getSkillCompound(data.skillType)
		self.needItem = needItems[1]
		self.fields.Bar_item:setMax(self.needItem.count)
		self.fields.Load_item:setURL(publicRead.getIcon(self.needItem.id))
		self:updateItemCount()
	end
end
function Com_MLSH_skill:getComSkill(...)
	return self.fields.Com_skill
end
function Com_MLSH_skill:afterMerge(...)
	self.fields.Com_skill:updateGetState(true)
	self:updateItemCount()
end
function Com_MLSH_skill:updateItemCount(...)
	local total = backpackCtrl:getItemCount(self.needItem.id)
	self.fields.Bar_item:setValue(total)
	if total >= self.needItem.count then
		self.fields.Com_skill:setReddot(true)
	else
		self.fields.Com_skill:setReddot(false)
	end
end
return Com_MLSH_skill
