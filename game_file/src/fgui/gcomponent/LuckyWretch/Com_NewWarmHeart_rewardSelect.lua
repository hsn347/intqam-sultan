local luckyWretchCtrl = SoraDGetCtrl("luckyWretchCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_NewWarmHeart_rewardSelect = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LuckyWretch/Com_NewWarmHeart_rewardSelect", Com_NewWarmHeart_rewardSelect)
_UPVALUE5_ = fgui.register_extension
fgui.register_extension[1] = 1
fgui.register_extension[2] = 4
fgui.register_extension[3] = 5
fgui.register_extension[4] = 6
local fgui.register_extension[5], boxIndex = 8, fgui.register_extension
function Com_NewWarmHeart_rewardSelect:onInit()
	self.fields.box:addClickEventListener(handler(self, self.onClicked))
end
function Com_NewWarmHeart_rewardSelect:onShow()
end
function Com_NewWarmHeart_rewardSelect:initData(boxInfo, index)
	self.index = index
	local personScore = luckyWretchCtrl:getLottoryTimes()
	self.fields.title:setString(string.formatnumberthousands(boxInfo.donateScore))
	local status = luckyWretchCtrl:getStageStatusByNum(boxInfo.stage, boxInfo.donateScore)
	self.fields.title:setColor(status == gBtnTargetStatusDef.GO and cc.c3b(185, 149, 72) or cc.c3b(255, 223, 45))
	local imgIcon = self.fields.loarder:getContent()
	if not imgIcon then
		imgIcon = SoraDGetCommonBox(boxIndex[index], status, imgIcon)
		self.fields.loarder:setContent(imgIcon)
	else
		SoraDGetCommonBox(boxIndex[index], status, imgIcon)
	end
	if status == gBtnTargetStatusDef.GOT then
		SoraDSetNodeGray(imgIcon, true)
	end
end
function Com_NewWarmHeart_rewardSelect:setClickHandler(callback)
	self.callback = callback
end
function Com_NewWarmHeart_rewardSelect:onClicked()
	if self.callback then
		self.callback(self, self.index)
	end
end
return Com_NewWarmHeart_rewardSelect
