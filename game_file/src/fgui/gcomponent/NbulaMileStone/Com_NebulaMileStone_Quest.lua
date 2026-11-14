local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaMileStone_Quest = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NbulaMileStone/Com_NebulaMileStone_Quest", Com_NebulaMileStone_Quest)
local nebulaMileStoneRead = include("nebulaMileStoneRead")
function Com_NebulaMileStone_Quest:onInit()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Com_NebulaMileStone_Quest:onShow()
end
function Com_NebulaMileStone_Quest:setData(info, isCurIdx, isLock)
	self.info = info
	self.isCurIdx = isCurIdx
	self.isLock = isLock
	self.taskID = info.taskCfg.milestoneID
	self.fields.lock:setVisible(isLock)
	self.fields.title:setString(nebulaMileStoneRead.getName(self.taskID))
	self.controllers.c1:setSelectedIndex(isCurIdx and 1 or 0)
	if self.info.data == nil or self.info.data.status == "prepare" then
		self.fields.status:setString("")
		self.fields.title:setY(25)
		return
	end
	self.fields.title:setY(15)
	if self.info.data.status == "end" then
		self.fields.status:setString(i18n("Anchor_text_21"))
	else
		self.fields.status:setString(i18n("activity_text_05"))
	end
end
function Com_NebulaMileStone_Quest:setClickHandler(handler, params)
	self.handler = handler
	self.params = params
end
function Com_NebulaMileStone_Quest:onClicked()
	SoraDPlaySound()
	if self.isLock then
		SoraDShowMsgTip(i18n("common_text_699"))
		return
	end
	if self.handler then
		self.handler(self, self.params)
	end
end
return Com_NebulaMileStone_Quest
