local roaringFlameWarRead = include("roaringFlameWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_campBuildSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_campBuildSingle", Com_campBuildSingle)
function Com_campBuildSingle:onInit()
	self.fields.Text_pos:addClickListener(handler(self, self.onClickBtnPos))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_campBuildSingle:onShow()
end
function Com_campBuildSingle:initData(objId)
	self.objId = objId
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local buildImage = roaringFlameWarRead.getBuildImage(subType)
	self.fields.Load_build:setURL(buildImage)
	local buildLv = roaringFlameWarRead.getBuildLevel(objId)
	roaringFlameWarRead = nil
	;(nil).lv = buildLv
	self.fields.Text_lv:setString(i18n("common_text_101", nil))
	local buildName = roaringFlameWarRead.getBuildName(subType)
	self.fields.Text_name:setString(buildName)
	local pos = roaringFlameWarRead.getBuildCoord(objId)
	roaringFlameWarRead = i18n("common_text_101", nil)
	i18n("common_text_101", nil).x = pos.x
	i18n("common_text_101", nil).y = pos.y
	local posStr = i18n("common_text_2155", i18n("common_text_101", nil))
	self.fields.Text_pos:setString(posStr)
	roaringFlameWarRead, self.pos = self.fields.Text_pos.setString, pos
	self.fields.Text_pos.setString[gWorldTypeServerDef.subTypeRoaringFlameWarStation] = true
	local self.fields.Text_pos.setString[gWorldTypeServerDef.subTypeRoaringFlameWarRuins], config = true, self.fields.Text_pos.setString
	if config[subType] then
		self.fields.Image_des:setVisible(true)
		self.fields.Text_des:setVisible(true)
		local score = roaringFlameWarRead.getBuildCostPoint(objId)
		roaringFlameWarRead = i18n("common_text_101", nil)
		i18n("common_text_101", nil).num = score
		self.fields.Text_des:setString(i18n("flames_dunes_text95", i18n("common_text_101", nil)))
	else
		self.fields.Image_des:setVisible(false)
		self.fields.Text_des:setVisible(false)
	end
end
function Com_campBuildSingle:onClickBtnPos()
	SoraDPlaySound()
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	SoraDGotoWorldMapPoint(self.pos, true)
	SoraDRemoveAllPanelFromManager()
end
return Com_campBuildSingle
