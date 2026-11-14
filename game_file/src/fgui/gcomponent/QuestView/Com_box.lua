local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://QuestView/Com_box", Com_box)
function Com_box:onInit()
	self.fields.btn_icon:addClickListener(handler(self, self.OnClick))
end
function Com_box:onShow()
end
function Com_box:initWithData(data)
	self.data = data
	local curGoal = everydayTaskCtrl:calCurPoint()
	self.fields.Text_score:setString(data.score)
	local status = 0
	if curGoal >= data.score then
		if everydayTaskCtrl:isReceiveChestReward(self.data.index) then
			status = 2
		else
			status = 1
		end
	else
		status = 0
	end
	self.controllers.c1:setSelectedIndex(status)
end
function Com_box:OnClick()
	SoraDPlaySound()
	local curGoal = everydayTaskCtrl:calCurPoint()
	if curGoal < self.data.score then
		_ENV = nil
		;(nil).score = self.data.score
		local str = i18n("common_text_2721", nil)
		SoraDShowMsgTip(str)
		return
	end
	if everydayTaskCtrl:isReceiveChestReward(self.data.index) then
		SoraDShowMsgTip(i18n("common_text_2701"))
	else
		print("打开宝箱奖励刷新界面")
		_ENV = i18n("common_text_2701")
		i18n("common_text_2701").data = self.data
		uiManager:show("dailyAwardTreasureDetail", i18n("common_text_2701"))
	end
end
return Com_box
