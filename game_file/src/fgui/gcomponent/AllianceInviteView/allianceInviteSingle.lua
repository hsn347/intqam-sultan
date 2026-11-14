local lordLocalData = include("lordLocalData")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local allianceInviteSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceInviteView/allianceInviteSingle", allianceInviteSingle)
function allianceInviteSingle:onInit()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function allianceInviteSingle:onShow()
end
function allianceInviteSingle:initData(data, handle)
	self.data = data
	self.handle = handle
	self.fields.Image_portrait:setIcon(lordLocalData.getBust(self.data.iconID))
	self.fields.Text_name:setString(self.data.nickName)
	self.fields.Text_power:setString(string.formatnumberthousands(self.data.totalFc))
	self:setCastleLv(self.data.cityLevel)
	self:setBuildStarLv(self.data.starLv)
end
function allianceInviteSingle:setBuildStarLv(slv)
	local enable = slv and 0 < slv
	self.fields.starLvSprite:setVisible(enable)
	self.fields.starLvText:setVisible(enable)
	if enable then
		local cityltCtrl = include("cityltCtrl")
		self.fields.starLvSprite:setIcon(cityltCtrl.getBuildStarImage(slv))
		self.fields.starLvText:setString(tostring(slv))
	end
end
function allianceInviteSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and warLv >= CASTLE_MIN_WARLV then
		clv = warLv
		castleImg = "301101.png"
	end
	self.fields.Sprite_castle:setIcon(castleImg)
	self.fields.Text_castleLv:setString(tostring(math.min(clv, CASTLE_MAXLV_NOWAR)))
end
function allianceInviteSingle:btnClick()
	SoraDPlaySound()
	if self.handle then
		self.handle(self.data.uid)
	end
end
return allianceInviteSingle
