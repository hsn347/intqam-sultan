local baseComponent = require("fgui.base.baseComponent")
local Com_MC_illusionSingle1 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MythicalCreatures/Com_MC_illusionSingle1", Com_MC_illusionSingle1)
function Com_MC_illusionSingle1:onInit()
	self.fields.title1:setString(i18n("Divine_beast_mark_text_85"))
	self.fields.title2:setString(i18n("common_text_2697"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_btns:setItemRenderer(handler(self, self.onItemRenderer2))
end
function Com_MC_illusionSingle1:onShow()
end
function Com_MC_illusionSingle1:initData(rareMarkCfgs, selectedType)
	self.rareMarkCfgs = rareMarkCfgs
	self.selectedType = selectedType
	self.fields.list:setNumItems(#self.rareMarkCfgs)
	self.fields.list:setHeight(math.ceil(#self.rareMarkCfgs / 2) * 166)
	self.fields.List_btns:setNumItems(5)
end
function Com_MC_illusionSingle1:onItemRenderer(index, obj)
	if obj.mark == nil then
		obj:addClickEventListener(handler(self, self.onClickEvent))
	end
	local mark = self.rareMarkCfgs[index + 1]
	obj.mark = mark
	obj:setTitle(i18n(mark.name))
	obj:setIcon(mark.icon)
end
function Com_MC_illusionSingle1:onItemRenderer2(index, obj)
	fguiHelper.get_controllers(obj).c1:setSelectedIndex(index)
	if index == 0 then
		fguiHelper.get_fields(obj).Text_all:setString(i18n("common_text_635"))
	end
	obj:setSelected(index == self.selectedType)
	if obj.clickHandler == nil then
		obj:setTag(index)
		obj.clickHandler = true
		obj:addClickEventListener(handler(self, self.onBtnSelected))
	end
end
function Com_MC_illusionSingle1:onClickEvent(sender)
	SoraDPlaySound()
	_ENV = nil
	;(nil).markCfg = sender.mark
	uiManager:show("DivineBeastMarkIllusionDetail", nil)
end
function Com_MC_illusionSingle1:setTypeSelectedCallback(callback)
	self.selectedCallback = callback
end
function Com_MC_illusionSingle1:onBtnSelected(sender)
	local tag = sender:getTag()
	if tag == self.selectedType then
		return
	end
	if self.selectedCallback then
		self.selectedCallback(tag)
	end
end
return Com_MC_illusionSingle1
