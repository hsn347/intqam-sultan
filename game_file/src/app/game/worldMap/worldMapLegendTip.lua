local gametop = gModuleMgr.getObject("gametop")
local legendLordWarCtrl = gametop.playertop_:getModule("legendLordWarCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local teamDef = include("teamDef")
local worldMapLegendTip = class("worldMapLegendTip", function()
	return SoraDCreateBasePanel("worldMapLegendTip")
end)
function worldMapLegendTip:ctor()
	self.txtTime = SoraDGetChildByName(self, "Text_tip")
	self.bg = SoraDGetChildByName(self, "bg")
	self.bg_c = SoraDGetChildByName(self, "bg_c")
	self.bg_c:setOpacity(178.5)
	self.Text_c = SoraDGetChildByName(self, "Text_c")
	self.bg_c:setVisible(false)
	self.Text_c:setVisible(false)
	self.Button_back = SoraDGetChildByName(self, "Button_back")
	self.Button_back:setTitleText(i18n("common_text_4256"))
	self.Button_back:addTouchEventListener(handler(self, self.btnBackClick))
	self.Button_back:setVisible(false)
end
function worldMapLegendTip:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WATCHING_NUM", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.updateTipData))
end
function worldMapLegendTip:onEnterPanel()
	self:updateData()
	if GAME_SYNC_LEGEND_MSG then
		self:setTipData()
	end
end
function worldMapLegendTip:setWatchingNum(num)
	if 0 < num then
		self:setWatchingShow(true)
		local str = string.formatnumberthousands(num)
		_ENV = nil
		;(nil).num = str
		self.txtTime:setString(i18n("legendaryking_text_32", nil))
	else
		self:setWatchingShow(false)
	end
end
function worldMapLegendTip:setWatchingShow(ret)
	self.txtTime:setVisible(ret)
	self.bg:setVisible(ret)
end
function worldMapLegendTip:updateTipData(target, data)
	if data and data.teamType == teamDef.teamAreaEnum.LEGEND_LORD and data.subMsg == "setTip" then
		self:setTipData()
	end
end
function worldMapLegendTip:setTipData()
	GAME_SYNC_LEGEND_MSG = false
	self.bg_c:setVisible(false)
	self.Text_c:setVisible(false)
	self.Button_back:setVisible(false)
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
	if worldMapDefine.isLegendMapId(gametop.playertop_:getMapID()) and param and param.curState == ACTIVITY_STATE.ACTIVE then
		print("isHasTeam=======", legendTeamCtrl:isHasTeam(), gametop.playertop_:getKingdomID())
		if legendTeamCtrl:isTeamCommander() then
			self.bg_c:setVisible(true)
			self.Text_c:setVisible(true)
			self.Text_c:setString(i18n("legendary_commander_text18"))
		elseif not legendTeamCtrl:isHasTeam() then
			self.bg_c:setVisible(true)
			self.Text_c:setVisible(true)
			self.Button_back:setVisible(true)
			self.Text_c:setString(i18n("legendary_commander_text17"))
			local sourceKid = gametop.playertop_:getKingdomID()
			if 0 < sourceKid then
				_ENV = i18n("legendary_commander_text17")
				i18n("legendary_commander_text17").content = i18n("legendary_commander_text23")
				i18n("legendary_commander_text17").confirmString = i18n("common_text_204")
				i18n("legendary_commander_text17").confirmFunc = function()
					SoraDGotoWorldMapPoint(cc.p(600, 600), false, sourceKid)
					SoraDRemoveAllPanelFromManager()
				end
				uiManager:show("MessageBox", i18n("legendary_commander_text17"))
			end
		end
	end
end
function worldMapLegendTip:updateData()
	if worldMapDefine.isPyramidKingdomID() then
		local num = allianceWarCtrl:getWatchingNum()
		self:setWatchingNum(num)
		local setSize = cc.size(380, 35)
		self.bg:setContentSize(setSize)
	elseif legendLordWarCtrl:isInWar() then
		local num = legendLordWarCtrl:getWatchingNum()
		self:setWatchingNum(num)
	else
		self:setWatchingShow(false)
	end
end
function worldMapLegendTip:btnBackClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(cc.p(600, 600), false, gametop.playertop_:getKingdomID())
	SoraDRemoveAllPanelFromManager()
end
return worldMapLegendTip
