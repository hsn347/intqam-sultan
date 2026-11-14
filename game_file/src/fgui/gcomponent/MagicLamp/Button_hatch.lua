local baseComponent = require("fgui.base.baseComponent")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampHatchRead = include("magicLampHatchRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local constantRead = include("constantRead")
local Button_hatch = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Button_hatch", Button_hatch)
local nebulaWarUtil = include("nebulaWarUtil")
function Button_hatch:onInit()
	self.fields.Button_speedUp:fixPos()
	self.fields.title:setString(i18n("Jinn_hatch_text_1"))
	self.fields.icon:addEventListener(fgui.UIEventType.Click, handler(self, self.onHatchClick))
	self.fields.title2:setString(i18n("magic_lamp_text_145"))
	self.fields.Button_preview:addClickEventListener(handler(self, self.onPreviewClick))
end
function Button_hatch:onShow()
end
function Button_hatch:initData(hatchTypeCfg)
	self.hatchTypeCfg = hatchTypeCfg
	if self.hatchTypeCfg == nil then
		self:setVisible(false)
		return
	end
	self.hatchType = self.hatchTypeCfg.type
	self.hatchJinnType = gJinnType.JINN_ONE
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	if self.hatchData == nil then
		self:setVisible(false)
		return
	end
	self:updatePrivewBtn()
end
function Button_hatch:updatePrivewBtn()
	if self.hatchType == gJinnType.JINN_ONE then
		self:setVisible(true)
		local needHatchLv = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_HATCH_DEMAND", 0))
		local needJinnLv = math.floor(constantRead.getConstValue("ALPHALITE_UNLOCK_MARID_DEMAND", 0))
		local hatchLv = self.hatchData and self.hatchData.lv or 0
		local jinnLv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
		local isPreviewOpen = constantRead.getConstValue("ALPHALITE_UNLOCK_SWITCH", 0)
		local isShowPriviewBtn = isPreviewOpen == 1 and not nebulaWarUtil.getIsNewRegionGroup() and not magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_TWO) and (needHatchLv <= hatchLv or needJinnLv <= jinnLv)
		self.controllers.c1:setSelectedIndex(isShowPriviewBtn and 1 or 0)
		if isShowPriviewBtn then
			magicLampCtrl:reqUnlockInfoFireJinn()
			self.fields.effect_preview:setAllFrameNameOnce("dh_yugaolianx_%02d.png", 1, true)
		end
	else
		self:setVisible(false)
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Button_hatch:updateRedDot()
	local isCanGetReward = magicLampHatchCtrl:getIsCanGetReaward(self.hatchType)
	local isCanUp = magicLampHatchCtrl:getIsCanHatchUp(self.hatchType)
	local isHaveSkillEquip = false
	local isSkillSloatUnlock = magicLampHatchRead.isSkillUnlock(self.hatchType, self.hatchData.lv) and not magicLampCtrl:getIsJinnUnlock(self.hatchJinnType)
	if isSkillSloatUnlock then
		local bigBlessCfgs = magicLampRead.getBigBlessList(self.hatchJinnType)
		local usingSkillID = magicLampCtrl:getBlessSkillId(self.hatchJinnType, bigBlessCfgs[1].BlessID)
		isHaveSkillEquip = usingSkillID == nil and magicLampCtrl:getUnUsedSkill() ~= nil
	end
	local isNeedChoose = self.desireInfo.chooseItemID == 0
	self:setReddot(isCanGetReward or isCanUp or isHaveSkillEquip or isNeedChoose, 0)
end
function Button_hatch:onHatchClick(sender, param)
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.hatchJinnType
	;(nil).hatchType = self.hatchTypeCfg.type
	uiManager:show("MagicLampHatch", nil)
end
function Button_hatch:onPreviewClick()
	SoraDPlaySound()
	uiManager:show("MagicLampNotice")
end
return Button_hatch
