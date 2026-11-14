local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_ranksSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_ranksSingle", Com_ranksSingle)
function Com_ranksSingle:onInit()
	self:fixChildrenPos()
end
function Com_ranksSingle:onShow()
end
function Com_ranksSingle:initData(data, rank, isCampRank)
	roaringFlameWarRead = nil
	;(nil).rank = data.rank or rank
	self.fields.Com_rankBase:initRankBaseData(nil)
	if isCampRank then
		self.fields.Com_head:setVisible(false)
		self.fields.icon:setVisible(true)
		local campCfg = roaringFlameWarRead.getCampCfg(data.member)
		self.fields.icon:setSpriteFrame(campCfg.icon)
		self.fields.Text_camp:setString(i18n(campCfg.name))
		self.fields.Text_camp:setColor(SoraDHtmlColor2RGB(campCfg.color))
		local info = roaringFlameWarCtrl:getMatchResult(data.member)
		if info and next(info) then
			roaringFlameWarRead = SoraDHtmlColor2RGB(campCfg.color)
			SoraDHtmlColor2RGB(campCfg.color).kid = info.kid
			SoraDHtmlColor2RGB(campCfg.color).name = info.kingdomName
			self.fields.Text_kingdom:setString(i18n("#%{kid}  %{name}", SoraDHtmlColor2RGB(campCfg.color)))
		else
			self.fields.Text_kingdom:setString("")
		end
	else
		self.fields.Com_head:setVisible(true)
		self.fields.icon:setVisible(false)
		self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
		self.fields.Com_head:setPlayerID(data.member)
		self.fields.Text_camp:setString(textParser.formatAllianceName(data.allianceAbbr, data.playerName))
		self.fields.Text_camp:setColor(SoraDHtmlColor2RGB("#D7C39B"))
		local campName = roaringFlameWarRead.getCampName(data.campId)
		local campColor = roaringFlameWarRead.getCampColor(data.campId)
		roaringFlameWarRead = SoraDHtmlColor2RGB("#D7C39B")
		SoraDHtmlColor2RGB("#D7C39B").camp = fguiHelper.getColorString(SoraDRGB2HtmlColor(campColor), campName)
		SoraDHtmlColor2RGB("#D7C39B").kid = data.kid
		self.fields.Text_kingdom:setString(i18n("%{camp}#%{kid}", SoraDHtmlColor2RGB("#D7C39B")))
	end
	self.fields.Text_score:setString(string.formatnumberthousands(math.floor(data.score)))
end
return Com_ranksSingle
