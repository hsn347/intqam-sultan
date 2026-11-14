local baseComponent = require("fgui.base.baseComponent")
local Com_ML_BlessDetials = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_BlessDetials", Com_ML_BlessDetials)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local buffDesRead = include("buffDesRead")
function Com_ML_BlessDetials:onInit()
	self:fixChildrenPos()
	self.fields.button_sure:addClickEventListener(handler(self, self.onBtnClick), false)
	self.fields.button_sure2:addClickEventListener(handler(self, self.onBtnClick), false)
	self.fields.button_max:setTitle(i18n("magic_lamp_text_103"))
	self.fields.button_max:addClickEventListener(handler(self, self.onBtnClick), true)
	self.fields.text_max:setString(i18n("magic_lamp_text_033"))
	self.fields.button_reset:addClickEventListener(handler(self, self.onClickBtnReset))
	self.fields.button_reset:setVisible(false)
end
function Com_ML_BlessDetials:onShow()
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	self.castleStarLv = cityCtrl:getBuildMaxStarLv(BUILDID.CASTLE)
end
function Com_ML_BlessDetials:initData(data, jinnType)
	dump(data, "Com_ML_BlessDetials:initData", 10)
	self.data = data
	self.curType = jinnType
	self.jinnData = magicLampCtrl:getJinnByType(jinnType)
	self.blessNum = self.jinnData.blessPoint
	self.fields.name:setString(i18n(self.data.cfg.BlessName))
	local showReset = self.data.lv > 0
	self.fields.button_reset:setVisible(showReset)
	_ENV = showReset
	showReset.showTips = showReset
	showReset.tips = i18n("magic_lamp_text_132")
	self.fields.Com_guideTips:initMLData(showReset)
	if self.data.cfg.PointType == 2 then
		self:setBlessSkill()
		return
	end
	self.fields.button_sure:setTitle(i18n("magic_lamp_text_100"))
	self.fields.button_sure2:setTitle(i18n("magic_lamp_text_100"))
	self.fields.lv:setString(self.data.lv .. "/" .. self.data.cfg.MaxLv)
	local buffCfg = self.data.cfg.buff[1]
	local value = buffCfg.value
	if buffCfg.type == 1 then
		value = value / 10
	end
	local curDesc = buffDesRead.getTitleWithValue(buffCfg.buffType, value)
	if self.data.lv >= self.data.cfg.MaxLv then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.desc_next:setPositionY(self.fields.name:getPositionY() + 44)
		self.fields.desc_next:setString(curDesc)
		self.nextCfg = nil
	elseif self.data.lv == 0 or self.data.cfg.MaxLv == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.desc_next:setPositionY(self.fields.name:getPositionY() + 44)
		self.fields.desc_next:setString(curDesc)
		self.nextCfg = self.data.cfg
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.lv_now:setString(i18n("common_text_279") .. self.data.lv)
		self.fields.lv_next:setString(i18n("common_text_280") .. self.data.lv + 1)
		local buffCfg = self.data.nextCfg.buff[1]
		local nextValue = buffCfg.value
		if buffCfg.type == 1 then
			nextValue = nextValue / 10
		end
		local nextDesc = buffDesRead.getTitleWithValue(buffCfg.buffType, nextValue)
		self.fields.desc_now:setString(curDesc)
		self.fields.desc_next:setString(nextDesc)
		self.fields.desc_next:setPositionY(self.fields.lv_next:getPositionY() + 24)
		self.nextCfg = self.data.nextCfg
	end
	if self.data.nextCfg then
		self.isEnough = self.blessNum >= self.data.nextCfg.PointCost
		self.fields.text_need:setString(i18n("magic_lamp_text_101") .. self.data.nextCfg.PointCost)
		self.fields.text_need:setColor(self.isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0))
	end
	if self.data.lv < self.data.cfg.MaxLv then
		local errStr = self:getErrStr()
		self.fields.button_sure:setVisible(errStr == nil)
		self.fields.button_sure2:setVisible(errStr == nil)
		self.fields.button_max:setVisible(errStr == nil)
		self.fields.text_error:setVisible(errStr ~= nil)
		if errStr then
			self.fields.text_error:setString(errStr)
		else
			self.fields.text_error:setString("")
		end
		self.fields.text_need:setVisible(errStr == nil)
	else
		self.fields.text_error:setString("")
		self.fields.text_need:setVisible(true)
	end
