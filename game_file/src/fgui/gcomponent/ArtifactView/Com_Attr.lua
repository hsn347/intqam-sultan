local equipDesRead = include("equipDesRead")
local attrltCtrl = include("attrltCtrl")
local propParser = include("propParser")
local baseComponent = require("fgui.base.baseComponent")
local Com_Attr = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtifactView/Com_Attr", Com_Attr)
function Com_Attr:onInit()
	self:fixChildrenPos()
end
function Com_Attr:onShow()
end
function Com_Attr:initData(data, lv, awakeStatus)
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
		equipDesRead = propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])
		propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1]).num = data.activeLevel
		self.fields.Text_Next:setString(i18n("artifact_text_01", propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])))
	elseif attrInfoNext then
		self.controllers.c1:setSelectedIndex(0)
		posX = posX + 55
		self.fields.Text_Next:setString(propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfoNext.buffValue[1]))
	else
		self.controllers.c1:setSelectedIndex(2)
	end
	self.fields.Text_Next:setPositionX(SoraDFPosX(525 - posX, 525))
end
return Com_Attr
