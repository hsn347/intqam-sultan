local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorSearchBase = class("anchorSearchBase", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anchorSearchBase")
	end
	if target ~= nil then
		local timerClass = include("teamInfoScore")
		target = timerClass.new(target, true)
	end
	return target
end)
function anchorSearchBase:ctor()
	self.labProtect = SoraDGetChildByName(self, "Text_protect")
	self.labProtectTime = SoraDGetChildByName(self, "Text_protect_time")
	self.labProtectTime = SoraDCreateTimerLabel(self, self.labProtectTime)
	self.imgProtectTimeBg = SoraDGetChildByName(self, "Image_protect_bg")
	self.imgProtectTimeBg:setVisible(false)
end
function anchorSearchBase:initData(data, otherData)
	self:updateAnchorData(data)
end
function anchorSearchBase:updateAnchorData(data)
	self:initViewAnchor(data)
	self:updateTimeView()
end
function anchorSearchBase:updateWarData()
	local data = remainsWarCtrl:getRemainsWarData()
	self:updateData(data)
	self:updateTimeView()
end
function anchorSearchBase:initInfoData(isAnchor, data)
	if isAnchor then
		self:updateAnchorData(data)
	else
		self:initViewWar()
	end
end
function anchorSearchBase:getStatusTime()
	local data = self.data
	if data.warStatus == gKingdomWarStatusType.inWar then
		local sysTime = serviceFunctions.systemTime()
		local endTime = data.warStartTime + data.warTotalTime
		if sysTime < endTime then
			return endTime - sysTime
		end
	elseif data.warStatus == gKingdomWarStatusType.close then
		local sysTime = serviceFunctions.systemTime()
		if sysTime < data.warStartTime then
			return data.warStartTime - sysTime
		end
	end
	return 0
end
function anchorSearchBase:updateTimeView()
	local isOpen = self.data.warStatus ~= gKingdomWarStatusType.rule
	if isOpen then
		self.imgProtectTimeBg:setVisible(true)
		local isInWar = self.data.warStatus == gKingdomWarStatusType.inWar
		local warTime = self:getStatusTime()
		if 0 < warTime then
			self.labProtectTime:beginTime(warTime)
		end
		if isInWar then
			self.labProtect:setString(i18n("common_text_1214"))
		else
			self.labProtect:setString(i18n("common_text_1213"))
		end
	else
		self.imgProtectTimeBg:setVisible(false)
	end
end
return anchorSearchBase
