local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseComponent = require("fgui.base.baseComponent")
local nebulaAllStarUIBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/nebulaAllStarUIBottom", nebulaAllStarUIBottom)
function nebulaAllStarUIBottom:onInit()
	print("==nebulaAllStarUIBottom:onInit==")
	_UPVALUE2_, _UPVALUE14_ = "==nebulaAllStarUIBottom:onInit==", print
	;("==nebulaAllStarUIBottom:onInit==").icon = "frame_qmx_fszq.png"
	_UPVALUE2_, ("==nebulaAllStarUIBottom:onInit==")[1] = self.fields.Button_hospital, self.fields.Button_hospital
	_UPVALUE2_, ("==nebulaAllStarUIBottom:onInit==")[2] = self.fields.Button_hospital, i18n("NebulaAllstar_145")
	self.fields.Button_hospital.icon = "frame_qmx_mingxingzhi.png"
	_UPVALUE2_, self.fields.Button_hospital[1] = self.fields.Button_star, self.fields.Button_star
	_UPVALUE2_, self.fields.Button_hospital[2] = self.fields.Button_star, i18n("NebulaAllstar_165")
	self.fields.Button_star.icon = "frame_qmx_zuwei.png"
	_UPVALUE2_, self.fields.Button_star[1] = self.fields.Button_backup, self.fields.Button_backup
	_UPVALUE2_, self.fields.Button_star[2] = self.fields.Button_backup, i18n("NebulaAllstar_181")
	self.fields.Button_backup.icon = "frame_qmx_gaota.png"
	_UPVALUE2_, self.fields.Button_backup[1] = self.fields.Button_tower, self.fields.Button_tower
	_UPVALUE2_, self.fields.Button_backup[2] = self.fields.Button_tower, i18n("NebulaAllstar_03")
	self.fields.Button_tower.icon = "frame_qmx_juntuan.png"
	_UPVALUE2_, self.fields.Button_tower[1] = self.fields.Button_war, self.fields.Button_war
	_UPVALUE2_, self.fields.Button_tower[2] = self.fields.Button_war, i18n("nebulaemperor_text_50")
	self.fields.Button_war.icon = "frame_qmx_lp.png"
	_UPVALUE2_, self.fields.Button_war[1] = self.fields.Button_gift, self.fields.Button_gift
	_UPVALUE2_, self.fields.Button_war[2] = self.fields.Button_gift, i18n("NebulaAllstar_167")
	self.fields.Button_gift.icon = "frame_qmx_phb.png"
	_UPVALUE2_, self.fields.Button_gift[1] = self.fields.Button_rank, self.fields.Button_rank
	_UPVALUE2_, self.fields.Button_gift[2] = self.fields.Button_rank, i18n("common_text_851")
	self.fields.Button_rank.icon = "frame_qmx_jiangli.png"
	_UPVALUE2_, self.fields.Button_rank[1] = self.fields.Button_reward, self.fields.Button_reward
	_UPVALUE2_, self.fields.Button_rank[2] = self.fields.Button_reward, i18n("common_text_2078")
	self.fields.Button_reward.icon = "frame_qmx_guanli.png"
	_UPVALUE2_, self.fields.Button_reward[1] = self.fields.Button_commander, self.fields.Button_commander
	_UPVALUE2_, self.fields.Button_reward[2] = self.fields.Button_commander, i18n("NebulaAllstar_62")
	self.fields.Button_commander.icon = "frame_qmx_shuoming.png"
	_UPVALUE2_, self.fields.Button_commander[1] = self.fields.Button_explain, self.fields.Button_explain
	_UPVALUE2_, self.fields.Button_commander[2] = self.fields.Button_explain, i18n("common_text_1173")
	self.fields.Button_explain.icon = "frame_qmx_tuichu.png"
	_UPVALUE2_, self.fields.Button_explain[1] = self.fields.Button_quit, self.fields.Button_quit
	_UPVALUE2_, self.fields.Button_explain[2] = self.fields.Button_quit, i18n("common_text_3351")
	self.fields.Button_quit.icon = "frame_qmx_shangcheng.png"
	_UPVALUE2_, self.fields.Button_quit[1] = self.fields.Button_quiz, self.fields.Button_quiz
	_UPVALUE2_, self.fields.Button_quit[2] = self.fields.Button_quiz, i18n("NebulaAllstar_213")
	self.fields.Button_quiz.icon = "frame_qmx_phb.png"
	_UPVALUE2_, self.fields.Button_quiz[1] = self.fields.Button_rank2, self.fields.Button_rank2
	_UPVALUE2_, self.fields.Button_quiz[2] = self.fields.Button_rank2, i18n("common_text_851")
	self.fields.Button_rank2.icon = "frame_qmx_shezhi.png"
	self.fields.Button_rank2[1] = self.fields.Button_barrage
	self.fields.Button_rank2[2] = i18n("NebulaAllstar_195")
	print[1] = "==nebulaAllStarUIBottom:onInit=="
	print[2] = self.fields.Button_hospital
	print[3] = self.fields.Button_star
	print[4] = self.fields.Button_backup
	print[5] = self.fields.Button_tower
	print[6] = self.fields.Button_war
	print[7] = self.fields.Button_gift
	print[8] = self.fields.Button_rank
	print[9] = self.fields.Button_reward
	print[10] = self.fields.Button_commander
	print[11] = self.fields.Button_explain
	print[12] = self.fields.Button_quit
	print[13] = self.fields.Button_quiz
	local print[14], config = self.fields.Button_rank2, print
	for __, cfg in ipairs(config) do
		local widget, title = cfg[1], cfg[2]
		if title then
			widget:setString(title)
		end
		if cfg.icon then
			widget:setIcon(cfg.icon)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.controllers.c2:fix()
	end
