local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildHallOfWar = class("cityBuildHallOfWar", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildHallOfWar:ctor()
end
function cityBuildHallOfWar:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_122"), i18n("buildDes_name_122")
	i18n("buildDes_name_122").x = 0
	;(nil).pos, i18n("buildDes_name_122").y = i18n("buildDes_name_122"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildHallOfWar:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HALLOFWAR_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE", handler(self, self.sMsgUpdateBuildCanUpgrade))
	SoraDAddMessage(self, "MESSAGE_CHEAT_BUILD_SUCCESS", handler(self, self.checkBuildGuide))
end
function cityBuildHallOfWar:sMsgUpdateBuildCanUpgrade(target, data)
	self:udpateIsCanUpGrade()
end
function cityBuildHallOfWar:msgUpdateView(target, data)
	local buildState = self:getBuildState()
	if buildState == BUILD_STATE.BUILDING then
		return
	end
	self:updateView()
end
function cityBuildHallOfWar:updateView()
	if self:getIsFighting() then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		SoraDSendMessage(self)
	else
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		SoraDSendMessage(self)
	end
	self:checkBuildGuide()
end
function cityBuildHallOfWar:checkBuildGuide(target, data)
	if data and tonumber(data.bid) ~= BUILDID.HALL_OF_WAR then
		return
	end
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		if SoraDIsMilitaryFOpen() and guideCtrl:updateGuideModule(gGuideModule.MILITARY_FORTESS, true) then
			print("触发军机要塞引导")
		end
	end
end
function cityBuildHallOfWar:getIsFighting()
	local cityBuildData = include("cityBuildData")
	return cityBuildData:getIsFighting()
end
return cityBuildHallOfWar
