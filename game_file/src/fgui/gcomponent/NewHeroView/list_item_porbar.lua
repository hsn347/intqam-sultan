local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local list_item_porbar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/list_item_porbar", list_item_porbar)
function list_item_porbar:onInit()
	self.fields.movie_bj:setAllFrameName("dh_lingwubj_%.3d.png", 1)
	self.fields.Text_MAX:setString("MAX")
	self.fields.icon_select:setVisible(false)
	self:addClickListener(handler(self, self.onClick))
	self:fixChildrenPos()
	self:initEffectSet()
end
function list_item_porbar:onShow()
end
function list_item_porbar:onClick()
	if IsArClient then
		return
	end
	SoraDPlaySound()
	if self.controllers.c2:getSelectedIndex() == 1 then
		_ENV = self.controllers.c2
		self.controllers.c2.msg = "MESSAGE_SERVER_HERO_AWAKE_SKILL_CLICK"
		self.controllers.c2.skillID = self.skillID
		SoraDSendMessage(self.controllers.c2)
	end
end
function list_item_porbar:initEffectSet()
	self.fields.movie_bj:setVisible(false)
	self.fields.n1:stopAllActions()
	self.fields.n1:setAlpha(0)
	self.fields.n2:stopAllActions()
	self.fields.n2:setAlpha(0)
	self.fields.n3:stopAllActions()
	self.fields.n3:setAlpha(0)
	self.fields.n4:stopAllActions()
	self.fields.n4:setAlpha(0)
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_1:stopSystem()
	self.fields.Particle_2:setVisible(false)
	self.fields.Particle_2:stopSystem()
end
function list_item_porbar:showEffect(isCrit)
	self:initEffectSet()
	if isCrit then
		self.fields.movie_bj:setVisible(true)
		self.fields.movie_bj:setPlaySettings(0, -1, 1, -1, function()
			self.fields.movie_bj:setVisible(false)
		end)
	end
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.fadeTo(0.25, 1)
	;(-1)[2] = ffa.fadeTo(0.3333333333333333, 0)
	;(-1)[3] = ffa.fadeTo(0.3333333333333333, 0)
	;(-1)[4] = ffa.fadeTo(0.3333333333333333, 0)
	;(-1)[5] = ffa.fadeTo(0.3333333333333333, 0)
	;(-1)[6] = ffa.fadeTo(0.3333333333333333, 0)
	self.fields.n1:runAction(ffa.seq(-1))
	_UPVALUE1_ = ffa.seq(-1)
	ffa.seq(-1)[1] = ffa.fadeTo(0.16666666666666666, 1)
	ffa.seq(-1)[2] = ffa.fadeTo(0.3333333333333333, 0)
	ffa.seq(-1)[3] = ffa.fadeTo(0.3333333333333333, 0)
	ffa.seq(-1)[4] = ffa.fadeTo(0.3333333333333333, 0)
	ffa.seq(-1)[5] = ffa.fadeTo(0.3333333333333333, 0)
	ffa.seq(-1)[6] = ffa.fadeTo(0.3333333333333333, 0)
	self.fields.n2:runAction(ffa.seq(ffa.seq(-1)))
	_UPVALUE2_ = ffa.seq(ffa.seq(-1))
	ffa.seq(ffa.seq(-1))[1] = ffa.fadeTo(0.08333333333333333, 0.42)
	ffa.seq(ffa.seq(-1))[2] = ffa.fadeTo(0.3333333333333333, 0.08)
	ffa.seq(ffa.seq(-1))[3] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(-1))[4] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(-1))[5] = ffa.fadeTo(0.08333333333333333, 0)
	ffa.seq(ffa.seq(-1))[6] = ffa.fadeTo(0.08333333333333333, 0)
	self.fields.n3:runAction(ffa.seq(ffa.seq(ffa.seq(-1))))
	_UPVALUE3_ = ffa.seq(ffa.seq(ffa.seq(-1)))
	ffa.seq(ffa.seq(ffa.seq(-1)))[1] = ffa.fadeTo(0.08333333333333333, 0.07)
	ffa.seq(ffa.seq(ffa.seq(-1)))[2] = ffa.fadeTo(0.16666666666666666, 0.21)
	ffa.seq(ffa.seq(ffa.seq(-1)))[3] = ffa.fadeTo(0.08333333333333333, 0.32)
	ffa.seq(ffa.seq(ffa.seq(-1)))[4] = ffa.fadeTo(0.25, 0)
	ffa.seq(ffa.seq(ffa.seq(-1)))[5] = ffa.fadeTo(0.25, 0)
	ffa.seq(ffa.seq(ffa.seq(-1)))[6] = ffa.fadeTo(0.25, 0)
	self.fields.n4:runAction(ffa.seq(ffa.seq(ffa.seq(ffa.seq(-1)))))
	self.fields.Particle_1:setVisible(true)
	self.fields.Particle_1:resetSystem()
	self.fields.Particle_2:setVisible(true)
	self.fields.Particle_2:resetSystem()
