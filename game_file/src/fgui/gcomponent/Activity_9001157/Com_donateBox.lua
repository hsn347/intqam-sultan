local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = SoraDGetCtrl("outStandingsCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_donateBox = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001157/Com_donateBox", Com_donateBox)
function Com_donateBox:onInit()
	self:addClickListener(handler(self, self.onClickItemm))
end
function Com_donateBox:onShow()
end
function Com_donateBox:initData()
end
function Com_donateBox:initData(data, basicTag, index, classType)
	self.data = data
	self.index = basicTag
	self.classType = classType
	dump(self.data, "self.data")
	local curPower = outStandingsCtrl:getPowerByType(classType)
	local isReceive = outStandingsCtrl:judgeReceiveRewardsByIndex(basicTag + outStandingsRead.getTypeCount(outStandingsCtrl:getBasicType()))
	if isReceive then
		self.controllers.c1:setSelectedIndex(2)
	elseif data <= curPower then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.title:setString(string.formatnumberthousands(data))
	self.fields.icon:setURL(string.format("icon_KingGroupbuy_lv%d_small_new.png", 8 < index and 8 or index))
end
function Com_donateBox:onClickItemm()
	SoraDPlaySound()
	local basicType = outStandingsCtrl:getBasicType()
	local index = self.index + outStandingsRead.getTypeCount(basicType)
	print("index", index)
	local rewardList = outStandingsRead.getBasicRewardsByIndex(index, basicType, self.classType)
	_ENV = nil
	;(nil).rewardList = rewardList
	;(nil).index = index
	;(nil).classType = self.classType
	uiManager:show("Activity_9001157_Reward", nil)
end
return Com_donateBox
