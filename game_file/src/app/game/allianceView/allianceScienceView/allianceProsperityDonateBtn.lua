local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceScienceBtn = include("allianceScienceBtn")
local allianceProsperityDonateBtn = class("allianceProsperityDonateBtn", allianceScienceBtn)
function allianceProsperityDonateBtn:ctor()
	allianceProsperityDonateBtn.super.ctor(self)
	self.Sprite_spoint = SoraDGetChildByName(self, "Sprite_spoint")
	self.Sprite_spoint:setSpriteFrame("icon_lmrfd_rqz.png")
	self.Sprite_spoint:setScale(1.0)
end
function allianceProsperityDonateBtn:initData()
	self:updateView()
end
function allianceProsperityDonateBtn:updateView()
	local allianceltCtrl = include("allianceltCtrl")
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = "juniorUse"
		self.tableDonateData.honor.key = "juniorHonor"
		self.tableDonateData.score.key = "juniorHonor"
		self.tableDonateData.spoint.key = "juniorPopularity"
		self.btnDonate:loadTextureNormal("btn_yellow_normal_01.png", ccui.TextureResType.plistType)
		self.btnDonate:loadTexturePressed("", ccui.TextureResType.plistType)
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
		self.spriteIcon:setSpriteFrame(resDesRead.getMIcon(self.rid))
		self:resUpdate()
	end
	self.labelNeed:setString(string.formatnumberthousands(self.tableDonateData.res.data))
	self.labelPoint:setString(string.formatnumberthousands(self.tableDonateData.spoint.data))
	self.labelHonor:setString(string.formatnumberthousands(self.tableDonateData.honor.data))
	self.labelScore:setString(string.formatnumberthousands(self.tableDonateData.score.data))
	self:btnStateChange(self.rid ~= nil)
end
return allianceProsperityDonateBtn
