local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushChapterPanel = class("SoldierRushChapterPanel", baseFguiPanel)
function SoldierRushChapterPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushChapterPanel:ctor", self.viewName)
end
function SoldierRushChapterPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushChapterPanel:onInit()
	print("=======SoldierRushChapterPanel:onInit")
	self.isHideCurrentSceneView = true
	self.showModel = 0
	self.curChapter = 1
	self.recordOffset = nil
	self.fields.Com_title:initData(i18n("soldier_rush_text_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_hook:addClickListener(handler(self, self.onHookClick))
	soldierRushCtrl:sendAFKInit()
end
function SoldierRushChapterPanel:onItemRenderer(index, obj)
	obj:initData(self.chapterList[index + 1])
end
function SoldierRushChapterPanel:onShow()
	print("=======SoldierRushChapterPanel:onShow")
	self.fields.map:showChapterMap()
	self.controllers.c1:setSelectedIndex(self.showModel)
	self.fields.map:setOffsetPos(cc.p(0, 2214 - display.height))
end
function SoldierRushChapterPanel:endShow()
	print("=======SoldierRushChapterPanel:endShow")
	if not soldierRushCtrl:getGateRecord(101) then
		_ENV = soldierRushCtrl
		soldierRushCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		soldierRushCtrl.step = 1000001
		SoraDSendMessage(soldierRushCtrl)
	end
end
function SoldierRushChapterPanel:updateHook()
	if not soldierRushCtrl:getAFKReward() then
		local soldierRushCtrl, hookRewards = soldierRushCtrl:getAFKReward(), soldierRushCtrl:getAFKReward()
	end
	self.fields.Btn_hook:setRed(next(hookRewards) and true or false)
	local svrReceiveTime = soldierRushCtrl:getAFKLastReceiveTime()
	local svrIncomeTime = 300
	if svrReceiveTime then
		svrIncomeTime = serviceFunctions.systemTime() - svrReceiveTime
	end
	self.clientTime = math.min(300, 300 - svrIncomeTime)
	if self.clientTimer then
		SoraDManagerRemoveTimer(self, self.clientTimer)
		self.clientTimer = nil
	end
	if self.clientTime > 0 then
		self.clientTimer = SoradCreateTimer(self, function()
			self.clientTime = self.clientTime - 1
			if self.clientTime <= 0 then
				soldierRushCtrl:sendAFKInit()
				if self.clientTimer then
					SoraDManagerRemoveTimer(self, self.clientTimer)
					self.clientTimer = nil
				end
			end
		end)
	end
end
function SoldierRushChapterPanel:updateMapToGate(target, data)
	self.showModel = 1
	self.controllers.c1:setSelectedIndex(self.showModel)
	self:updateHook()
	if data and data.chapter then
		self.curChapter = data.chapter
	end
	self.fields.map:showGateMap(self.curChapter)
	local chapterObj = self.fields.map:getChapter(self.curChapter)
	local scale = self.fields.map:getZoomScale()
	local objW = chapterObj:getContentSize().width
	local posX = (chapterObj:getX() + objW / 2) * scale - display.cx
	local objH = chapterObj:getContentSize().height
	local posY = (chapterObj:getY() + objH / 2) * scale - display.cy
	local offset = soldierRushRead.getChapterOffset(self.curChapter)
	local displayH = (display.height - 1136) * 0.37
	self.fields.map:setOffsetPos(cc.p(posX + offset.x, posY + offset.y + displayH))
	self.recordOffset = cc.p(chapterObj:getX() + objW / 2 - display.cx, chapterObj:getY() + objH / 2 - display.cy)
	local cfg = soldierRushRead.getChapterCfg(self.curChapter)
	_ENV = cc.p(posX + offset.x, posY + offset.y + displayH)
	cc.p(posX + offset.x, posY + offset.y + displayH).num = self.curChapter
	self.fields.Com_title:updateTitle(i18n("soldier_rush_text_03", cc.p(posX + offset.x, posY + offset.y + displayH)) .. i18n(cfg.Name))
	self.fields.Com_starPro:initData(self.curChapter)
	self.fields.Com_skill:initData()
end
function SoldierRushChapterPanel:guideNext(target, data)
	local levelID = data and data.levelID
	if levelID and levelID < 106 and not soldierRushCtrl:getGateRecord(levelID + 1) then
		soldierRushCtrl = levelID + 1
		;(levelID + 1).gate = levelID + 1
		gModuleMgr.sharedMgr("mildGuideManager"):starToChallengeNext(levelID + 1)
	end
end
function SoldierRushChapterPanel:updateStarBox()
	self.fields.Com_starPro:initData(self.curChapter)
	self.fields.map:setChapterInfo()
end
function SoldierRushChapterPanel:updateSkillSlot()
	self.fields.Com_skill:initData()
end
function SoldierRushChapterPanel:onHookClick()
	SoraDPlaySound()
	if soldierRushCtrl:isHaveRecord() then
		uiManager:show("SoldierRushHook")
	else
		SoraDShowMsgTip(i18n("soldier_rush_text_110"))
	end
end
function SoldierRushChapterPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("soldier_rush_text_02")
	uiManager:show("RuleView", nil)
end
function SoldierRushChapterPanel:onClickClose()
	if self.showModel == 1 then
		self.showModel = 0
		self.fields.map:showChapterMap()
		self.controllers.c1:setSelectedIndex(self.showModel)
		self:updateHook()
		if self.recordOffset then
			self.fields.map:setOffsetPos(self.recordOffset)
			self.recordOffset = nil
		end
		self.fields.Com_title:updateTitle(i18n("soldier_rush_text_01"))
	else
		self:close()
	end
end
function SoldierRushChapterPanel:onHide()
	_ENV = nil
	;(nil).byUID = true
	local isGuide = SoraDConfigGet("Game:SoldierRush:hookGuide~bool", nil)
	local isSvrGuide = SoraDGetCtrl("guideCtrl"):isGuideNotCompleted(gGuideModule.SOLDIER_RUSH_AFK)
	print("isSvrGuide,isGuide=====", isSvrGuide, isGuide)
	if isSvrGuide then
		if isGuide then
			_ENV = isGuide
			isGuide.byUID = true
			SoraDConfigSet("Game:SoldierRush:hookGuide~bool", true, isGuide)
			SoraDGetCtrl("guideCtrl"):CompleteGuideStep(950103)
		elseif soldierRushCtrl:isHaveRecord() then
			SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.SOLDIER_RUSH_AFK)
		end
	end
end
function SoldierRushChapterPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Image_chapter_1" then
		return self.fields.map:getChapter(1)
	elseif itemName == "g1" then
		return self.fields.map:getGate(1, 1)
	elseif itemName == "nextGate" then
		local gate = parameters.gate % 100
		return self.fields.map:getGate(1, gate)
	else
		return self.fields[itemName]
	end
end
return SoldierRushChapterPanel
