local lordSkillDesRead = include("lordSkillDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local lordSkillModuleAPI = include("lordSkillModuleAPI")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroComboSkillCtrl = SoraDGetCtrl("heroComboSkillCtrl")
local baseComponent = require("fgui.base.baseComponent")
local skillActiveIcon = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/skillActiveIcon", skillActiveIcon)
function skillActiveIcon:onInit()
	self.fields.Text_cdTip:setString(i18n("common_text_046"))
	self.fields.lock:setVisible(true)
end
function skillActiveIcon:onShow()
end
function skillActiveIcon:initData(data)
	self.data = data
	self.iconType = lordSkillModuleAPI:getSkillType(self.data.skillID)
	self:showByIconType()
	self.fields.Image_icon:setSpriteFrame(lordSkillDesRead.getIcon(self.data.skillID))
	self.fields.Text_name:setString(lordSkillDesRead.getName(self.data.skillID))
	local isOpen = self.data.isOpened and self.data.currentLevel >= 1
	self:changeState(isOpen)
	self.fields.lock:setVisible(not isOpen)
	self:showQueue()
end
function skillActiveIcon:initDataEX(data)
	self.data = data
	self.fields.Image_iconBg:setSpriteFrame("frame_shengqi_di.png")
	self.skillInfo = heroltCtrl:getCombosSkillInfo(self.data.skillID)
	self.fields.Image_icon:setSpriteFrame(self.skillInfo.skillIcon)
	self.fields.Text_name:setString(i18n(self.skillInfo.skillName))
	local isOpen = false
	local cfg = heroltCtrl:getDressSerSkilCfg(self.data.skillID)
	if heroCtrl:getHeroInfoByID(cfg.heroID) and cfg.lieutenant ~= 0 and heroCtrl:getHeroInfoByID(cfg.lieutenant) then
		isOpen = true
	end
	self:changeState(isOpen)
	self.fields.lock:setVisible(not isOpen)
	self.controllers.c_cd:setSelectedIndex(0)
	self.controllers.c_cdtip:setSelectedIndex(0)
end
function skillActiveIcon:changeState(isOpened)
	self.controllers.c_lock:setSelectedIndex(isOpened and 0 or 1)
end
function skillActiveIcon:showQueue()
	self.controllers.c_cd:setSelectedIndex(0)
	self.controllers.c_cdtip:setSelectedIndex(0)
	if self.data.isOpened and self.data.currentLevel >= 1 then
		local buffid = lordSkillDesRead.getBuffID(self.data.skillID)
		local isOpen, buff = buffCtrl:isBuffOpen(buffid)
		local bufRemainTime = buffCtrl:getRemainTimeByBuffID(buffid)
		local isInCD, cdTime = lordSkillModuleAPI:skillInCD(self.data.skillID)
		if isOpen then
			if bufRemainTime and 0 < bufRemainTime then
				self.controllers.c_cd:setSelectedIndex(1)
				self.fields.Text_cd:beginTime(bufRemainTime)
			end
		elseif isInCD then
			self.controllers.c_cd:setSelectedIndex(1)
			self.controllers.c_cdtip:setSelectedIndex(1)
			self.fields.Text_cd:beginTime(cdTime)
		end
	end
end
function skillActiveIcon:showByIconType()
	local bgImgName = "frame_round_01.png"
	if self.iconType == gLordSkillType.AUXILIARY then
		bgImgName = "frame_round_lordskill_01.png"
	elseif self.iconType == gLordSkillType.DEVELOP then
		bgImgName = "frame_round_lordskill_02.png"
	elseif self.iconType == gLordSkillType.BATTLE then
		bgImgName = "frame_round_lordskill_03.png"
	end
	self.fields.Image_iconBg:setSpriteFrame(bgImgName)
end
return skillActiveIcon
