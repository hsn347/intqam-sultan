local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildCastle = class("cityBuildCastle", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildCastle:ctor()
	print("create castle!!")
end
function cityBuildCastle:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_101"), i18n("buildDes_name_101")
	i18n("buildDes_name_101").x = 150
	;(nil).pos, i18n("buildDes_name_101").y = i18n("buildDes_name_101"), -180
	SoraDShowNameOnTouchEvent(self, nil)
	self:checkBuildGuide()
end
function cityBuildCastle:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_CHEAT_BUILD_SUCCESS", handler(self, self.checkBuildGuide))
end
function cityBuildCastle:checkBuildGuide(target, data)
	if data and tonumber(data.bid) ~= BUILDID.CASTLE then
		return
	end
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		if SoraDIsBraveOpen() then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_BRAVESTATUE_VIEW"
			SoraDSendMessage(nil)
			print("==cityBuildCastle:checkBuildGuide==")
		end
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		magicLampCtrl:updateGuideLottery()
	end
	if SoraDGetCastleLv() == 2 then
		SoraDRemoveAllPanelFromManager()
		SoraDShowNoticeApplyView()
	end
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	commandHallCtrl:updateGuide1()
end
return cityBuildCastle