end
function list_item_porbar:initData(heroID, data, skillBack, isAllMax)
	self.heroID = heroID
	local isAllUp = data.isAllUp
	local isSelect = data.isSelect or false
	local isAllMax = isAllMax
	self.skillID = data.skillID
	local isMax = data.buffValue >= heroltCtrl:getMaxBuffValue(data.skillID)
	data.buffValue = math.min(data.buffValue, heroltCtrl:getMaxBuffValue(data.skillID))
	self.fields.Text_MAX:setVisible(isMax)
	if not IsArClient and data.isActive and data.buffValue <= 0 and data.skillID % 10 ~= 1 then
		heroltCtrl = isMax
		isMax.byUID = true
		local actData = SoraDConfigGet("Game:heroUskillStudySingle:finishStunt~table", isMax)
		if actData[tostring(data.skillID % 10)] == nil then
			actData[tostring(data.skillID % 10)] = true
			heroltCtrl = heroltCtrl:getMaxBuffValue(data.skillID)
			heroltCtrl:getMaxBuffValue(data.skillID).byUID = true
			SoraDConfigSet("Game:heroUskillStudySingle:finishStunt~table", actData, heroltCtrl:getMaxBuffValue(data.skillID))
		end
	end
	self.fields.icon_select:setVisible(not IsArClient and data.isActive and not isMax and isSelect)
	self.controllers.c2:setSelectedIndex(not (IsArClient or data.isActive or isMax) and 0 or 1)
	heroltCtrl = heroltCtrl:getMaxBuffValue(data.skillID)
	heroltCtrl:getMaxBuffValue(data.skillID).lv = data.activeLevel
	self.fields.Text_lockLv:setString(i18n("hero_text_109", heroltCtrl:getMaxBuffValue(data.skillID)))
	local skillInfo = heroltCtrl:getStuntSkillInfo(data.skillID)
	local skillAddition, awakeAddition, stuntAddition, masteryAddition = heroCtrl:getHeroPalaceBuff(self.heroID)
	if skillBack and next(skillBack) then
		local preValue = skillBack[tostring(data.skillID)].buffValue - data.buffValue
		local isCrit = skillBack[tostring(data.skillID)].crit == 1
		self.fields.Bar_skill:setBar(data.buffValue, skillBack[tostring(data.skillID)].buffValue, heroltCtrl:getMaxBuffValue(data.skillID), nil, 494)
		local preStr = ""
		if not isAllMax then
			if 0 < preValue then
				preStr = fguiHelper.getColorString(isCrit and "#FFFF00" or "#70C723", "+" .. SoraDPreciseDecimal(preValue / 1000, 4) * 100 .. "%")
			elseif preValue < 0 and IsArClient then
				preStr = fguiHelper.getColorString("#BE2828", SoraDPreciseDecimal(preValue / 1000, 4) * 100 .. "%")
			end
		end
		if not isMax then
			if IsArClient then
				if preValue == 0 then
					self.controllers.c1:setSelectedIndex(0)
				else
					self.controllers.c1:setSelectedIndex(preValue < 0 and 2 or isCrit and 3 or 1)
				end
			else
				self.controllers.c1:setSelectedIndex(preValue <= 0 and 0 or isCrit and 3 or 1)
			end
			if preValue ~= 0 then
				self:showEffect(isCrit)
			end
		end
		local curStr = fguiHelper.getColorString("#FFFFFF", SoraDPreciseDecimal(data.buffValue / 1000, 4) * 100 .. "%")
		if 0 < stuntAddition then
			curStr = fguiHelper.getColorString("#FFFFFF", SoraDPreciseDecimal(data.buffValue * (1 + stuntAddition / 1000) / 1000, 4) * 100 .. "%")
		end
		self.fields.Text_buff:setString(curStr .. " " .. preStr)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Bar_skill:setBar(data.buffValue, 0, heroltCtrl:getMaxBuffValue(data.skillID), true, 494)
		if 0 < stuntAddition then
			local curVal = data.buffValue * (1 + stuntAddition / 1000)
			local des = SoraDPreciseDecimal(curVal / 10, 2) .. "%"
			local oriStr = SoraDPreciseDecimal(data.buffValue / 10, 2) .. "%"
			local palaceStr = SoraDPreciseDecimal((curVal - data.buffValue) / 10, 2) .. "%"
			heroltCtrl = preStr
			preStr.des = des
			preStr.ori = oriStr
			preStr.add = palaceStr
			self.fields.Text_buff:setString(i18n("%{des}(%{ori}+%{add})", preStr))
		else
			self.fields.Text_buff:setString(SoraDPreciseDecimal(data.buffValue / 1000, 4) * 100 .. "%")
		end
	end
	heroltCtrl = self.fields.Text_buff.setString
	self.fields.Text_buff.setString[gSkillActiveType.PASSIVE_SKILL] = i18n("hero_text_63")
	self.fields.Text_buff.setString[gSkillActiveType.BATTLE_SKILL] = i18n("hero_text_64")
	local self.fields.Text_buff.setString[gSkillActiveType.INITIATIVE_SKILL], desTbl = i18n("hero_text_65"), self.fields.Text_buff.setString
	self.fields.Text_skillName:setString(i18n(skillInfo.des))
	local stuntSkillInfo = heroltCtrl:queryPowerSkillByID(data.skillID)
	self.fields.Text_active:setString(desTbl[stuntSkillInfo.activeType] or i18n("hero_text_63"))
	self.fields.item:setIcon(skillInfo.icon)
end
return list_item_porbar
