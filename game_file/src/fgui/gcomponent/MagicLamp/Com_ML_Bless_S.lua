local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Bless_S = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Bless_S", Com_ML_Bless_S)
fgui.register_extension("ui://MagicLamp/Com_ML_Bless_M", Com_ML_Bless_S)
fgui.register_extension("ui://MagicLamp/Com_ML_Bless_S2", Com_ML_Bless_S)
fgui.register_extension("ui://MagicLamp/Com_ML_Bless_M2", Com_ML_Bless_S)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
_ENV = "magicLampRead"
;("magicLampRead").lamp1 = "dh_zndzf_pyui_%02d.png"
local _ENV, ("magicLampRead").lamp2, aniNames1 = nil, "dh_chongzhi01_%02d.png", "magicLampRead"
;(nil).lamp1 = "dh_zndzf_gjui_%02d.png"
local (nil).lamp2, aniNames2 = "dh_chongzhi01_%02d.png", nil
function Com_ML_Bless_S:onInit()
	self.lampType = "lamp1"
	self:addEventListener(fgui.UIEventType.Click, function(eventContext)
		if self.clickCallback ~= nil then
			if SoraDIsGameGuide() and self.data.cfg.PointType == 2 and self.data.lv ~= 0 then
				self.clickCallback(self.data, nil, self)
				return
			end
			self.clickCallback(self.data, eventContext:getInput():getPosition(), self)
		end
	end)
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	self.castleStarLv = cityCtrl:getBuildMaxStarLv(BUILDID.CASTLE)
end
function Com_ML_Bless_S:setLampType(lampType)
	self.lampType = lampType
end
function Com_ML_Bless_S:onShow()
	self.customData = self.lampType
	if self.aniInited then
		local aniName = self.data.cfg.PointType == 2 and aniNames2[self.customData] or aniNames1[self.customData]
		self.fields.ani_choosed:setAllFrameName(aniName, 1)
		self.fields.ani_choosed:setPlaySettings(0, -1, -1)
	end
end
function Com_ML_Bless_S:initData(data, delayShow)
	self.data = data
	if not data.cfg then
		return
	end
	self.fields.title:setString(data.lv .. "/" .. data.cfg.MaxLv)
	local isReset = self.oldLv ~= nil and self.data.lv < self.oldLv
	if self.data.lv > 0 then
		self:setGrayed(false)
		self:updateMagicSkill()
		self:setActiveAni(delayShow, 0.5)
		local isUpgrade = self.oldLv ~= nil and self.data.lv > self.oldLv
		self.oldLv = self.data.lv
		return true, isUpgrade, isReset
	end
	self.oldLv = self.data.lv
	self.fields.ani_choosed:setVisible(false)
	self.controllers.c1:setSelectedIndex(1)
	if self.data.cfg.PreCastleStarLv ~= nil and self.castleStarLv < self.data.cfg.PreCastleStarLv then
		self:setGrayed(true)
		return false, false, isReset
	end
	local lv = magicLampCtrl:getJinnByType(data.cfg.JinnType).lv
	if lv < self.data.cfg.PreJinnLv then
		self:setGrayed(true)
		return false, false, isReset
	end
	for k, v in pairs(data.cfg.PreBlessID) do
		local lv = magicLampCtrl:getBlessLv(data.cfg.JinnType, v.BlessID)
		if lv == nil or lv < v.lv then
			self:setGrayed(true)
			return false, false, isReset
		end
	end
	self:setGrayed(false)
	return true, false, isReset
end
function Com_ML_Bless_S:setBlessClick(callback)
	self.clickCallback = callback
end
function Com_ML_Bless_S:setActiveAni(delayShow, alpha)
	if not self.aniInited then
		self.aniInited = true
		if self.customData then
			local aniName = self.data.cfg.PointType == 2 and aniNames2[self.customData] or aniNames1[self.customData]
			self.fields.ani_choosed:setAllFrameName(aniName, 1)
			self.fields.ani_choosed:setPlaySettings(0, -1, -1)
		end
	end
	self.fields.ani_choosed:setVisible(false)
	if delayShow then
		aniNames1 = 0
		;(0)[1] = ffa.delay(delayShow)
		;(0)[2] = ffa.callFunc(function()
			self.fields.ani_choosed:setVisible(true)
		end)
		;(0)[3] = ffa.callFunc(function()
			self.fields.ani_choosed:setVisible(true)
		end)
		self.fields.ani_choosed:runAction(ffa.seq(0))
	else
		self.fields.ani_choosed:setVisible(true)
	end
	self.fields.ani_choosed:setAlpha(alpha)
end
function Com_ML_Bless_S:updateMagicSkill()
	if self.data.cfg.PointType ~= 2 then
		self.controllers.c1:setSelectedIndex(0)
		return
	end
	local skillId = magicLampCtrl:getBlessSkillId(self.data.cfg.JinnType, self.data.BlessID)
	if skillId then
		self.fields.Com_skill:initDataById(skillId)
	end
	self.controllers.c1:setSelectedIndex(skillId == nil and 0 or 2)
end
return Com_ML_Bless_S
