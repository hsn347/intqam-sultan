local baseComponent = require("fgui.base.baseComponent")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local Com_tab = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/Com_tab", Com_tab)
fgui.register_extension("ui://bagView/Com_tab2", Com_tab)
function Com_tab:onInit()
	_ENV, _ENV, self.isFixTabWith = nil, nil, true
	;(nil).title = i18n("common_text_635")
	_ENV, (nil)[0], (nil).tag = nil, nil, gItemClassifyType.ALL
	;(nil).title = i18n("common_text_123")
	_ENV, (nil)[1], (nil).tag = nil, nil, gItemClassifyType.RESOURCE
	;(nil).title = i18n("common_text_310")
	_ENV, (nil)[2], (nil).tag = nil, nil, gItemClassifyType.WAR
	;(nil).title = i18n("common_text_311")
	_ENV, (nil)[3], (nil).tag = nil, nil, gItemClassifyType.BUFF
	;(nil).title = i18n("common_text_312")
	self.textCfg, (nil)[4], (nil).tag = nil, nil, gItemClassifyType.OTHER
	self.fields.List:setItemRenderer(handler(self, self.onItemRenerer))
	self:updateTabList(true)
end
function Com_tab:onShow()
end
function Com_tab:updateTabList(isInit)
	local isDirty = false
	local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
	local itemsList = backpack:getClassifyList(gItemClassifyType.NEBULA)
	if 0 < #itemsList and self.textCfg[5] == nil then
		backpackCtrl = gItemClassifyType.NEBULA
		gItemClassifyType.NEBULA.title = i18n("backpack_tab_nebula_01")
		self.textCfg[5], gItemClassifyType.NEBULA.tag = gItemClassifyType.NEBULA, gItemClassifyType.NEBULA
		isDirty = true
	end
	if isDirty or isInit then
		self.fields.List:setNumItems(table.nums(self.textCfg))
	end
end
function Com_tab:setFixTabWith(isFixTabWith)
	self.isFixTabWith = isFixTabWith
	print("Com_tab:onItemRenerer", self.isFixTabWith)
end
function Com_tab:getTagByIndex(index)
	return self.textCfg[index].tag
end
function Com_tab:updateTab(tag)
	local size = #self.fields.List:getChildren()
	local index = 0
	for i = 0, size - 1 do
		local button = self.fields.List:getChildAt(i)
		button:setSelected(tag)
		if button:getTag() == tag then
			index = i
		end
	end
	if 1 < size then
		self.fields.List:scrollToView(index)
	end
end
function Com_tab:updateNew()
	local size = #self.fields.List:getChildren()
	for i = 0, size - 1 do
		local button = self.fields.List:getChildAt(i)
		button:setNew()
	end
end
function Com_tab:onItemRenerer(index, obj)
	obj:setTag(index)
	obj:setClassType(self.textCfg[index].tag)
	print("Com_tab:onItemRenerer", index, self.isFixTabWith)
	if self.isFixTabWith then
		obj:setWidth(640 / table.nums(self.textCfg))
	end
	obj:setString(self.textCfg[index].title)
	obj:fixPos()
	obj:setTabClickCallback(handler(self, self.onTabClick))
end
function Com_tab:setTabClickCallback(callback)
	self.tabClickCallback = callback
end
function Com_tab:onTabClick(tag)
	if self.tabClickCallback then
		self.tabClickCallback(tag)
	end
end
return Com_tab
