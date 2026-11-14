local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorUtil = include("anchorUtil")
local anchorDef = include("anchorDef")
local anchorBottomView = class("anchorBottomView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("anchorBottomView")
	end
	return target
end)
local gQueueTargetStatusType = anchorDef.gQueueTargetStatusType
function anchorBottomView:ctor()
	self.isHideCurrentSceneView = true
	self.btnSet = SoraDGetChildByName(self, "Button_set")
	self.txtSetName = SoraDGetChildByName(self, "Text_setName")
	self.btnTeam = SoraDGetChildByName(self, "Button_team")
	self.txtTeamName = SoraDGetChildByName(self, "Text_teamName")
	self.btnWar = SoraDGetChildByName(self, "Button_war")
	self.spWar = SoraDGetChildByName(self, "Sprite_war")
	self.txtWarNum = SoraDGetChildByName(self, "Text_war_num")
	self.txtWarName = SoraDGetChildByName(self, "Text_warName")
	self.btnSet:addTouchEventListener(handler(self, self.onClickSet))
	self.btnTeam:addTouchEventListener(handler(self, self.onClickTeam))
	self.btnWar:addTouchEventListener(handler(self, self.onClickWar))
	self.txtSetName:setString(i18n("common_text_713"))
	self.txtTeamName:setString(i18n("Anchor_btn_05"))
	self.txtWarNum:setString(i18n("999"))
	self.txtWarName:setString(i18n("Anchor_btn_04"))
end
function anchorBottomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BUILD_STATUS", handler(self, self.updateStatus))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BATTLE_END", handler(self, self.onRemainsWarEnd))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
end
_UPVALUE2_, anchorBottomView.resetUI = function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end, function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end
;(function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end)[1] = cc.p(34, 34)
;(function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end)[2] = cc.p(5, 5)
;(function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end)[3] = cc.p(64, 64)
;(function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end)[4] = cc.p(64, 64)
local (function(self)
	self.spWar:setVisible(false)
	self.txtWarNum:setString("")
end)[5], BUILD_TABLE = cc.p(64, 64)
function anchorBottomView:updateStatus()
	local num = 0
	for _, v in ipairs(BUILD_TABLE) do
		dump(v, "v", 10)
		local status = remainsWarCtrl:getBuildingStatus(v)
		if status ~= gQueueTargetStatusType.free then
			num = num + 1
		end
	end
	self.spWar:setVisible(0 < num)
	self.txtWarNum:setString(num)
end
function anchorBottomView:onClickSet(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("gameSettingView")
	end
end
function anchorBottomView:onClickTeam(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if anchorUtil.checkSelectWatchMap() then
			local panel = SoraDCreatePanel("anchorTeamInfo")
			panel:initViewWar()
			panel:show()
		end
	end
end
function anchorBottomView:onClickWar(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if anchorUtil.checkSelectWatchMap() then
			local panel = SoraDCreatePanel("anchorMonsterInfo")
			panel:show()
		end
	end
end
function anchorBottomView:onRemainsWarEnd(target, data)
	local resultInfo = data.resultInfo
	if resultInfo then
		if not resultInfo.ruinsWarSettleData then
			local panel = SoraDCreatePanel("remainsWarScoreView")
			panel:show()
			panel:initData(resultInfo)
		else
			local panel = SoraDCreatePanel("remainsWarResultView")
			panel:show()
			panel:initData(data)
		end
	end
end
function anchorBottomView:updateAttackInfo(target, data)
	if not self.remainsWarwAttackWidget then
		local remainsWarwAttackWidget = include("remainsWarAttackWidget").new()
		remainsWarwAttackWidget:setPosition(cc.p(320, display.rheight))
		remainsWarwAttackWidget:addTo(self)
		self.remainsWarwAttackWidget = remainsWarwAttackWidget
		if self.remainsWarwAttackWidget then
			self.remainsWarwAttackWidget:updateAttackInfo(target, data)
		end
	end
end
return anchorBottomView
