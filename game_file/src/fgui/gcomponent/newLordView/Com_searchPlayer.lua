local cityltCtrl = include("cityltCtrl")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchPlayer = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_searchPlayer", Com_searchPlayer)
function Com_searchPlayer:onInit()
	self:fixChildrenPos()
	self.fields.Panel_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
end
function Com_searchPlayer:onShow()
end
function Com_searchPlayer:initData(data)
	dump(data, "data")
	self.tableSingleData = data
	self.fields.Image_portrait:setSpriteFrame(lordLocalData.getBust(self.tableSingleData.iconID))
	self.fields.Text_power:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
	self:setCastleLv(self.tableSingleData.cityLevel)
	self:setBuildStarLv(self.tableSingleData.starLv)
	self.fields.Text_name:setString(self.tableSingleData.nickName)
	if self.tableSingleData.kid and self.tableSingleData.kid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and self.tableSingleData.sourceKid and self.tableSingleData.sourceKid > 0 then
		_ENV = string.formatnumberthousands(self.tableSingleData.totalFc)
		string.formatnumberthousands(self.tableSingleData.totalFc).kid = self.tableSingleData.sourceKid
		self.fields.Text_lastTime:setString(i18n("common_text_342", string.formatnumberthousands(self.tableSingleData.totalFc)))
	elseif self.tableSingleData.kid then
		_ENV = i18n("common_text_342", string.formatnumberthousands(self.tableSingleData.totalFc))
		i18n("common_text_342", string.formatnumberthousands(self.tableSingleData.totalFc)).kid = self.tableSingleData.kid
		self.fields.Text_lastTime:setString(i18n("common_text_342", i18n("common_text_342", string.formatnumberthousands(self.tableSingleData.totalFc))))
	else
		self.fields.Text_lastTime:setString(allianceDesRead.getLanguageName(self.tableSingleData.language))
	end
end
function Com_searchPlayer:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and 1 <= warLv then
		clv = warLv
		castleImg = "301101.png"
	end
	self.fields.Sprite_castle:setSpriteFrame(castleImg)
	self.fields.Text_castleLv:setString(tostring(math.min(clv, CASTLE_MAXLV_NOWAR)))
end
function Com_searchPlayer:setBuildStarLv(slv)
	local enable = slv and 0 < slv
	self.fields.starLvText:setVisible(enable)
	self.fields.starLvSprite:setVisible(enable)
	if enable then
		self.fields.starLvSprite:setSpriteFrame(cityltCtrl.getBuildStarImage(slv))
		self.fields.starLvText:setString(tostring(slv))
	end
end
function Com_searchPlayer:btnClickCallBack()
	SoraDPlaySound()
	local playerID = self.tableSingleData.uid
	local kid = self.tableSingleData.kid
	_ENV = nil
	;(nil).targetName = "gameSearch"
	lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
end
return Com_searchPlayer
