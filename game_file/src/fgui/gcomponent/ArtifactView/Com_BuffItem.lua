local equipDesRead = include("equipDesRead")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_BuffItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtifactView/Com_BuffItem", Com_BuffItem)
function Com_BuffItem:onInit()
	self:fixChildrenPos()
end
function Com_BuffItem:onShow()
end
function Com_BuffItem:initData(data, lv, awakeStatus)
	if data.index and data.index == 1 then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
	if data.skillID then
		self.fields.Text_title:setString(i18n("Weapon_Rune_tips_063"))
		local attrInfo = equipDesRead.getArtifactAttrInfo(data.skillID, lv, awakeStatus)
		local attrInfoNext = equipDesRead.getArtifactAttrInfo(data.skillID, lv + 1, awakeStatus)
		if lv == ARMS_MAX_LEVEL_NORMAL and awakeStatus == ARMS_AWAKE_STATUS.STATUS_NORMAL then
			attrInfoNext = equipDesRead.getArtifactAttrInfo(data.skillID, lv, ARMS_AWAKE_STATUS.STATUS_AWAKE)
		elseif lv == ARMS_MAX_LEVEL_ADVANCE then
			attrInfoNext = nil
		end
		self.fields.title:setString(equipDesRead.getArtifactSkillName(data.skillID, awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE))
		self.fields.Text_Now:setString(propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1]))
		local posX = self.fields.Text_Now:getPositionX() + self.fields.Text_Now:getContentSize().width + 5
		if lv < data.activeLevel then
			self.controllers.c1:setSelectedIndex(1)
			_ENV = propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])
			propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1]).num = data.activeLevel
			self.fields.Text_Next:setString(i18n("artifact_text_01", propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])))
		elseif attrInfoNext then
			self.controllers.c1:setSelectedIndex(0)
			posX = posX + 55
			self.fields.Text_Next:setString(propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfoNext.buffValue[1]))
		else
			self.controllers.c1:setSelectedIndex(2)
		end
	else
		self:initRune(data)
	end
end
function Com_BuffItem:initRune(data)
	self.fields.Text_title:setString(i18n("Weapon_Rune_tips_062"))
	self.fields.title:setString(data.base)
	self.fields.Text_Now:setString(data.value)
	self.controllers.c1:setSelectedIndex(2)
end
return Com_BuffItem
