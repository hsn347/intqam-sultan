local baseComponent = require("fgui.base.baseComponent")
local Com_player = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_player", Com_player)
function Com_player:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_player:onItemRenderer(index, obj)
	obj:initData(self.detail[index + 1])
end
function Com_player:onShow()
end
function Com_player:initData(title, name, detail)
	self.detail = detail
	self.fields.title:setString(title)
	self.fields.Text_name:setString(name)
	self.fields.List:setNumItems(#self.detail)
	self.fields.List:setHeight(#self.detail * 98)
end
return Com_player
