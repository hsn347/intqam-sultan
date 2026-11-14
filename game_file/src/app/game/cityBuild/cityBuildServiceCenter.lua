local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildServiceCenter = class("cityBuildServiceCenter", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildServiceCenter:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.ServiceCenter)
	self.bid = cityBuildConstDef.fixedBuildDef.ServiceCenter
end
function cityBuildServiceCenter:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_SERVICECENTER", handler(self, self.updateView))
	self:updateView()
end
function cityBuildServiceCenter:loadView()
	self:loadBaseView()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if cLevel >= CASTLE_LV25_LIMITED then
		_ENV = nil
		_ENV, (nil).name = i18n("common_text_3421"), i18n("common_text_3421")
		i18n("common_text_3421").x = 0
		;(nil).pos, i18n("common_text_3421").y = i18n("common_text_3421"), -75
		SoraDShowNameOnTouchEvent(self, nil)
	else
		_ENV = nil
		_ENV, (nil).name = i18n("common_text_3421"), i18n("common_text_3421")
		i18n("common_text_3421").x = 0
		;(nil).pos, i18n("common_text_3421").y = i18n("common_text_3421"), -40
		SoraDShowNameOnTouchEvent(self, nil)
	end
end
function cityBuildServiceCenter:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildServiceCenter:updateView()
	print("TODO: 客服中心更新--------")
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if cLevel >= CASTLE_LV25_LIMITED then
		self.buildImg:setSpriteFrame("BG_notice.png")
	else
		self.buildImg:setSpriteFrame("gonggaolan.png")
	end
end
return cityBuildServiceCenter
