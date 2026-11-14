local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local worldResourceDetailView = class("worldResourceDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldResourceDetailView")
	end
	return target
end)
function worldResourceDetailView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.icon_res = SoraDGetChildByName(self, "icon_res")
	self.Text_owner = SoraDGetChildByName(self, "Text_owner")
	self.Text_pro = SoraDGetChildByName(self, "Text_pro")
	self.Text_pro:setString(i18n("alliance_stronghold_text_003"))
	self.Text_alli = SoraDGetChildByName(self, "Text_alli")
	self.Text_alli:setString(i18n("alliance_stronghold_text_065"))
	self.icon_smalla = SoraDGetChildByName(self, "icon_smalla")
	self.Text_proa = SoraDGetChildByName(self, "Text_proa")
	self.Text_mem = SoraDGetChildByName(self, "Text_mem")
	self.Text_mem:setString(i18n("alliance_stronghold_text_066"))
	self.icon_smallm = SoraDGetChildByName(self, "icon_smallm")
	self.Text_prom = SoraDGetChildByName(self, "Text_prom")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_001"))
	self.Text_rule = SoraDGetChildByName(self, "Text_rule")
	self.Text_rule:setString(i18n("alliance_stronghold_text_067"))
end
function worldResourceDetailView:initData(data)
	if data.mapInstance.leagueID and data.mapInstance.leagueID > 0 then
		_ENV = nil
		;(nil).abbr = data.mapInstance.leagueAbbrName
		;(nil).name = data.mapInstance.leagueName or ""
		self.Text_owner:setString(i18n("common_text_186", nil))
	else
		self.Text_owner:setString(i18n("common_text_480"))
	end
	_ENV = allianceStrongholdMineRead.getMineName(data.resourceType)
	allianceStrongholdMineRead.getMineName(data.resourceType).x = data.resPos.x
	allianceStrongholdMineRead.getMineName(data.resourceType).y = data.resPos.y
	self.ccs_bg:setTitleName(i18n(allianceStrongholdMineRead.getMineName(data.resourceType)) .. i18n("(%{x},%{y})", allianceStrongholdMineRead.getMineName(data.resourceType)))
	self.icon_res:setSpriteFrame(allianceStrongholdMineRead.getMineImage(data.resourceType))
	local resCfg = allianceBuildingltCtrl:getMineCfg(data.resourceType)
	self.icon_smalla:setSpriteFrame(publicRead.getSmallIcon(resCfg.outputId))
	self.icon_smallm:setSpriteFrame(publicRead.getSmallIcon(resCfg.outputId))
	_ENV = publicRead.getSmallIcon(resCfg.outputId)
	publicRead.getSmallIcon(resCfg.outputId).var = SoraDConvertNumberWithUnit(resCfg.outputNum)
	self.Text_proa:setString(i18n("+%{var}/h", publicRead.getSmallIcon(resCfg.outputId)))
	local cofe = constantRead.getConstValue("MEMBER_RES_MINE_COFE")
	_ENV = i18n("+%{var}/h", publicRead.getSmallIcon(resCfg.outputId))
	i18n("+%{var}/h", publicRead.getSmallIcon(resCfg.outputId)).var = SoraDConvertNumberWithUnit(resCfg.outputNum * cofe)
	self.Text_prom:setString(i18n("+%{var}/h", i18n("+%{var}/h", publicRead.getSmallIcon(resCfg.outputId))))
end
return worldResourceDetailView
