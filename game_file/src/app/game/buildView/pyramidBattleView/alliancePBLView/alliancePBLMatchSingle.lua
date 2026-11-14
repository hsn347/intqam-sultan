local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLMatchSingle = class("alliancePBLMatchSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLMatchSingle")
	end
	return target
end)
function alliancePBLMatchSingle:ctor()
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.nodeOwn = SoraDGetChildByName(self, "Node_own")
	self.nodeOwn:setVisible(false)
	self.nodeFlag:setScale(0.25)
end
function alliancePBLMatchSingle:setData(legionId, index)
	self.nodeOwn:setVisible(false)
	self.legionId = legionId
	self.labelName:setColor(cc.c3b(195, 172, 132))
	if self.legionId then
		self.labelName:setPositionY(-30)
		local data = pyramidWarCtrl.top16GroupInfo[tostring(self.legionId)]
		if data then
			allianceDesRead.getFlagWithParticle(data.flag, self.nodeFlag)
			self.nodeFlag:setVisible(true)
			_ENV = cc.c3b(195, 172, 132)
			cc.c3b(195, 172, 132).abbr = data.abbr
			cc.c3b(195, 172, 132).name = data.legionName
			self.labelName:setString(i18n("common_text_186", cc.c3b(195, 172, 132)) .. [[

#]] .. data.kid)
			local ownLegion = pyramidWarCtrl:getOwnLegion()
			if ownLegion and ownLegion.legionId == self.legionId then
				self.nodeOwn:setVisible(true)
				self.labelName:setColor(cc.c3b(255, 253, 60))
			end
		end
	else
		self.labelName:setPositionY(0)
		self.labelName:setString(index)
		self.nodeFlag:setVisible(false)
	end
end
return alliancePBLMatchSingle
