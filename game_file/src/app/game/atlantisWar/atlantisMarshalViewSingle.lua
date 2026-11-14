local allianceDesRead = include("allianceDesRead")
local mapSyncUtilClient = include("mapSyncUtilClient")
local AMB = require_data("atlantiswar_map_build", true).data
local AMBC = require_data("atlantiswar_map_build_config").data
local atlantisMarshalViewSingle = class("atlantisMarshalViewSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisMarshalViewSingle")
	end
	return target
end)
function atlantisMarshalViewSingle:ctor()
	self:initWidget()
end
function atlantisMarshalViewSingle:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	SoraDChangeTextToHtml(self.Text_point)
	self.Text_point = SoraDCreatePanelByCloneNode(self.Text_point, "commonBtnInstance")
	self.Text_point:setHandle(handler(self, self.onTextEvent))
	self.Text_marshal:setString(i18n("atlantiswar_text_0126"))
	self.ccs_scroe = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisKingdomScroe_1")
	local constantRead = include("constantRead")
	local score_max = constantRead.getConstValue("ATLANTISWAR_JOB_BAR_UP", 0)
	self.ccs_scroe:setScoreMax(score_max)
	self:initCriSpriteEffect()
end
function atlantisMarshalViewSingle:initCriSpriteEffect(...)
	local criSprite = cc.criSprite.createCriSprite("shuaiweizd1.usm", false, true, nil)
	criSprite:addTo(self.Panel_single)
	criSprite:setPosition(300, 150)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	if SoraDFIsRA() then
		criSprite:setScale(-1, 1)
	end
	self.frame_shmc_flag_01_1:setVisible(false)
	self.Image_1:setVisible(false)
end
function atlantisMarshalViewSingle:initData(data, otherData)
	self.buildId = data.buildId
	self.cmdPostOwner = data.cmdPostOwner
	self.scroll = otherData.scroll
	local config = AMB[self.buildId]
	self.point = mapSyncUtilClient.serverTOClientPos(cc.p(config.x, config.y))
	self.Sprite_building:setSpriteFrame(AMBC[self.buildId].image)
	self.Text_name:setString(i18n(AMBC[self.buildId].name))
	local pointStr = string.format("%d,%d", self.point.x, self.point.y)
	AMB = i18n(AMBC[self.buildId].name)
	i18n(AMBC[self.buildId].name).underline = true
	self.Text_point:setString(SoraDWrapHtmlTagByStyle(pointStr, i18n(AMBC[self.buildId].name)))
	self.Text_point:setScroll(self.scroll)
	self.Sprite_flag:setSpriteFrame("icon_shmc_kingdomflag_01.png")
	self.Sprite_flag:setScale(1.0)
	if self.cmdPostOwner and next(self.cmdPostOwner) then
		self.Text_owerName:setString(serviceFunctions.getKingdomFormatName(self.cmdPostOwner.kingdomName, self.cmdPostOwner.kid))
		if self.cmdPostOwner.flag then
			self.Sprite_flag:setSpriteFrame(allianceDesRead.getFlagIcon(self.cmdPostOwner.flag))
			self.Sprite_flag:setScale(0.35)
		end
	else
		self.Text_owerName:setString(i18n("common_text_480"))
	end
	self.ccs_scroe:initData(data.scoreData)
end
function atlantisMarshalViewSingle:onTextEvent(target, event)
	SoraDGotoWorldMapPoint(self.point)
	SoraDRemoveAllPanelFromManager()
end
return atlantisMarshalViewSingle
