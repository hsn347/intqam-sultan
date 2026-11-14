local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local djTopic = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/djTopic", djTopic)
function djTopic:onInit()
end
function djTopic:onShow()
end
function djTopic:initData(djUid)
	self.djInfo = djCtrl:getDJInfo(djUid)
	dump(self.djInfo, "self.djInfo===", 10)
	if not djCtrl:getRoomSetData() then
		local djCtrl, roomSetData = djCtrl:getRoomSetData(), djCtrl:getRoomSetData()
	end
	local djTitle = self.djInfo.title or roomSetData.title or ""
	local djDes = self.djInfo.topic or roomSetData.topic or ""
	if djTitle ~= "" and djDes ~= "" then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_title:setString(djTitle)
		self.fields.Text_des:setString(djDes)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return djTopic