end
function Com_ML_BlessDetials:setBlessSkill()
	self.nextCfg = self.data.cfg
	self.isEnough = self.blessNum >= self.data.cfg.PointCost
	self.controllers.c1:setSelectedIndex(3)
	self.fields.button_sure:setTitle(i18n("common_text_740"))
	self.fields.button_sure2:setTitle(i18n("common_text_740"))
	self.fields.text_need:setString(i18n("magic_lamp_text_101") .. self.data.cfg.PointCost)
	self.fields.text_need:setColor(self.isEnough and cc.c3b(255, 255, 255) or cc.c3b(180, 0, 0))
	self.fields.desc_next:setPositionY(self.fields.name:getPositionY() + 44)
	self.fields.desc_next:setString(i18n("magic_lamp_text_034"))
	local errStr = self:getErrStr()
	self.fields.button_sure:setVisible(errStr == nil)
	self.fields.button_sure2:setVisible(errStr == nil)
	self.fields.button_max:setVisible(errStr == nil)
	self.fields.text_error:setVisible(errStr ~= nil)
	self.fields.text_need:setVisible(errStr == nil)
	if errStr then
		self.fields.text_error:setString(errStr)
	else
		self.fields.text_error:setString("")
	end
end
function Com_ML_BlessDetials:getErrStr()
	local errStr
	if self.nextCfg.PreCastleStarLv ~= nil and self.castleStarLv < self.nextCfg.PreCastleStarLv then
		_ENV = nil
		;(nil).lv = self.nextCfg.PreCastleStarLv
		errStr = i18n("magic_lamp_tips_008", nil)
	elseif self.jinnData.lv < self.nextCfg.PreJinnLv then
		_ENV = nil
		;(nil).lv = self.nextCfg.PreJinnLv
		errStr = i18n("magic_lamp_tips_006", nil)
	else
		for k, v in pairs(self.nextCfg.PreBlessID) do
			local lv = magicLampCtrl:getBlessLv(self.nextCfg.JinnType, v.BlessID)
			if lv == nil or lv < v.lv then
				local cfg = magicLampRead.getBlessCfg(v.BlessID * 100 + v.lv)
				_ENV = nil
				;(nil).name = i18n(cfg.BlessName)
				;(nil).lv = v.lv
				errStr = i18n("magic_lamp_tips_007", nil)
				break
			end
		end
	end
	return errStr
end
function Com_ML_BlessDetials:setHideCallback(hideCallback)
	self.hideCallback = hideCallback
end
function Com_ML_BlessDetials:onBtnClick(sender, isMax)
	SoraDPlaySound()
	if not self.isEnough then
		SoraDShowMsgTip(i18n("magic_lamp_tips_005"))
	else
		magicLampCtrl:reqMagicLampUpgradeBless(self.curType, self.data.BlessID, isMax)
	end
	if self.hideCallback then
		self.hideCallback()
	end
end
function Com_ML_BlessDetials:onClickBtnReset(...)
	SoraDPlaySound()
	local nextBlessIDList = magicLampRead.getNextBlessIDList(self.data.BlessID)
	local needLv = 0
	for i, v in ipairs(nextBlessIDList) do
		if 0 < magicLampCtrl:getBlessLv(self.curType, v.blessID) then
			needLv = math.max(needLv, v.needLv)
		end
	end
	if needLv >= self.data.lv then
		SoraDShowMsgTip(i18n("magic_lamp_text_117"))
		return
	end
	local constantRead = include("constantRead")
	local BLESSPOINT_RESET_GOLD = constantRead.getConstValue("BLESSPOINT_RESET_GOLD", 0)
	local pointCost = magicLampRead.getBlessLvToLvPointCost(self.data.BlessID, self.data.lv, needLv)
	local goldCost = BLESSPOINT_RESET_GOLD * pointCost
	local panel = SoraDShowMsgBox(i18n("magic_lamp_text_116"), nil, nil, function(exitType)
		if MSGBOX_CALLBACK_YES == exitType and SoraDEnoughGold(goldCost) then
			SoraDPlaySound()
			magicLampCtrl:reqResetBlessLv(self.curType, self.data.BlessID)
			if self.hideCallback then
				self.hideCallback()
			end
		end
	end, nil, nil, true)
	panel:setTextAndGoldOnYesBtn(goldCost, i18n("common_text_4152"), true)
	self.fields.Com_guideTips:setVisible(false)
end
return Com_ML_BlessDetials
