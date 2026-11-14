local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_groupAttr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorTech/Com_groupAttr", Com_groupAttr)
function Com_groupAttr:onInit()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Com_groupAttr:onShow()
end
function Com_groupAttr:initData(data)
	local titleH = 0
	if data.title then
		titleH = 38
		self.fields.Label_title:setTitle(data.title)
		self.fields.Label_title:setVisible(true)
		self.fields.List:setPositionY(38)
	else
		self.fields.Label_title:setVisible(false)
		self.fields.List:setPositionY(0)
	end
	self.ListData = data.attrList
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setHeight(#self.ListData * 40)
	self:setHeight(#self.ListData * 40 + titleH)
end
function Com_groupAttr:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 1)
	obj:getChild("Text_name"):setString(collegeDesRead.getTechBuffDes(data.buffType) or data.buffType)
	local val = data.buffNumType == 1 and data.powerNum / 10 .. "%" or data.powerNum
	collegeDesRead = nil
	;(nil).value = val
	obj:getChild("Text_val"):setString(i18n("common_text_1952", nil))
end
return Com_groupAttr
