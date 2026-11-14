local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_status = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_status", Com_status)
function Com_status:onInit()
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_warTime = SoraDCreateTimerLabel(self, self.fields.Text_warTime)
	self.fields.Text_warTime:setTimeEndListener(function()
		self:initData()
	end)
	if worldMapDefine.isInRoaringFlame() then
		self.fields.Button_enter:setString(i18n("common_text_3351"))
	else
		self.fields.Button_enter:setString(i18n("common_text_3318"))
	end
	self.fields.Button_enter:addClickListener(handler(self, self.btnEnterClick))
	self.fields.icon_war:fixPos()
end
function Com_status:onShow()
end
function Com_status:initData()
	local curState = roaringFlameWarCtrl:getCurState()
	self.controllers.c_status:setSelectedIndex(curState - 1)
	if curState == ROARING_FLAME_WAR_STATE.MATCH then
		self.fields.Text_status:setString(i18n("flames_dunes_text4"))
		self.fields.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("flames_dunes_text8", nil)
		end)
		self.fields.Text_time:beginTime(roaringFlameWarCtrl:getStateRemainTime(curState))
	elseif curState == ROARING_FLAME_WAR_STATE.RESULT then
		self.fields.Text_status:setString(i18n("flames_dunes_text5"))
		self.fields.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("flames_dunes_text9", nil)
		end)
		self.fields.Text_time:beginTime(roaringFlameWarCtrl:getStateRemainTime(curState))
	elseif curState == ROARING_FLAME_WAR_STATE.BATTLE then
		local isInWar, time = roaringFlameWarUtil.isInWarState()
		self.fields.icon_war:setSpriteFrame(isInWar and "icon_warreport_attack.png" or "icon_warreport_defense.png")
		self.fields.Text_inWar:setString(isInWar and i18n("flames_dunes_text7") or i18n("flames_dunes_text6"))
		self.fields.Text_warTime:setTimeLast(function(time)
			if isInWar then
				isInWar = nil
				;(nil).time = time
				if i18n("flames_dunes_text10", nil) then
					goto lbl_16
				end
			end
			isInWar = nil
			;(nil).time = time
			::lbl_16::
			return (i18n("flames_dunes_text11", nil))
		end)
		self.fields.Text_warTime:beginTime(time)
	elseif curState == ROARING_FLAME_WAR_STATE.SETTLE then
		self.fields.Text_status:setString(i18n("flames_dunes_text309"))
		self.fields.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("flames_dunes_text326", nil)
		end)
		self.fields.Text_time:beginTime(roaringFlameWarCtrl:getStateRemainTime(curState))
	else
		self.fields.Text_status:setString(i18n("nebula_stage_name_008"))
		self.fields.Text_time:setString("")
	end
end
function Com_status:btnEnterClick()
	SoraDPlaySound()
	if worldMapDefine.isInRoaringFlame() then
		roaringFlameWarUtil.quitBattlefield()
	else
		local dailyRemindManager = include("dailyRemindManager")
		local ctype = dailyRemindManager.REMIND_TYPE.roaringFlame_enter_first
		local eid = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
		if dailyRemindManager.checkNeedRemindOnce(ctype, eid) then
			_ENV = nil
			;(nil).content = i18n("flames_dunes_text294")
			;(nil).confirmString = i18n("common_text_204")
			;(nil).cancelString = i18n("common_text_185")
			;(nil).confirmFunc = function()
				dailyRemindManager.addRemindOnceToManager(ctype, eid)
				dailyRemindManager = nil
				;(nil).handler = function()
					roaringFlameWarCtrl:reqEnterBattlefield()
				end
				uiManager:show("RoaringFlame_Switcher", nil)
			end
			uiManager:show("MessageBox", nil)
		else
			_ENV = nil
			;(nil).handler = function()
				roaringFlameWarCtrl:reqEnterBattlefield()
			end
			uiManager:show("RoaringFlame_Switcher", nil)
		end
	end
end
return Com_status
