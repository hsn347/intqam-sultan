local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_praiseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_praiseSingle", Com_praiseSingle)
function Com_praiseSingle:onInit()
	self.fields.name:setAlign(0)
	self.fields.Btn_praise:addClickListener(handler(self, self.onPraise))
end
function Com_praiseSingle:onShow()
end
function Com_praiseSingle:initData(data, rank, mapID, likeStatus)
	self.data = data
	self.rank = rank
	self.mapID = mapID
	self.likeStatus = likeStatus
	self.controllers.c1:setSelectedIndex(rank - 1)
	if data.playerInfo.allianceAbbr then
		self.fields.name:setString(string.format("(%s)%s", data.playerInfo.allianceAbbr, data.playerInfo.nickName))
	else
		self.fields.name:setString(string.format("%s", data.playerInfo.nickName))
	end
	self.fields.praiseNum:setString(data.likeNum)
	self.fields.Btn_praise:setEnabled(not self.likeStatus)
end
function Com_praiseSingle:onPraise()
	SoraDPlaySound()
	self.fields.Btn_praise:setEnabled(false)
	SoraDCreateWaveLabel("+1", self.fields.Btn_praise)
	heroTrialCtrl:like(self.mapID, self.data.uid, self.rank)
end
return Com_praiseSingle
