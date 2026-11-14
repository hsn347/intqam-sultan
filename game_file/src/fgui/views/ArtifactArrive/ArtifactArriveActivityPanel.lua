local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactArriveCtrl = SoraDGetCtrl("artifactArriveCtrl")
local artifactArriveActivityPanel = class("artifactArriveActivityPanel", basePanel)
function artifactArriveActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function artifactArriveActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtifactArrive"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function artifactArriveActivityPanel:onInit()
	self.fields.com_FrameTitle:initData(i18n("activity_name_9001363"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.text_Time = SoraDCreateTimerLabel(self, self.fields.text_Time)
	self:initActivityTime()
	self.fields.text_Tips:setString(i18n("artifact_befall_text_03"))
	self.fields.btn_Add:addClickListener(handler(self, self.onClickAddItem))
	self.fields.text_Right:setString(include("itemDesRead").getName(artifactArriveCtrl.itemId))
	self.fields.btn_Call:addClickListener(handler(self, self.onClickCallBoss))
	self.fields.btn_Kill:setString(i18n("god_beast_btn_01"))
	self.fields.btn_Kill:addClickListener(handler(self, self.onClickKillBoss))
	self.bossTime = SoraDCreateTimerLabel(self, self.fields.text_BossTime)
	self.bossTime:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		;(nil).time, (nil).color = nil, cc.c3b(255, 46, 0)
		return i18n_html("common_text_2885", nil, nil)
	end)
	self.bossTime:setTimeEndListener(handler(self, self.onShow))
	self:updateNumNode()
	self:updateBtnStatus()
end
function artifactArriveActivityPanel:onShow()
	print("artifactArriveActivityPanel:onShow")
	self.soundId = SoraDPlaySound("sixYear", "amb_artifact")
	SoraDShowLoading()
	artifactArriveCtrl:sendReqInitDataMsg()
end
function artifactArriveActivityPanel:onHide()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
end
function artifactArriveActivityPanel:updateNumNode()
	self.itemNum = backpackCtrl:getItemCount(artifactArriveCtrl.itemId)
	self.fields.text_Left:setString(string.formatnumberthousands(self.itemNum))
	self.fields.btn_Call:setCost(artifactArriveCtrl.itemId, 5)
	self.fields.btn_Call:setString(i18n("common_text_2341"))
	_UPVALUE4_ = i18n("common_text_2341")
	i18n("common_text_2341")[1] = self.fields.btn_Add
	i18n("common_text_2341")[2] = self.fields.text_Left
	i18n("common_text_2341")[3] = self.fields.icon_Item
	i18n("common_text_2341")[4] = self.fields.text_Right
	_UPVALUE3_ = self.fields.text_Left
	self.fields.text_Left[1] = 10
	self.fields.text_Left[2] = 5
	self.fields.text_Left[3] = 5
	SoraDAlignNodeArrayOnCenterX(320, i18n("common_text_2341"))
end
function artifactArriveActivityPanel:updateBtnStatus()
	local bossPos = artifactArriveCtrl:getBossPos()
	if bossPos.x > 0 and 0 < bossPos.y then
		self.controllers.c1:setSelectedIndex(1)
		self.bossTime:beginTime(artifactArriveCtrl:getDisappearTime() - serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.btn_Call:setReddot(artifactArriveCtrl:getReceiveStatusAndNum())
	end
end
function artifactArriveActivityPanel:initActivityTime()
	self.text_Time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_607", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTIFACT_ARRIVE_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.text_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function artifactArriveActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("artifact_befall_text_02")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function artifactArriveActivityPanel:onClickAddItem()
	SoraDPlaySound()
	local sources = include("itemDesRead").getOutput(artifactArriveCtrl.itemId)
	_ENV = nil
	;(nil).sources = sources
	uiManager:show("CommonSourceGuide", nil)
end
function artifactArriveActivityPanel:onClickCallBoss()
	SoraDPlaySound()
	if self.itemNum < 5 then
		_ENV = nil
		;(nil).name = include("itemDesRead").getName(artifactArriveCtrl.itemId)
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
	else
		SoraDShowLoading()
		artifactArriveCtrl:reqArtifactArrivePut()
	end
end
function artifactArriveActivityPanel:onClickKillBoss()
	SoraDPlaySound()
	local bossPos = artifactArriveCtrl:getBossPos()
	if bossPos.x > 0 and 0 < bossPos.y then
		if SoraDGotoWorldMapPoint(bossPos, true) then
			SoraDRemoveAllPanelFromManager()
		end
	else
		SoraDShowMsgTip(i18n("artifact_befall_text_10"))
	end
end
return artifactArriveActivityPanel
