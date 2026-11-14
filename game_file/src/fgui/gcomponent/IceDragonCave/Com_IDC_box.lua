local baseComponent = require("fgui.base.baseComponent")
local Com_IDC_box = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://IceDragonCave/Com_IDC_box", Com_IDC_box)
local iceDragonCaveCtrl = SoraDGetCtrl("iceDragonCaveCtrl")
_UPVALUE7_ = "iceDragonCaveCtrl"
;("iceDragonCaveCtrl")[1] = 1
;("iceDragonCaveCtrl")[2] = 4
;("iceDragonCaveCtrl")[3] = 5
;("iceDragonCaveCtrl")[4] = 6
;("iceDragonCaveCtrl")[5] = 8
;("iceDragonCaveCtrl")[6] = 8
local ("iceDragonCaveCtrl")[7], boxIndex = 8, "iceDragonCaveCtrl"
function Com_IDC_box:onInit()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Com_IDC_box:onShow()
end
function Com_IDC_box:initData(boxInfo, index)
	self.index = index
	local boxScore = iceDragonCaveCtrl:getDrawCount()
	self.fields.title:setString(string.formatnumberthousands(boxInfo.draw))
	local getStatus = iceDragonCaveCtrl:getIsReceived(boxInfo.draw)
	local imgIcon = self.fields.loader:getContent()
	if not imgIcon then
		imgIcon = SoraDGetCommonBox(boxIndex[index], getStatus, imgIcon)
		self.fields.loader:setContent(imgIcon)
	else
		SoraDGetCommonBox(boxIndex[index], getStatus, imgIcon)
	end
	if gBtnTargetStatusDef.GOT == getStatus then
		SoraDSetNodeGray(imgIcon, true)
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(getStatus == gBtnTargetStatusDef.GET and 1 or 0)
	end
end
function Com_IDC_box:setClickHandler(callback)
	self.callback = callback
end
function Com_IDC_box:onClicked()
	if self.callback then
		self.callback(self, self.index)
	end
end
return Com_IDC_box
