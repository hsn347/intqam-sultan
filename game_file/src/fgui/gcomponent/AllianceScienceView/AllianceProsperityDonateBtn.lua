local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local baseComponent = require("fgui.gcomponent.AllianceScienceView.AllianceScienceBtn")
local AllianceProsperityDonateBtn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/AllianceProsperityDonateBtn", AllianceProsperityDonateBtn)
function AllianceProsperityDonateBtn:onInit()
	self.super.onInit(self)
end
function AllianceProsperityDonateBtn:onShow()
end
function AllianceProsperityDonateBtn:initData()
	self:updateView()
end
function AllianceProsperityDonateBtn:updateView()
	local allianceltCtrl = include("allianceltCtrl")
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = "juniorUse"
		self.tableDonateData.honor.key = "juniorHonor"
		self.tableDonateData.score.key = "juniorHonor"
		self.tableDonateData.spoint.key = "juniorPopularity"
	elseif self.tableDonateData.type == gAScienceDonateType.Middle then
		self.tableDonateData.res.key = "middleUse"
		self.tableDonateData.honor.key = "middleHonor"
		self.tableDonateData.score.key = "middleHonor"
		self.tableDonateData.spoint.key = "middlePopularity"
	elseif self.tableDonateData.type == gAScienceDonateType.Senior then
		self.tableDonateData.res.key = "seniorUse"
		self.tableDonateData.honor.key = "seniorHonor"
		self.tableDonateData.score.key = "seniorHonor"
		self.tableDonateData.spoint.key = "seniorPopularity"
	end
	local member = memberMgr:getOwnMember()
	self.rid = member:getProsperityDonateData(self.tableDonateData.type)
	local donateInfo = allianceltCtrl.getProsperityDonateInfo()
	self.tableDonateData.res.data = donateInfo[self.tableDonateData.res.key]
	self.tableDonateData.honor.data = donateInfo[self.tableDonateData.honor.key]
	self.tableDonateData.score.data = donateInfo[self.tableDonateData.score.key]
	self.tableDonateData.spoint.data = donateInfo[self.tableDonateData.spoint.key]
	self.labelNeed:setColor(display.COLOR_WHITE)
	self.resEnough = false
	if self.rid then
		local resDesRead = include("resDesRead")
		self.tableDonateData.res.data = allianceltCtrl.getProsperityDonateCost(self.tableDonateData.res.data, self.rid)
		self.fields.Button_donate:setIcon(resDesRead.getMIcon(self.rid))
		self:resUpdate()
	end
	self.labelNeed:setString(string.formatnumberthousands(self.tableDonateData.res.data))
	self.fields.Label_point:setString(string.formatnumberthousands(self.tableDonateData.spoint.data))
	self.fields.Label_honor:setString(string.formatnumberthousands(self.tableDonateData.honor.data))
	self.fields.Label_score:setString(string.formatnumberthousands(self.tableDonateData.score.data))
	self:btnStateChange(self.rid ~= nil)
end
return AllianceProsperityDonateBtn
