local baseComponent = require("fgui.base.baseComponent")
local Com_fbkr_rewardSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://FootballKingRoad/Com_fbkr_rewardSelect", Com_fbkr_rewardSelect)
local footballKingCtrl = SoraDGetCtrl("footballKingCtrl")
_UPVALUE5_ = "footballKingCtrl"
;("footballKingCtrl")[1] = 1
;("footballKingCtrl")[2] = 4
;("footballKingCtrl")[3] = 5
;("footballKingCtrl")[4] = 6
local ("footballKingCtrl")[5], boxIndex = 8, "footballKingCtrl"
function Com_fbkr_rewardSelect:onInit()
	self:addClickEventListener(handler(self, self.onClicked))
end
function Com_fbkr_rewardSelect:onShow()
end
function Com_fbkr_rewardSelect:initData(boxInfo, index)
	self.index = index
	local boxScore = footballKingCtrl:getBoxRewardNum()
	self.fields.title:setString(string.formatnumberthousands(boxInfo.num))
	self.fields.title:setColor(boxScore < boxInfo.num and cc.c3b(185, 149, 72) or cc.c3b(255, 223, 45))
	local getStatus = footballKingCtrl:getBoxRewardDataStatus(boxInfo.num)
	local imgIcon = self.fields.loarder:getContent()
	if not imgIcon then
		imgIcon = SoraDGetCommonBox(boxIndex[index], getStatus, imgIcon)
		self.fields.loarder:setContent(imgIcon)
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
function Com_fbkr_rewardSelect:setClickHandler(callback)
	self.callback = callback
end
function Com_fbkr_rewardSelect:onClicked()
	if self.callback then
		self.callback(self, self.index)
	end
end
return Com_fbkr_rewardSelect
