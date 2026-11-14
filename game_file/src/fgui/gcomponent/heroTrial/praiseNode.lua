local heroTrialltCtrl = include("heroTrialltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local praiseNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/praiseNode", praiseNode)
function praiseNode:onInit()
	self.isOpen = false
	self.rankingData, _ENV, self.isActing = nil, nil, false
	self.fields.fastPassTitle:setString(i18n("common_text_1722"))
	self.fields.praiseTip:setString(i18n("common_text_1723"))
	self.fields.Button_help:addClickListener(handler(self, self.onBtnHelpClick))
	self.fields.praiseBtn:addClickListener(handler(self, self.onBtnSwitchClick))
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
	self.fitWidth = math.max(640, 1136 / display.height * 640)
	self:setPositionX(self.fitWidth - 55)
	self.fields.praiseBtn:getController("c1"):setSelectedIndex(0)
end
function praiseNode:onShow()
end
function praiseNode:onRankRenderer(index, obj)
	obj:initData(self.rankingData[index + 1], index + 1, self.mapID, self.likeStatus)
end
function praiseNode:initData(likeStatus, rankingData, mapID)
