local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameBattlefieldPopPanel = class("RoaringFlameBattlefieldPopPanel", baseFguiPanel)
function RoaringFlameBattlefieldPopPanel:ctor(...)
	self.isLRU = true
	RoaringFlameBattlefieldPopPanel.super.ctor(self, ...)
	print("RoaringFlameBattlefieldPopPanel:ctor", self.viewName)
	self.palaceSubType = gWorldTypeServerDef.subTypeRoaringFlameWarPalace
end
function RoaringFlameBattlefieldPopPanel:onInit()
	print("=======RoaringFlameBattlefieldPopPanel:onInit")
	local imageName = SoraDGetImageNameByLang("frame_9001674_yourfactionmvp_%s.png")
	self.fields.Load_mvp:setURL(imageName)
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function RoaringFlameBattlefieldPopPanel:endShow()
	print("=======RoaringFlameBattlefieldPopPanel:endShow")
	local notifyData = self.param.notifyData
	local campId = notifyData.campId
	if campId == roaringFlameWarCtrl:getSelfCamp() then
		self.controllers.c1:setSelectedIndex(0)
		local imageName = SoraDGetImageNameByLang("frame_9001674_succeedinoccupation_%s.png")
		self.fields.Load_title:setURL(imageName)
	else
		self.controllers.c1:setSelectedIndex(1)
		local imageName = SoraDGetImageNameByLang("frame_9001674_defeatofoccupation_%s.png")
		self.fields.Load_title:setURL(imageName)
	end
	local maxPlayerInfo = notifyData.maxPlayerInfo
	if maxPlayerInfo then
		self.fields.Com_head:setHeadSprite(maxPlayerInfo.iconID, maxPlayerInfo.avatar)
		self.fields.Text_player:setString(maxPlayerInfo.name)
		local maxKillScore = string.formatnumberthousands(maxPlayerInfo.maxKillScore)
		_ENV = nil
		;(nil).num = maxKillScore
		self.fields.Text_score:setString(i18n("flames_dunes_text190", nil))
	end
	local soldierSum = string.formatnumberthousands(notifyData.soldierSum)
	_ENV = i18n("flames_dunes_text190", nil)
	i18n("flames_dunes_text190", nil).color = "#FFFBD5"
	local soldierSum = SoraDWrapHtmlTagByStyle(soldierSum, i18n("flames_dunes_text190", nil))
	_ENV = i18n("flames_dunes_text190", nil)
	i18n("flames_dunes_text190", nil).num = soldierSum
	self.fields.Text_army:setString(i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil)))
	local battleNum = string.formatnumberthousands(notifyData.battleNum)
	_ENV = i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil))
	i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil)).color = "#FFFBD5"
	local battleNum = SoraDWrapHtmlTagByStyle(battleNum, i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil)))
	_ENV = i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil))
	i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil)).num = battleNum
	self.fields.Text_fight:setString(i18n("flames_dunes_text200", i18n("flames_dunes_text201", i18n("flames_dunes_text190", nil))))
end
function RoaringFlameBattlefieldPopPanel:initCheatData(...)
	_UPVALUE0_ = nil
	;(nil).soldierSum = 100
	;(nil).battleNum = 101
	_UPVALUE0_, (nil).campId = nil, 1
	;(nil).maxKillScore = 102
	;(nil).name = "name"
	;(nil).iconID = 1401
	_UPVALUE0_, (nil).maxPlayerInfo, (nil).avatar = nil, nil, ""
	local notifyData
	self.param, (nil).notifyData = nil, notifyData
end
function RoaringFlameBattlefieldPopPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local jumpPos = roaringFlameWarRead.getBuildCoordBySubType(self.palaceSubType)
	SoraDGotoWorldMapPoint(jumpPos, true)
	self:removeFromParent()
end
return RoaringFlameBattlefieldPopPanel
