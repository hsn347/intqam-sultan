local baseComponent = require("fgui.base.baseComponent")
local Com_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlamewarwar/Com_single", Com_single)
function Com_single:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_single:onItemRenderer(index, obj)
	obj:initData(self.lineList[index + 1])
end
function Com_single:onShow()
end
function Com_single:initData(data, index)
	self.fields.Text_title:setString(index == 1 and i18n("atlantiswar_text_0141") or i18n("flames_dunes_text196"))
	self.lineList, _ENV = self.fields.Text_title.setString, self.fields.Text_title.setString
	local lineCount = math.ceil(#data / 3)
	for i = 1, lineCount do
		if not self.lineList[i] then
			self.lineList[i], _ENV = nil, nil
		end
		_ENV = nil
		;(nil)[1] = data[(i - 1) * 3 + 1]
		;(nil)[2] = data[(i - 1) * 3 + 2]
		self.lineList[i], (nil)[3] = nil, data[(i - 1) * 3 + 3]
	end
	self.fields.List:setNumItems(#self.lineList)
	self.fields.List:setHeight(#self.lineList * 36)
	self.fields.bg:setHeight(math.max(217, #self.lineList * 36 + 117))
end
return Com_single
