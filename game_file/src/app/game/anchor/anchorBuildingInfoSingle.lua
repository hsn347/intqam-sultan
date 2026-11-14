local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local anchorBuildingInfoSingle = class("anchorBuildingInfoSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anchorBuildingInfoSingle")
	end
	local timerClass = include("anchorMonsterInfoBase")
	target = timerClass.new(target)
	return target
end)
function anchorBuildingInfoSingle:ctor()
	self.nodeOccupy = SoraDGetChildByName(self, "Node_occupy")
	self.nodeOccupy:setVisible(false)
	self.txtOccupyName = SoraDGetChildByName(self, "Text_occupy_name")
end
function anchorBuildingInfoSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.reqForStateInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initBuildings))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.initBuildings))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BUILD_STATUS", handler(self, self.updateStatus))
end
function anchorBuildingInfoSingle:reqForStateInfo(target, data)
	if data then
		self.myPlaceInfo = data.retdata
		dump(self.myPlaceInfo, "self.myPlaceInfo===========")
		self:updateOccupy()
	end
end
function anchorBuildingInfoSingle:resetUI()
	self.nodeStatusBg:setVisible(false)
	self.nodeAttack:setVisible(false)
	self.nodeHelp:setVisible(false)
end
function anchorBuildingInfoSingle:initView(pos)
	self.uPos = pos
	self.uStatusPos = cc.p(pos.x + 1, pos.y + 1)
	self:initData()
	self:initBuildings()
end
function anchorBuildingInfoSingle:initBuildings()
	if self.uPos then
		kingdomMapCtrl:getPlaceOwnerInfo(self.uPos.x, self.uPos.y)
	end
end
function anchorBuildingInfoSingle:initData()
	self:updateStatus()
end
function anchorBuildingInfoSingle:updateOccupy()
	local occupyUsrData = self.myPlaceInfo
	dump(occupyUsrData, "占领者")
	local name
	if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
		name = occupyUsrData.name
		local allianceAbbr = occupyUsrData.abbr
		if allianceAbbr ~= nil and 0 < string.len(allianceAbbr) then
			_ENV = nil
			;(nil).abbr = allianceAbbr
			;(nil).name = name
			name = i18n("common_text_186", nil)
		end
		if occupyUsrData.fromKid then
			name = name .. "#" .. tostring(occupyUsrData.fromKid)
		end
	else
		name = i18n("common_text_480")
	end
	self.nodeOccupy:setVisible(true)
	_ENV = occupyUsrData.fromKid
	occupyUsrData.fromKid.name = name
	self.txtOccupyName:setString(i18n("Anchor_text_12", occupyUsrData.fromKid))
end
return anchorBuildingInfoSingle
