local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceMemberView/Com_rankInfoSingle", Com_rankInfoSingle)
function Com_rankInfoSingle:onInit()
	self:fixChildrenPos()
end
function Com_rankInfoSingle:onShow()
end
function Com_rankInfoSingle:initData(data, index, isEdit)
	self.data = data
	self.fields.bg:setVisible(index % 2 == 1)
	local desTitle = allianceDesRead.getPermissionDes(self.data.key)
	self.fields.title:setString(desTitle)
	local realW = self.fields.title:getTextAreaWidth()
	local isHH = string.find(desTitle, "\n")
	local height = (236 < realW or isHH ~= nil) and 80 or 40
	self:setHeight(height)
	self.fields.title:setHeight(height)
	for i = 1, 6 do
		self.fields["n" .. i]:initData(self.data.key, i, self.data.data[i], isEdit)
		self.fields["n" .. i]:setHeight(height)
	end
end
return Com_rankInfoSingle