end
function nebulaAllStarUIBottom:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_WARDATA", handler(self, self.onMsgUpdateWarData))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.setBtnWarRed))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.setBtnWarRed))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_EXCHANGE_BACK", handler(self, self.setBtnQuizRed))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_CURE_ARMY", handler(self, self.setBtnHospitalRed))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_ROB_VALUE", handler(self, self.setBtnRobValueRed))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_ROB_TASK", handler(self, self.setBtnRobValueRed))
end
function nebulaAllStarUIBottom:onShow()
	print("==nebulaAllStarUIBottom:onShow==")
end
function nebulaAllStarUIBottom:initData(...)
	if nebulaAllStarCtrl:getIsViewer() then
		self.controllers.c2:setSelectedIndex(0)
		self:setBtnQuizRed()
	else
		if nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam() then
			self.controllers.c2:setSelectedIndex(1)
		else
			self.controllers.c2:setSelectedIndex(2)
		end
		self:setBtnWarRed()
		self:setBtnHospitalRed()
	end
end
function nebulaAllStarUIBottom:onMsgUpdateData(...)
	self:setBtnHospitalRed()
end
function nebulaAllStarUIBottom:onMsgUpdateWarData(...)
	self:setBtnRobValueRed()
end
function nebulaAllStarUIBottom:setBtnWarRed(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local allianceCount = kingdomMapCtrl:getHallWarCount()
	self.fields.Button_war:setReddot(0 < allianceCount, allianceCount)
end
function nebulaAllStarUIBottom:setBtnQuizRed(...)
	local ret, num = nebulaAllStarCtrl:getQuizShopStatusAndNum()
	self.fields.Button_quiz:setReddot(ret, num)
end
function nebulaAllStarUIBottom:setBtnHospitalRed(...)
	local woundedArmy = nebulaAllStarCtrl:getWoundedArmy()
	self.fields.Button_hospital:setReddot(0 < woundedArmy)
end
function nebulaAllStarUIBottom:setBtnRobValueRed(...)
	local ret = nebulaAllStarCtrl:getRobValueStatusAndNum()
	if nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam() then
		self.fields.Button_star:setReddot(ret)
	else
		self.fields.Button_backup:setReddot(ret)
	end
end
function nebulaAllStarUIBottom:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_hospital then
		uiManager:show("NebulaAllStarHospital")
	elseif sender == self.fields.Button_star then
		uiManager:show("NebulaAllStarValue")
	elseif sender == self.fields.Button_backup then
		uiManager:show("NebulaAllStarValue")
	elseif sender == self.fields.Button_tower then
		_ENV = nil
		;(nil).activityID = gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY
		uiManager:show("NebulaEmperorEnergy", nil)
	elseif sender == self.fields.Button_war then
		uiManager:show("AllianceWarView")
	elseif sender == self.fields.Button_gift then
		uiManager:show("NebulaAllStarReceiveGiftRecord")
	elseif sender == self.fields.Button_rank or sender == self.fields.Button_rank2 then
		nebulaAllStarUtil.openRankView()
	elseif sender == self.fields.Button_reward then
		uiManager:show("NebulaAllStarReward")
	elseif sender == self.fields.Button_commander then
		uiManager:show("NebulaAllStarTeamCommander")
	elseif sender == self.fields.Button_explain then
		nebulaAllStarUtil.showSingleFAQ("nebulaAllStarUIBottom")
	elseif sender == self.fields.Button_quit then
		uiManager:show("NebulaAllStarQuitRoom")
	elseif sender == self.fields.Button_quiz then
		nebulaAllStarUtil.openGuessView()
	elseif sender == self.fields.Button_barrage then
		uiManager:show("NebulaAllStarBarrageSetting")
	end
end
return nebulaAllStarUIBottom
