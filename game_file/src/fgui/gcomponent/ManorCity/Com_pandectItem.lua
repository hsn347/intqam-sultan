local baseComponent = require("fgui.base.baseComponent")
local Com_pandectItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/Com_pandectItem", Com_pandectItem)
function Com_pandectItem:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_noData:setString(i18n("fortress_text_19"))
end
function Com_pandectItem:onShow()
end
function Com_pandectItem:itemRenderer_List(index, obj)
	local data = self.data.tableData[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_name:setString(data.title)
	_fields.Text_val:setString(data.value)
	_fields.bg:setVisible(index % 2 ~= 0)
	if not SoraDFIsRA() then
		_fields.Text_name:fixPos()
		_fields.Text_val:fixPos()
	end
end
function Com_pandectItem:initData(data)
	self.data = data
	self.fields.Label_title:setString(data.title)
	_ENV = data.title
	data.title.num = data.power
	local powerStr = i18n("garden_text_52", data.title)
	self.fields.Label_power:setString(powerStr)
	local numItems = #data.tableData
	self.fields.List:setNumItems(numItems)
	self.fields.List:resizeToFit(numItems)
	self.fields.Text_noData:setVisible(numItems == 0)
	if numItems == 0 then
		self.fields.List:setHeight(40)
	end
end
return Com_pandectItem
